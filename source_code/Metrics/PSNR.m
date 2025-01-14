function psnr = PSNR(img_ref, img_dist, comparison_domain, max_value, mask)
%
%
%      psnr = PSNR(img_ref, img_dist, comparison_domain, max_value, mask)
%
%
%       Input:
%           -img_ref: input reference image
%           -img_dist: input distorted image
%           -comparison_domain: the domain where to compare images
%                   'lin': linear
%                   'log2': log base 2
%                   'log': natural logarithm
%                   'log10': log base 10
%                   'pu08': perceptual uniform encoding
%                   'pu21': perceptual uniform encoding
%           -max_value: maximum value (in the linear domain) of the images domain
%           -mask: a binary image for masked computations.
%
%       Output:
%           -psnr: classic PSNR in dB; i.e., higher values means better quality.
% 
%     Copyright (C) 2016-18  Francesco Banterle
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
[img_ref, img_dist, domain, mxt] = checkDomains(img_ref, img_dist);
checkNegative(img_ref);
checkNegative(img_dist);

%determine the maximum value
if(~exist('max_value', 'var'))
    max_value = -1000;
end

if(~exist('comparison_domain', 'var'))
    comparison_domain = 'lin';
end

if(~exist('mask', 'var'))
    mask = [];
end

bFlag = strcmp(domain, 'uint8') | strcmp(domain, 'uint16');

if(bFlag && strcmp(comparison_domain, 'pu'))
    error('PU encoding does not make sense for uint8 or uint16 values. Physical values are required!');
end

if(bFlag && contains(comparison_domain, 'log'))
    error('logarithmic encoding does not make sense for uint8 or uint16 values. Please use linear domain!');
end

if(max_value < 0.0)
    max_value = mxt;
end

[img_ref, ~] = changeComparisonDomain(img_ref, comparison_domain);
[img_dist, ~] = changeComparisonDomain(img_dist, comparison_domain);
[max_value, bNeg] = changeComparisonDomain(max_value, comparison_domain);
comparison_domain = '';

if(max_value < 0.0)
    max_value = -max_value;
end

%compute MSE
mse = MSE(img_ref, img_dist, bNeg, comparison_domain, mask);

if(mse > 0.0)
    %compute PSNR
    psnr = 20 * log10(max_value / sqrt(mse));
else
    disp('PSNR: the images are the same!');
    psnr = 1000;
end

end