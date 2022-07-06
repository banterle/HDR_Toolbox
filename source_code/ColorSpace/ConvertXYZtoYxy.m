function imgOut = ConvertXYZtoYxy(img, inverse)
%
%       imgOut = ConvertxXYZtoYxy(img, inverse)
%
%
%        Input:
%           -img: image to convert from XYZ to Yxy or from Yxy to XYZ.
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from XYZ to Yxy is applied, otherwise
%                     the transformation from Yxy to XYZ.
%
%        Output:
%           -imgOut: converted image in Yxy or XYZ.
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

check3Color(img);
[r, c, col] = size(img);
imgOut = zeros(r, c, col);

if(inverse == 0)%forward transform   
    norm = zeros(r, c);
    for i=1:3
        norm = norm + img(:,:,i);
    end
    
    imgOut(:,:,1) = img(:,:,2);
    
    imgOut(:,:,2) = img(:,:,1) ./ (norm);
    imgOut(:,:,3) = img(:,:,2) ./ (norm);
end

if(inverse == 1)%inverse transform
    Y_over_y = img(:,:,1) ./ img(:,:,3); 
    imgOut(:,:,1) = Y_over_y .* img(:,:,2);
    imgOut(:,:,2) = img(:,:,1);
    imgOut(:,:,3) = Y_over_y .* (1.0 - img(:,:,2) - img(:,:,3));
end

imgOut = RemoveSpecials(imgOut);

end
