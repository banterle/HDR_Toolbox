function imgOut = LischinskiTMO(img, pAlpha, pWhite)
%
%
%      imgOut = LischinskiTMO(img, pAlpha, pWhite)
%
%
%       Input:
%           -img: input HDR image
%           -pAlpha: value of exposure of the image
%           -pWhite: the white point 
%
%       Output:
%           -imgOut: output tone mapped image in linear domain
% 
%     Copyright (C) 2010-2016 Francesco Banterle
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
%     "Interactive Local Adjustment of Tonal Values"
% 	  by Dani Lischinski, Zeev Farbman, Matt Uyttendaele, Richard Szeliski
%     in Proceedings of SIGGRAPH 2006
%

%is it a three color channels image?
check13Color(img);

checkNegative(img);

if(~exist('pAlpha', 'var'))
    pAlpha = ReinhardAlpha(lum(img));
end

if(~exist('pWhite', 'var'))
    pWhite = ReinhardWhitePoint(lum(img));
end

%luminance channel
L = lum(img);

%number of zones in img
epsilon = 1e-6;
minLLog = log2(min(L(:)) + epsilon);
maxLLog = log2(max(L(:)));
Z = ceil(maxLLog - minLLog);

%choose the representative Rz for each zone
fstopMap = zeros(size(L));
Lav = logMean(L);
for i=1:Z
    lower_i = 2^(i - 1 + minLLog);
    upper_i = 2^(i + minLLog);
    indx = find(L >= lower_i & L < upper_i);
    if(~isempty(indx)) %apply global ReinhardTMO
        Rz = MaxQuart(L(indx), 0.5);
        Rz_s = (pAlpha * Rz) / Lav; %scale Rz        
        f = (Rz_s * (1 + Rz_s / (pWhite^2))) / (Rz_s + 1);           
        fstopMap(indx) = log2(f / Rz);
    end
end

%edge-aware filtering
fstopMap = 2.^LischinskiMinimization(log2(L + epsilon), fstopMap, 0.07 * ones(size(L)));

imgOut = zeros(size(img));
for i=1:size(img,3)
    imgOut(:,:,i) = img(:,:,i) .* fstopMap;
end

end
