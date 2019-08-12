function imgOut = RotateYLL(img, angle)
%
%        imgOut = RotateYLL(img, angle)
%
%        This function rotates an environment map encoded with LL encoding
%        by an angle (degrees) around the Y-axis.
%
%        Input:
%           -img: an environment map encoded with LL encoding
%           -angle: rotation angle (degrees) around the Y-axis
%        Output:
%           -imgOut: img rotated by angle around the Y-axis
%
%     Copyright (C) 2016 Francesco Banterle
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

cols = size(img, 2);

imgOut = imShiftWrap(img, (angle * cols) / 360);

end