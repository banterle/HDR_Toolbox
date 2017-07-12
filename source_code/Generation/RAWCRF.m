function [lin_fun, pp] = RAWCRF(image_raw, image_jpg, N, threshold_outliers)
%
%       [lin_fun, pp] = RAWCRF(image_raw, image_jpg, N, threshold_outliers)
%
%      
%
%        Input:
%           -image_raw:
%           -image_raw: 
%           -N:
%           -threshold_outliers:
%
%        Output:
%           -lin_fun:
%           -pp: 
%

if(isempty(image_raw))
    error('RAWCRF: a stack cannot be empty!');
end

if(isempty(image_jpg))
    error('RAWCRF: a stack_exposure cannot be empty!');
end

if(~exist('threshold', 'var'))
    threshold_outliers = 0.05;
end

if(~exist('N', 'var'))
    N = -1;
end

threshold_outliers_inv = 1.0 - threshold_outliers;

col = size(image_raw, 3);

lin_fun = zeros(256, col);

err = -1;
N_max = 6;
thr = [threshold_outliers, threshold_outliers_inv];

if(N < 0)
    for N_tmp=1:N_max
        pp = RAWCRFn(image_raw, image_jpg, N_tmp, thr);

        imgOut = RemoveCRF(image_jpg, 'poly', pp);

        tmp_err = abs(imgOut - image_raw).^2;
        tmp_err = mean(tmp_err(:));

        if(err < 0)
            err = tmp_err;
            N = N_tmp;
        else
            if(tmp_err < err)
                err = tmp_err;
                N = N_tmp;
            end
        end

    end
else
    pp = RAWCRFn(image_raw, image_jpg, N, thr);
end

x_val = (0:255) / 255;

for i=1:col
    lin_fun(:, i) = polyval(pp(:, i), x_val);
end

end

function pp = RAWCRFn(image_raw, image_jpg, N, thr)
    col = size(image_raw, 3);
    
    pp = zeros(N + 1, col);
    
    bFlag = 0;

    %bDebug = 1;
    
    for i=1:col
        slice_raw = image_raw(:,:,i);
        slice_jpg = image_jpg(:,:,i);

        indx = find(slice_jpg > thr(1) & slice_jpg < thr(2));

        if(~isempty(indx))    
            x = slice_jpg(indx);
            y = slice_raw(indx);
            
%             
%             if(bDebug)
%                 figure(i);
%                 c = zeros(256,256);
%                 for k =1:length(x)
%                     tx = ClampImg(round(x(k) * 255) + 1, 1, 256);
%                     ty = ClampImg(round(y(k) * 255) + 1, 1, 256);
%                     c(256 - ty + 1, tx) = c(256 - ty + 1, tx) + 1;
%                 end
%                 imshow(c);
%             end
            
            pp(:, i) = polyfit(x, y, N);
        else
            bFlag = 1;
            disp('RAWCRF: no enough data for estimating the CRF');
        end
    end
    
    if(bFlag)
        pp = zeros(N + 1, col);
    end
end
