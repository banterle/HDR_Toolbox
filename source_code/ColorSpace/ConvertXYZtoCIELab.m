function imgOut = ConvertXYZtoCIELab(img, inverse, conv_whitePoint)
%
%       imgOut = ConvertXYZtoCIELab(img, inverse, conv_whitePoint)
%
%
%        Input:
%           -img: image to convert from XYZ to CIE Lab or from Lab to XYZ
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from XYZ to CIE Lab is applied, otherwise
%                     the transformation from CIE Lab to XYZ
%           -conv_whitePoint: the white point in XYZ coordiantes
%
%        Output:
%           -imgOut: converted image in CIE Lab if inverse = 0, otherwise XYZ
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

imgOut = zeros(size(img));

if(~exist('conv_whitePoint', 'var'))
    conv_whitePoint = [1, 1, 1];
end

if(inverse == 0)%forward transform
    for i=1:3
        img(:,:,i) = img(:,:,i) / conv_whitePoint(i);
    end

    %L
    fY = CIELabFunction(img(:,:,2), 0);
    imgOut(:,:,1) = 116 * fY - 16;
    %a
    imgOut(:,:,2) = 500 * (CIELabFunction(img(:,:,1), 0) - fY);
    %b
    imgOut(:,:,3) = 200 * (fY - CIELabFunction(img(:,:,3), 0));   
end

if(inverse == 1)%inverse transform
    tmp = (img(:,:,1) + 16) / 116;
    %Y
    imgOut(:,:,2) = conv_whitePoint(2) * CIELabFunction(tmp, 1);
    %X
    imgOut(:,:,1) = conv_whitePoint(1) * CIELabFunction( tmp + img(:,:,2) / 500, 1);
    %Z
    imgOut(:,:,3) = conv_whitePoint(3) * CIELabFunction( tmp - img(:,:,3) / 200, 1);   
end

imgOut = RemoveSpecials(imgOut);

end
