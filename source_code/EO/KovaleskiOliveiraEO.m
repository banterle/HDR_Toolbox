function [imgOut, e_map] = KovaleskiOliveiraEO(img, type_content, ko_sigma_s, ko_sigma_r, ko_display_min, ko_display_max, gammaRemoval)
%
%       [imgOut, e_map] = KovaleskiOliveiraEO(img, type_content, ko_sigma_s, ko_sigma_r, ko_display_min, ko_display_max, gammaRemoval)
%
%
%        Input:
%           -img: input LDR image with values in [0,1]
%           -type_content: -'image' if img is a still image
%                          -'video' if img is a frame of a video 
%           -ko_sigma_s: spatial sigma of the bilateral filter. Default for
%           HD content is 150.
%           -ko_sigma_r: range sigma of the bilateral filter. Default is
%           25/255.
%           -ko_display_min: black level of the display. Default is 0.3nit
%           -ko_display_max: white level of the display. Default is 1200nit
%           -gammaRemoval: the gamma value to be removed if known.
%
%        Output:
%           -imgOut: an expanded image.
%           -e_map: the brightness expansion function.
%
%     Copyright (C) 2015  Francesco Banterle
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
%     "High-Quality Reverse Tone Mapping for a Wide Range of Exposures"
%     by Rafael P. Kovaleski and Manuel M. Oliveira, 
%     in 2014 27th SIBGRAPI Conference on Graphics, Patterns and Images
%

check13Color(img);

checkIn01(img);

if(~exist('ko_sigma_s', 'var'))
    ko_sigma_s = 150; %as in the original paper
    warning('ko_sigma_s is set to 150');
end

if(~exist('ko_sigma_r', 'var'))
    ko_sigma_r = 25 / 255; %as in the original paper
    warning('ko_sigma_r is set to 25 / 255');
end

switch type_content
    case 'video'
        threshold = 230 / 255;
    case 'image'
        threshold = 254 / 255;
    otherwise
        threshold = 230 / 255;
end

if(gammaRemoval > 0.0)
    img = img.^gammaRemoval;
    threshold = threshold^gammaRemoval;
    ko_sigma_r = ko_sigma_r^gammaRemoval;
else
    warning(['gammaRemoval < 0.0; gamma removal has not been applied. '
    'img is assumed to be linear']);
end

if(ko_display_max < 0.0)
    error('ko_display_max needs to be a positive value');
end

if(ko_display_min < 0.0)
    error('ko_display_min needs to be a positive value');
end

L = lum(img);

imgC = zeros(size(img,1), size(img, 2));
imgC(max(img, [], size(img,3)) > threshold) = 1;

e_map = bilateralFilter(imgC, L, 0, 1, ko_sigma_s, ko_sigma_r);
e_map = e_map * 3.0 + 1;

%compute expanded luminance
Lexp = L * (ko_display_max - ko_display_min) + ko_display_min;
Lexp = Lexp .* e_map; %scale by e_map

%change luminance
imgOut = ChangeLuminance(img, L, Lexp);

end
