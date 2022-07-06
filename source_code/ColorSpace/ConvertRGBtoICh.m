function imgOut = ConvertRGBtoICh(img, inverse)
%
%       imgOut = ConvertRGBtoICh(img, inverse)
%
%
%        Input:
%           -img: image to convert from RGB to ICh or from ICh to RGB.
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from linear RGB to ICh is applied,
%                     otherwise the transformation from linear RGB to ICh
%                     is applied.
%
%        Output:
%           -imgOut: converted image in ICh or RGB.
%
%     Copyright (C) 2021  Francesco Banterle
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

if inverse == 0
    img_xyz = ConvertRGBtoXYZ(img, 0);
    img_ipt = ConvertXYZtoIPT(img_xyz, 0);
    imgOut = ConvertIPTtoICh(img_ipt, 0);    
else
    img_ipt = ConvertIPTtoICh(img, 1);    
    img_xyz = ConvertXYZtoIPT(img_ipt, 1);    
    imgOut = ConvertRGBtoXYZ(img_xyz, 1);
    
end
