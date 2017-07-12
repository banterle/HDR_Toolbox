function imgOut = ConvertXYZtoCIELCh(img, inverse, conv_whitePoint)
%
%       imgOut = ConvertXYZtoCIELCh(img, inverse, conv_whitePoint)
%
%
%        Input:
%           -img: image to convert from XYZ to CIE LCh or from LCh to XYZ
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from XYZ to CIE LCh is applied, otherwise
%                     the transformation from CIE LCh to XYZ
%           -conv_whitePoint: the white point in XYZ coordiantes
%
%        Output:
%           -imgOut: converted image in CIE LCh if inverse = 0, otherwise XYZ
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

imgOut = zeros(size(img));

if(~exist('conv_whitePoint', 'var'))
    conv_whitePoint = [1, 1, 1];
end

if(inverse == 0)%forward transform
    imgLab = ConvertXYZtoCIELab(img, 0, conv_whitePoint);
    
    imgOut(:,:,1) = imgLab(:,:,1);
    imgOut(:,:,2) = sqrt(imgLab(:,:,2).^2 + imgLab(:,:,3).^2);

    rad_to_deg = 180 / pi;
    tmp = atan2(imgLab(:,:,3), imgLab(:,:,2)) * rad_to_deg;
    tmp(tmp < 0) = tmp(tmp < 0) + 360;
    imgOut(:,:,3) = tmp;
end

if(inverse == 1)%inverse transform    
    imgLab(:,:,1) = img(:,:,1);
    deg_to_rad = pi / 180;
    rad = img(:,:,3) * deg_to_rad;
    imgLab(:,:,2) = cos(rad) .* img(:,:,2);
    imgLab(:,:,3) = sin(rad) .* img(:,:,2);
    
    imgOut = ConvertXYZtoCIELab(imgLab, 1, conv_whitePoint);
end

imgOut = RemoveSpecials(imgOut);

end
