function imgOut = ConvertRGBtoYUV(img, inverse)
%
%       imgOut = ConvertRGBtoYUV(img, inverse)
%
%
%        Input:
%           -img: image to convert from RGB to YUV or from YUV to RGB.
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from linear RGB to YUV is applied,
%                     otherwise the transformation from linear RGB to YUV
%                     is applied.
%
%        Output:
%           -imgOut: converted image in YUV or RGB.
%
%     Copyright (C) 2011-16  Francesco Banterle
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

mtxRGBtoYUV = [  0.299,    0.587,    0.114;...
                -0.14713, -0.28886,  0.436;...
                 0.616,   -0.51499, -0.10001];

if(inverse==0)
    imgOut = ConvertLinearSpace(img, mtxRGBtoYUV);
end

if(inverse==1)
    imgOut = ConvertLinearSpace(img, inv(mtxRGBtoYUV));
end
            
end
