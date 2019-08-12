function expand_map = KuoExpandMap(L, gammaRemoval)
%
%		 expand_map = KuoExpandMap(L, gammaRemoval)
%
%		 Input:
%			-L: a luminance channel
%           -gammaRemoval: the gamma value to be removed if known
%
%		 Output:
%			-expand_map: the final expand map
%
%     Copyright (C) 2013-15 Francesco Banterle
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
%     The paper describing this technique is:
%     "CONTENT-ADAPTIVE INVERSE TONE MAPPING"
%     by Pin-Hung Kuo, Chi-Sun Tang, and Shao-Yi Chien
%     in VCIP 2012, San Diego, CA, USA
%

if(~exist('gammaRemoval','var'))
    gammaRemoval = -1.0;
end

kernelSize = ceil(0.1 * max(size(L)));
kernel = ones(kernelSize) / (kernelSize^2);

Lflt = imfilter(L, kernel);
epsilon = max(Lflt(:));

mask = ones(size(L));
mask(L < epsilon) = 0;
mask = double(bwmorph(mask,'erode'));

tmp_expand_map = L .* mask;

sigma_s = kernelSize / 5.0; %as in the original paper
sigma_r = 100.0 / 255.0; %as in the original paper
if(gammaRemoval > 0.0)
    sigma_r = sigma_r^gammaRemoval;
end

expand_map = bilateralFilter(tmp_expand_map, L, 0, 1.0, sigma_s, sigma_r );

end