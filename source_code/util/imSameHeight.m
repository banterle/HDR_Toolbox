function img2new = imSameHeight(img1, img2)
%
%
%        img2new = imSameHeight(img1, img2)
%
%
%        Input:
%           -img1: target size image 
%           -img2: source image to adjust with the same height of image 1
%
%        Output:
%           -img2new: source image with the same height of img1
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

[r1,c1,col1] = size(img1);
[r2,c2,col2] = size(img2);


c2new = round((c2*r1)/r2);
img2new = imresize(img2, [r1,c2new] , 'bilinear');

end