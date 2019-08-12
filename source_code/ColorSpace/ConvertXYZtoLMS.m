function imgOut = ConvertXYZtoLMS(img, inverse)
%
%       imgOut = ConvertXYZtoLMS(img, inverse)
%
%
%        Input:
%           -img: image to convert from XYZ to LMS or from LMS to XYZ.
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from XYZ to LMS is applied, otherwise
%                     the transformation from LMS to XYZ.
%
%        Output:
%           -imgOut: converted image in XYZ or LMS.
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

%XYZ to LMS matrix conversion: HPE transformation matrix
mtxXYZtoLMS = [0.4002 0.7075 -0.0807; -0.2280 1.1500 0.0612; 0 0 0.9184];

if(inverse == 0)
    imgOut = ConvertLinearSpace(img, mtxXYZtoLMS);
else

if(inverse == 1)
    imgOut = ConvertLinearSpace(img, inv(mtxXYZtoLMS));
end
            
end