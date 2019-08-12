function l = lumHK(img)
%
%       l = lum(img)
%
%       This function calculates the Helmholtz-Kohlrausch luminance
%
%
%       input:
%           img: an RGB image
%
%       output:
%           l: normalized Helmholtz-Kohlrausch luminance
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

check3Color(img);

imgXYZ = ConvertRGBtoXYZ(img, 0);
imgLCh = ConvertXYZtoCIELCh(imgXYZ, 0);

L = imgLCh(:,:,1);
C = imgLCh(:,:,2);
h = imgLCh(:,:,3);

h2 = ((h - 90) / 2) * pi / 360;

l = L + (2.5 - 0.025 * L) .* (0.116 * abs(sin(h2)) + 0.085) .* C;
l = l / max(l(:));

end