function imgOut = ConvertIPTtoICh(img, inverse)
%
%       imgOut = ConvertIPTtoICh(img, inverse)
%
%
%        Input:
%           -img: image to convert from IPT to ICh or from ICh to IPT.
%           -inverse: takes as values 0 or 1. If it is set to 1 the
%                     transformation from IPT to ICh is applied, otherwise
%                     the transformation from IChto IPT.
%
%        Output:
%           -imgOut: converted image in IPT or ICh (see inverse).
%
%     Copyright (C) 2016  Francesco Banterle
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

imgOut = img;

if(inverse == 0)%ICh color space
    imgOut(:,:,2) = sqrt(img(:,:,2).^2 + img(:,:,3).^2);
    imgOut(:,:,3) = atan2(img(:,:,2), img(:,:,3));
else
    imgOut(:,:,2) = sin(img(:,:,3)) .* img(:,:,2);
    imgOut(:,:,3) = cos(img(:,:,3)) .* img(:,:,2);
end
            
end
