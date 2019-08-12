function [img1, img2, img3] = decomposeImage3(img)
%
%
%        [img1, img2, img3] = decomposeImage3(img)
%
%        This function visualizes colors of the image in its 3D color
%        space.
%
%        Input:
%           -img: an image
%
%        Output:
%           -img1: img first channel
%           -img2: img second channel
%           -img3: img third channel
%
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

img1 = zeros(size(img));
img1(:,:,1) = img(:,:,1);

img2 = zeros(size(img));
img2(:,:,2) = img(:,:,1);

img3 = zeros(size(img));
img3(:,:,3) = img(:,:,1);

end