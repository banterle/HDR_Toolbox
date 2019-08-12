function imgLogLuv = float2LogLuv(img)
%
%       imgLogLuv=float2LogLuv(img)
%
%
%        Input:
%           -img: a HDR image in RGB
%
%        Output:
%           -imgLogLuv: the HDR image in the 32-bit LogLuv format
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
check3Color(img);

%Conversion from RGB to XYZ
imgXYZ = ConvertRGBtoXYZ(img, 0);

imgLogLuv = zeros(size(img));

%Encoding luminance Y
Le = floor(256*(log2(imgXYZ(:,:,2))+64));
imgLogLuv(:,:,1) = ClampImg(Le,0,65535);

%CIE (u,v) chromaticity values
norm = (imgXYZ(:,:,1)+imgXYZ(:,:,2)+imgXYZ(:,:,3));
x = imgXYZ(:,:,1)./ norm;
y = imgXYZ(:,:,2)./ norm;

%Encoding chromaticity
norm_uv = (-2*x+12*y+3);
u_prime = 4*x./norm_uv;
v_prime = 9*y./norm_uv;

Ue = floor(410*u_prime);
imgLogLuv(:,:,2) = ClampImg(Ue,0,255);

Ve = floor(410*v_prime);
imgLogLuv(:,:,3) = ClampImg(Ve,0,255);

end