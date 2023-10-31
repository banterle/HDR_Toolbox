function [L0, B0] = pyrLapGenAux(img)
%
%
%        [L0, B0] = pyrLapGenAux(img)
%
%
%        Input:
%           -img: an image
%
%        Output:
%           -L0: downsampled img at half the size
%           -B0: difference between a downsampled and upsampled level
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

%5x5 Gaussian kernel
kernel = [1, 4, 6, 4, 1];
mtx = kernel' * kernel;
mtx = mtx / sum(mtx(:));

%Convolution
imgB = imfilter(img, mtx, 'replicate');

%downsample
[r, c] = size(img);
L0 =  imgB(1:2:r, 1:2:c); %imresize(imgB, 0.5, 'bilinear');

%upsample
imgE = imresize(L0, [r, c], 'bilinear');

%Difference between the two levels
B0 = img - imgE;

end