function deltaE = distCIELAB(img_dst, img_dst)
%
%       deltaE = distCIELAB(img_dst, img_ref)
%
%       This function assumes REC.709 primaries for the RGB color space
%
%        Input:
%           -img_dst: linear RGB image with sRGB color space. 
%           -img_dst: linear RGB image with sRGB color space.
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

img_dst = ConvertRGBtoXYZ(img_dst, 0);
img_ref = ConvertRGBtoXYZ(img_ref, 0);

img_dst = ConvertXYZtoCIELab(img_dst, 0);
img_ref = ConvertXYZtoCIELab(img_ref, 0);

deltaE = (img_dst - img_ref).^2;
deltaE = sqrt(mean(deltaE(:)));

end