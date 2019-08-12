function imgOut = imOneToMany(img, col)
%
%		 imgOut = imOneToMany(img, col)
%
%
%		 Input:
%           -img: a single channel image
%           -col: the number of the output channels
%
%		 Output:
%			-img: an image with col ouput channels
%
%     Copyright (C) 2012-15  Francesco Banterle
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

[r,c] = size(img);

imgOut = zeros(r, c, col);

for i=1:col
    imgOut(:,:,i) = img;
end

end