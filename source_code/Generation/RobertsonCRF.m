function [lin_fun, max_lin_fun] = RobertsonCRF(stack, stack_exposure, max_iterations, err_threshold, bNormalize)
%
%       [lin_fun, max_lin_fun] = RobertsonCRF(stack, stack_exposure, max_iterations, err_threshold, bNormalize)
%
%       This function computes camera response function using Mitsunaga and
%       Nayar method.
%
%        Input:
%           -stack: a stack of LDR images. If the stack is a single or
%           double values are assumed to be in [0,1].
%           -stack_exposure: an array containg the exposure time of each
%           image. Time is expressed in second (s)
%           -max_iterations: max number of iterations
%           -err_threshold: threshold after which the function can stop
%           -bNormalize: if 1 it enables function normalization
%
%        Output:
%           -lin_fun: tabled function
%           -max_lin_fun: maximum value of the inverse CRF
%
%     Copyright (C) 2016  Francesco Banterle
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

if(isempty(stack))
    error('RobertsonCRF: a stack cannot be empty!');
end

if(isempty(stack_exposure))
    error('RobertsonCRF: a stack_exposure cannot be empty!');
end

if(~exist('err_threshold', 'var'))
    err_threshold = 1e-5;
end

if(~exist('bNormalize', 'var'))
    bNormalize = 0;
end

if(~exist('max_iterations', 'var'))
    max_iterations = 15;
end

if(isa(stack, 'double'))
    stack = uint8(ClampImg(round(stack * 255), 0, 255));
end

if(isa(stack, 'single'))
    stack = uint8(ClampImg(round(stack * 255), 0, 255));
end

if(isa(stack, 'uint16'))
    stack = uint8(stack / 255);
end

col = size(stack, 3);

lin_fun = zeros(256, col);

for i=1:col
    lin_fun(:, i) = (0:255) / 255;
end

global minM;
global maxM;

x = (0:255) / 255;

w = WeightFunction(x, 'Robertson', 0);

minM = 0;
for m=0:255
    if(w(m + 1) > 0.0)
        minM = m;
        break;
    end
end

maxM = 255;
for m=255:-1:0
    if(w(m + 1) > 0.0)
        maxM = m;
        break;
    end
end

global stack_min;
global stack_max;

[~, t_min] = min(stack_exposure);
[~, t_max] = max(stack_exposure);
stack_min = ClampImg(single(stack(:,:,:,t_min)) / 255.0, 0.0, 1.0);
stack_max = ClampImg(single(stack(:,:,:,t_max)) / 255.0, 0.0, 1.0);

global minSatTime;

minSatTime = 1e10 * ones(col, 1);

for j=1:col
    for i=1:length(stack_exposure)
        tmp = stack(:,:,j,i);
        
        if(~isempty(find(tmp == 255)))
            if(stack_exposure(i) < minSatTime(j))
                minSatTime(j) = stack_exposure(i);
            end
        end
    end
end

for i=1:max_iterations
    lin_fun_prev = lin_fun;
    
    %normalization CRF
    lin_fun = Normalization(lin_fun);

    %update X
    x_tilde = Update_X(stack, stack_exposure, lin_fun);
    
    %update the iCRF
    lin_fun = Update_lin_fun(x_tilde, stack, stack_exposure, lin_fun); 
            
    %compute error
    delta = (lin_fun_prev - lin_fun).^2;
    err = mean(delta(:));
    
    %disp([i, err]);
    
    if(err < err_threshold)
        break;
    end
end

max_lin_fun = max(lin_fun(:));

if(bNormalize)    
    for i=1:col
        lin_fun(:,i) = lin_fun(:,i) / max_lin_fun;
    end
    
    lin_fun = ClampImg(lin_fun, 0.0, 1.0);
end

% %poly-fit (rational)
% if(bPolyFit)
%     ft = fittype( 'rat33' );
%     opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
%     opts.Display = 'Off';
%     opts.StartPoint = ones(7, 1);
% 
%     for i=1:col    
%         [xData, yData] = prepareCurveData(x', lin_fun(:,i));
%         [fit_ret, ~] = fit( xData, yData, ft, opts );    
%         lin_fun(:,i) = feval(fit_ret, x');
%     end
% end

end

function lin_fun = Normalization(lin_fun)
    col = size(lin_fun, 2);
    
    for j=1:col
        lf = lin_fun(:, j);
        
        index_min = 1;
        for minIndx=1:256
            if(lf(minIndx) > 0.0)
                index_min = minIndx;
                break;
            end
        end
        
        index_max = 256;
        for maxIndx=256:-1:1
            if(lf(maxIndx) > 0.0)
                index_max = maxIndx;
                break;
            end
        end        

        index = index_min + round((index_max - index_min) / 2);
        
        mid = lf(index);
        
        if(mid == 0.0)
            while(index < 256 && lf(index) == 0.0)
                index = index + 1;
            end
            
            mid = lf(index);
        end
        
        if(mid > 0.0)
            lin_fun(:,j) = lin_fun(:,j) / mid;
        end
    end
end

function imgOut = Update_X(stack, stack_exposure, lin_fun)
    global stack_min;
    global stack_max;
    global minM;
    global maxM;

    [r, c, col, n] = size(stack);

    %for each LDR image...
    imgOut    = zeros(r, c, col, 'single');
    totWeight = zeros(r, c, col, 'single');

    max_t = -ones(r, c, col);
    min_t = 1e10 * ones(r, c, col);
    
    for i=1:n        
        t = stack_exposure(i);   
        m = stack(:,:,:,i);
        
        indx = find(m > maxM);
        min_t(indx) = min(min_t(indx), t); 
        
        indx = find(m < minM);        
        max_t(indx) = max(max_t(indx), t); 
 
        %normalizing m values in [0,1]
        tmpStack = ClampImg(single(m) / 255.0, 0.0, 1.0);
        
        %computing the weight function    
        weight  = WeightFunction(tmpStack, 'Robertson', 0);
        
        tmpStack = tabledFunction(tmpStack, lin_fun); 

        %summing things up... 
        indx = find(tmpStack > stack_min & tmpStack < stack_max);
        
        if(t > 0.0 && ~isempty(indx))                 
            imgOut(indx) = imgOut(indx) + (weight(indx) .* tmpStack(indx)) * t;
            totWeight(indx) = totWeight(indx) + weight(indx) * t * t;
        end
    end

    imgOut = imgOut ./ totWeight;
    
    %taking care of saturated pixels
    saturation = 1e-4;
    imgOut(totWeight < saturation & totWeight > 0.0) = -1.0;

    for i=1:col
        io = imgOut(:,:,i);
        tw = totWeight(:,:,i);
        mxt = max_t(:,:,i);
        mnt = min_t(:,:,i);
        
        indx = find(tw == 0.0 & mxt > -1.0);
        io(indx) = lin_fun(minM, i) ./ mxt(indx);
        
        indx = find(tw == 0.0 & mnt < 1e10);
        io(indx) = lin_fun(maxM, i) ./ mnt(indx);        
        
        imgOut(:,:,i) = io;
    end
        
end

function f_out = Update_lin_fun(x_tilde, stack, stack_exposure, lin_fun)
    col = size(x_tilde, 3);

    n = length(stack_exposure);
    f_out = zeros(size(lin_fun));

    global minSatTime;

    for i=1:col
        x_tilde_i = x_tilde(:,:,i);
            
        cardEm = zeros(256, 1);
        sumEm = zeros(256, 1);
        
        %for m values in [0,254]
        for m=0:254
            mp = m + 1;

            for k=1:n
                t = stack_exposure(k);
                
                tmp = stack(:,:,i,k);

                x = x_tilde_i((tmp == m) & (x_tilde_i > 0.0));
                
                sumEm(mp) = sumEm(mp) + t * sum(x(:));

                cardEm(mp) = cardEm(mp) + length(x(:));
            end  
        end
        
        %for m = 255
        cardEm(256) = 1; 
        
        m = 255;
        sumEm(256) = 1e10;
        for k=1:n
        	t = stack_exposure(k);
            
            tmp = stack(:,:,i,k);

            x = x_tilde_i((tmp == m) & (x_tilde_i > 0.0));            
            
            if(~isempty(x) & (t == minSatTime))
               sumEm(256) = min([sumEm(256); t * x(:)]);
            end
        end        
                
        %computing f_out + filling
        prev = 0.0;
        for m=1:256
            if(cardEm(m) > 0.0)
                f_out(m,i) = sumEm(m) / cardEm(m);
                prev = f_out(m,i);
            else
                f_out(m,i) = prev;
            end
        end
    end
end