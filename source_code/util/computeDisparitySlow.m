function disparityMap = computeDisparitySlow(imgL, imgR, dm_patchSize, dm_maxDisparity, dm_metric, dm_regularization, dm_alpha)
%
%       disparityMap = computeDisparitySlow(imgL, imgR, dm_patchSize, dm_maxDisparity, dm_metric, dm_regularization, dm_alpha)
%
%       This function computes the disparity between two images.
%
%       input:
%         - imgL: left image
%         - imgR: right image
%         - dm_patchSize: size of the patch for comparisons
%         - dm_maxDisparity: maximum disparity
%         - dm_metric: the type of metric for computing disparity: 'SSD' (sum of
%           squared differences), 'SAD' (sum of absolute differences), 'NCC'
%           (normalized cross-correlation)
%         -dm_regularization: regularization value 
%         -dm_alpha: color vs gradient
%
%       output:
%         - disparityMap: disparity from imgL to imgR
%
%     Copyright (C) 2013-16  Francesco Banterle
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

if(~exist('dm_patchSize', 'var'))
    dm_patchSize = 7;
end

if(~exist('dm_maxDisparity', 'var'))
    dm_maxDisparity = dm_patchSize * 4;
end

if(~exist('dm_metric', 'var'))
    dm_metric = 'SSD';    
end

if(~exist('dm_alpha', 'var'))
    dm_alpha = 0.9;
end

if(~exist('dm_regularization', 'var'))
    dm_regularization = 0.0;
end

[r, c, ~] = size(imgL);

halfPatchSize = ceil(dm_patchSize / 2);

disparityMap = zeros(r, c, 2);

kernelX = [0, 0, 0; -0.5, 0, 0.5; 0,  0, 0];
imgL_dx = imfilter(imgL, kernelX, 'same');
imgR_dx = imfilter(imgR, kernelX, 'same');

dm_alpha_inv = (1.0 - dm_alpha);

for i=(dm_patchSize + 1):(r - dm_patchSize - 1)
            
    for j=(dm_patchSize + 1):(c - dm_patchSize - 1)
        
        err = 1e30;
        disp = 0;
        patchL    = imgL((i - halfPatchSize):(i + halfPatchSize), (j - halfPatchSize):(j + halfPatchSize), :);
        patchL_dx = imgL_dx((i - halfPatchSize):(i + halfPatchSize), (j - halfPatchSize):(j + halfPatchSize), :);
        patchL_sq = patchL.^2;        
               
        min_j = max([j - dm_maxDisparity, dm_patchSize + 1]);
        max_j = min([j + dm_maxDisparity, c - dm_patchSize - 1]);
        
        lambda = dm_regularization / (max_j - min_j + 1);
                
        for k=min_j:max_j
            patchR    = imgR((i - halfPatchSize):(i + halfPatchSize), (k - halfPatchSize):(k + halfPatchSize), :);
            patchR_dx = imgR_dx((i - halfPatchSize):(i + halfPatchSize), (k - halfPatchSize):(k + halfPatchSize), :);
                
            tmp_err = 1e30;
            
            switch dm_metric
                case 'SSD'
                    tmp_err = (patchL - patchR).^2;
                case 'SAD'
                    tmp_err = abs(patchL - patchR);
                case 'NCC'
                    patchR_sq = patchR.^2;
                    tmp_err = (patchL .* patchR) / sqrt(sum(patchL_sq(:)) * sum(patchR_sq(:)));
                otherwise
                    tmp_err = (patchL - patchR).^2;
            end
            
            tmp_err_dx = (patchL_dx - patchR_dx).^2;
                        
            if(dm_regularization > 0.0)
                tmp_err = dm_alpha_inv * mean(tmp_err(:)) + dm_alpha * mean(tmp_err_dx(:)); + lambda * abs(k - j);
            else
                tmp_err = dm_alpha_inv * sum(tmp_err(:)) + dm_alpha * sum(tmp_err_dx(:));
            end
                
            if(tmp_err < err)
                err  = tmp_err;
                disp = k - j;
            end            
        end
        
        disparityMap(i, j, 1) = disp;
        disparityMap(i, j, 2) = err;
    end
    
end

end