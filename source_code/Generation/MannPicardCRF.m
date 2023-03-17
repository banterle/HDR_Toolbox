function [lin_fun, gamma_param] = MannPicardCRF(stack, stack_exposure)
%
%       [lin_fun, gamma_param] = MannPicardCRF(stack, stack_exposure)
%
%       This function computes camera response function using Mann and
%       Picard methods.
%
%        Input:
%           -stack: a stack of LDR images. If the stack is a single or
%           double values are assumed to be in [0,1].
%           -stack_exposure: an array containg the exposure time of each
%           image. Time is expressed in second (s)
%
%        Output:
%           -lin_fun: the inverse CRF as a LUT
%           -gamma_param: the inverse CRF as parametric model:
%
%                   (x + gamma_param(1,c)).^gamma_param(2,c);
%       
%            where c is a color channel
%

if(isempty(stack))
    error('MannPicardCRF: a stack cannot be empty!');
end

if(isempty(stack_exposure))
    error('MannPicardCRF: a stack_exposure cannot be empty!');
end

if(size(stack, 4) ~= length(stack_exposure))
    error('stack and stack_exposure have different number of exposures');
end

if(isa(stack, 'uint8'))
    stack = single(stack) / 255.0;
end

if(isa(stack, 'uint16'))
    stack = single(stack) / 65535.0;
end

[~, ~, col, n] = size(stack);

[stack, stack_exposure] = SortStack( stack, stack_exposure, 'ascend');

if(n > 2)
    vec = zeros(n - 1, 1);
    
    for i=2:n             
        tot = 0;
        for c=1:col
            img = stack(:,:,c,i);

            tot = tot + length(find(img > 0.05 & img < 0.95));
        end
        
        vec(i - 1) = tot;
    end

    [~, i] = max(vec);

    i = i - 1;
else
    i = 1;
end

gamma = zeros(1, col);
alpha = zeros(1, col);
  
k = stack_exposure(i + 1) / stack_exposure(i);

for c=1:col
    img1 = stack(:,:,c,i);
    img2 = stack(:,:,c,i + 1);
    
    try
        f = fit(img1(img2<0.95), img2(img2<0.95), 'poly1');

        %
        % y = f.p1 * x + f.p2
        %             

        gamma(c) = log(f.p1) / log(k);
        alpha(c) = f.p2 / (1 - k^gamma(c));
    catch expr
        error(struct('message', expr.message, 'identifier', expr.identifier, 'stack', expr.stack));
    end
end

x = 0.0:(1.0 / 255.0):1.0;
lin_fun = zeros(256, col);

gamma_param = zeros(2, col);

for c=1:col
    gamma_param(1, c) = - alpha(c);
    gamma_param(2, c) = 1.0 / gamma(c);

    lin_fun(:, c) =  (x + gamma_param(1, c)).^gamma_param(2, c);    
end

end
