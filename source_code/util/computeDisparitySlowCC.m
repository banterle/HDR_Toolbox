function [dm_LR, dm_RL, dm_mask_LR, dm_mask_RL] = computeDisparitySlowCC(imgL, imgR, dm_patchSize, dm_maxDisparity, dm_metric, dm_regularization, dm_alpha)
%
%       [dm_LR, dm_RL, dm_mask_LR, dm_mask_RL] = computeDisparitySlowCC(imgL, imgR, dm_patchSize, dm_maxDisparity, dm_metric, dm_regularization, dm_alpha)
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
%         - dm_LR: disparity from imgL to imgR
%         - dm_RL: disparity from imgR to imgL
%         - dm_mask_LR: mask of valid disparity values;
%         - dm_mask_RL: mask of valid disparity values;
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

[dm_LR, dm_maxDisparity] = computeDisparitySlow(imgL, imgR, dm_patchSize, dm_maxDisparity, dm_metric, dm_regularization, dm_alpha);
[dm_RL, ~] = computeDisparitySlow(imgR, imgL, dm_patchSize, dm_maxDisparity, dm_metric, dm_regularization, dm_alpha);

%consistency check
[r, c, ~] = size(imgL);

for i=(dm_patchSize + 1):(r - dm_patchSize - 1)
            
    for j=(dm_patchSize + 1):(c - dm_patchSize - 1)
        d = dm_LR(i, j, 1);
        x_d = j + d;
        j_rec = dm_RL(i, x_d, 1) + x_d;
           
        dm_LR(i, j, 3) = abs(j - j_rec);
        dm_RL(i, j, 3) = abs(j - j_rec);
    end    
end

dm_mask_LR = zeros(r, c);
dm_mask_RL = zeros(r, c);

threshold = 2;
tmp = dm_LR(:,: , 3);
dm_mask_LR(tmp < threshold) = 1;
dm_mask_RL(tmp < threshold) = 1;

end