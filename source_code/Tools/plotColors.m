function plotColors(img)
%
%
%        plotColors(img)
%
%        This function visualizes colors of the image in its 3D color
%        space.
%
%        Input:
%           -img: an image
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

[r, c, col] = size(img);

x = img(:,:,1);
y = img(:,:,2);
z = img(:,:,3);

c = reshape(img, r * c, col);

scatter3(x(:), y(:), z(:), [], c, 'filled');

end