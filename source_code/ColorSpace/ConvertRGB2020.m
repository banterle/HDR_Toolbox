function imgOut = ConvertRGB2020(img)
%
%       imgOut = ConvertRGBtoXYZ(img, inverse)
%
%       This function assumes REC.709 primaries for the RGB color space
%
%        Input:
%           -img: image to convert from RGB to XYZ or from XYZ to RGB.
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from linear RGB to XYZ is applied,
%                     otherwise the transformation from XYZ to linear RGB
%                     is applied.
%
%        Output:
%           -imgOut: converted image in XYZ or RGB.
%
%     Copyright (C) 2011-16  Francesco Banterle
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

%ITU-R BT.709 matrix conversion from RGB to XYZ
mtxRGB2020toRGB709 = [ 1.6605, -0.5876, -0.0728;...
                -0.2146, 1.1329, -0.0083;...
                -0.0182, -0.1006, 1.1187];

imgOut = ConvertLinearSpace(img, mtxRGB2020toRGB709);
imgOut = ClampImg(imgOut, 0.0, 1.0);

end
