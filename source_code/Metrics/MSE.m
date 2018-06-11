function mse = MSE(img_ref, img_dist, bNegativeCheck, comparison_domain)
%
%
%      mse = MSE(img_ref, img_dist)
%
%
%       Input:
%           -img_ref: input reference image
%           -img_dist: input distorted image
%           -bNegativeCheck: disable the negativity check
%           -comparison_domain: the domain where to compare images
%                   'lin': linear
%                   'log2': logarithm in base 2
%                   'log': logarithm in base e (natural)
%                   'log10': logarithm in base 10
%                   'pu': perceptual uniform encoding
%
%       Output:
%           -mse: the Mean Squared Error assuming values in [0,1]. Lower
%           values means better quality.
% 
%     Copyright (C) 2006-18  Francesco Banterle
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
[img_ref, img_dist] = checkDomains(img_ref, img_dist);

if(~exist('bNegativeCheck', 'var'))
    bNegativeCheck = 1;
end

if(bNegativeCheck)
    checkNegative(img_ref);
    checkNegative(img_dist);
end

if(exist('comparison_domain', 'var'))
    [img_ref,  ~] = changeComparisonDomain(img_ref,  comparison_domain);
    [img_dist, ~] = changeComparisonDomain(img_dist, comparison_domain);
end

%compute squared differences
delta_sq = (img_ref - img_dist).^2;

%compute MSE
mse = mean(delta_sq(:));
end
