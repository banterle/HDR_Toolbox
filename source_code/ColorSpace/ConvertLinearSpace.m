function imgOut = ConvertLinearSpace(img, mtx)
%
%       imgOut = ConvertLinearSpace(img, mtx)
%
%
%        Input:
%           -img: image to convert into a new color space
%           -mtx: a 3x3 matrix that defines a linear color transformation
%
%        Output:
%           -imgOut: converted image
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

%Is it a three color channels image?
check3Color(img);

%Is it a 3x3 matrix?
[r, c]=size(mtx);
if(r ~= 3 || c ~= 3)
    error('The matrix for color transformation is not 3x3.');
end

imgOut = zeros(size(img));
for i=1:3
    imgOut(:,:,i) = img(:,:,1) * mtx(i,1) + img(:,:,2) * mtx(i,2) + img(:,:,3) * mtx(i,3);
end

end