function imgOut = ConvertRGBtosRGB(img, inverse)
%
%       imgOut = ConvertRGBtosRGB(img, inverse)
%
%       This function assumes REC.709 primaries for the RGB color space
%
%        Input:
%           -img: image to convert from linear RGB to sRGB or from sRGB to
%                 linear RGB.
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from linear RGB to sRGB is applied,
%                     otherwise the transformation from sRGB linear RGB.
%
%        Output:
%           -imgOut: converted image in sRGB or linear RGB.
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

a = 0.055;
imgOut = zeros(size(img));

if(inverse == 0) %from linear RGB to sRGB
    gamma_inv = 1.0 / 2.4;
    imgOut(img <= 0.0031308) = 12.92 * img(img <= 0.0031308);
    imgOut(img >  0.0031308) = (1 + a) * (img(img > 0.0031308).^gamma_inv) - a;
end

if(inverse == 1) %from sRGB to linear RGB
    gamma = 2.4;
    imgOut(img <= 0.04045) = img(img <= 0.04045) / 12.92;
    imgOut(img >  0.04045) = ((img(img > 0.04045) + a) / (1 + a)).^gamma;
end
            
end
