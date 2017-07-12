function imgRGB = LogLuv2float(imgLogLuv)
%
%       imgRGB=LogLuv2float(imgLogLuv)
%
%
%        Input:
%           -imgLogLuv: a HDR image in the 32-bit LogLuv format
%
%        Output:
%           -imgRGB: the HDR image in the RGB floating format
%
%     Copyright (C) 2011  Francesco Banterle
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

%is it a three color channels image?
check3Color(imgLogLuv);

%Decoding luminance Y
imgXYZ = zeros(size(imgLogLuv));
imgXYZ(:,:,2) = 2.^((imgLogLuv(:,:,1) + 0.5)/256 - 64);

%Decoding chromaticity
u_prime = (imgLogLuv(:,:,2)+0.5)/410;
v_prime = (imgLogLuv(:,:,3)+0.5)/410;

norm = 6*u_prime -16*v_prime + 12;

x = 9*u_prime./norm;
y = 4*v_prime./norm;
z = 1 - x - y;

norm = RemoveSpecials(imgXYZ(:,:,2)./y);

imgXYZ(:,:,1) = x.*norm;
imgXYZ(:,:,3) = z.*norm;

%Conversion from XYZ to RGB
imgRGB = ConvertRGBtoXYZ(imgXYZ, 1);

end