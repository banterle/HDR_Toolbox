function imgOut = pyrGaussGenAux(img)
%
%
%        imgOut = pyrGaussGenAux(img)
%
%
%        Input:
%           -img: an image
%
%        Output:
%           -imgOut: filtered img using 5x5 Gaussian filter 
%           -imgB: downsampled img at half the size
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

%5x5 Gaussian Kernel
kernel = [1, 4, 6, 4, 1];
mtx = kernel' * kernel;
mtx = mtx / sum(mtx(:));

%Convolution
imgB = imfilter(img, mtx, 'replicate');

%Downsampling
[r, c] = size(img);
imgOut = imgB(1:2:r, 1:2:c); %imresize(imgB, 0.5, 'bilinear');

end