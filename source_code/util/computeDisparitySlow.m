function [disparityMap, dm_maxDisparity] = computeDisparitySlow(imgL, imgR, dm_patchSize, dm_maxDisparity, dm_metric, dm_regularization, dm_alpha)
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
%           squared differences), 'SAD' (sum of absolute differences), and CT
%           (census transform).
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
    dm_maxDisparity = -1;
end

if(~exist('dm_metric', 'var'))
    dm_metric = 'SAD';    
end

if(~exist('dm_alpha', 'var'))
    dm_alpha = 0.05;
end

if(~exist('dm_regularization', 'var'))
    dm_regularization = 0.2;
end

if(dm_maxDisparity < 0.0)
    
    hf = figure(1);
    imshow((imgL + imgR) / 2.0);
    hold on;
    [x0, y0] = ginput(1);
    plot(x0, y0, 'r+');
    [x1, y1] = ginput(1);
    plot(x1, y1, 'r+');
    
    dm_maxDisparity = round(abs(x1 - x0));
    hold off;
    
    disp(dm_maxDisparity);
    close(hf);
%    dm_maxDisparity = dm_patchSize * 4;    
end

[r, c, col] = size(imgL);

lumL = lum(imgL);
lumR = lum(imgR);

if(col == 3) %assuming RGB with gamma
    imgL = ConvertRGBtosRGB(imgL, 1);
    imgL = ConvertRGBtoXYZ(imgL, 0);
    imgL = ConvertXYZtoCIELab(imgL, 0);
    
    imgR = ConvertRGBtosRGB(imgR, 1);
    imgR = ConvertRGBtoXYZ(imgR, 0);
    imgR = ConvertXYZtoCIELab(imgR, 0);    
end

halfPatchSize = ceil(dm_patchSize / 2);

disparityMap = zeros(r, c, 2);

kernelX = [-1, 0, 1; -2, 0, 2; -1,  0, 1];
imgL_dx(:,:,1) = imfilter(lumL, kernelX,  'same');
imgL_dx(:,:,2) = imfilter(lumL, kernelX', 'same');

imgR_dx(:,:,1) = imfilter(lumR, kernelX,  'same');
imgR_dx(:,:,2) = imfilter(lumR, kernelX', 'same');

dm_alpha_inv = (1.0 - dm_alpha);

for i=(dm_patchSize + 1):(r - dm_patchSize - 1)
            
    for j=(dm_patchSize + 1):(c - dm_patchSize - 1)
               
        d1 = disparityMap(i - 1, j, 1);        
        d2 = disparityMap(i, j - 1, 1);
        
        err = 1e30;
        depth = 0;
        patchL    = imgL   ((i - halfPatchSize):(i + halfPatchSize), (j - halfPatchSize):(j + halfPatchSize), :);
        patchL_dx = imgL_dx((i - halfPatchSize):(i + halfPatchSize), (j - halfPatchSize):(j + halfPatchSize), :);
                       
        min_j = max([j - dm_maxDisparity, dm_patchSize + 1]);
        max_j = min([j + dm_maxDisparity, c - dm_patchSize - 1]);
        
        lambda = dm_regularization / (max_j - min_j + 1);
                
        for k=min_j:max_j
            patchR    = imgR   ((i - halfPatchSize):(i + halfPatchSize), (k - halfPatchSize):(k + halfPatchSize), :);
            patchR_dx = imgR_dx((i - halfPatchSize):(i + halfPatchSize), (k - halfPatchSize):(k + halfPatchSize), :);

            switch dm_metric                    
                case 'SAD'
                    delta = abs(patchL - patchR);
                                        
                otherwise
                    delta = (patchL - patchR).^2;
            end
            
            delta_dx_sq = (patchL_dx - patchR_dx).^2;
                   
            tmp_err = dm_alpha_inv * mean(delta(:)) + dm_alpha * mean(delta_dx_sq(:));            
            
            d3 = k - j;
            if(dm_regularization > 0.0)                
                 tmp_err = tmp_err + lambda * (abs(d3) + abs(d3 - d1) + abs(d3 - d2) );
            end
                
            if(tmp_err < err)
                err  = tmp_err;
                depth = d3;
            end            
        end
        
        disparityMap(i, j, 1) = depth;
        disparityMap(i, j, 2) = err;
    end
    
end

end