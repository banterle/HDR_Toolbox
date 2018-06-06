function psnr = logPSNR(img_ref, img_dist, max_value)
%
%
%      val = logPSNR(img_ref, img_dist, max_value, min_value)
%
%
%       Input:
%           -img_ref: input reference image
%           -img_dist: input distorted image
%           -max_value: maximum value of images domain
%
%       Output:
%           -psnr: classic PSNR for images in [0,1]. Higher values means
%           better quality.
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

%check if images have same size and type
[img_ref, img_dist, ~, mxt] = checkDomains(img_ref, img_dist);
checkNegative(img_ref);
checkNegative(img_dist);

%determine the maximum value
if(~exist('max_value', 'var'))
    max_value = -1000;
end

if(max_value < 0.0)
    max_value = mxt;
end

%compute MSE
img_ref(img_ref < 1e-5) = 1e-5;
img_dist(img_dist < 1e-5) = 1e-5;

log_img_ref  = log(img_ref);
log_img_dist = log(img_dist);

mse = MSE(log_img_ref, log_img_dist, 0);

if(mse > 0.0)
    %compute PSNR
    psnr = 20 * log10(max_value / sqrt(mse));
else
    disp('PSNR: the images are the same!');
    psnr = 1000;
end

end