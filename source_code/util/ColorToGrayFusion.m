function imgOut = ColorToGrayFusion(img)
%
%
%       imgOut = ColorToGrayFusion(img)
%
%       This function converts an image into a grey-scale using Exposure
%       Fusion
%
%       Input:
%           -img: a color image
%
%       Output:
%           -imgOut: a grey-scale image
%
%     Copyright (C) 2013  Francesco Banterle
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

[r, c, col] = size(img);

stack = zeros(r, c, 1, col + 1);

for i=1:col
    stack(:,:,:,i) = img(:,:,i);
end
 
stack(:,:,:,4) = lumHK(img);

weights = [1.0 0.0 1.0];
imgOut = MertensTMO([], stack, weights, 0);

end