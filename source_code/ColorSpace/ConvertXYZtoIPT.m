function imgOut = ConvertXYZtoIPT(img, inverse)
%
%       imgOut = ConvertXYZtoIPT(img, inverse)
%
%
%        Input:
%           -img: image to convert from XYZ to IPT or from IPT to XYZ.
%           -inverse: takes as values 0 or 1. If it is set to 1 the
%                     transformation from XYZ to IPT is applied, otherwise
%                     the transformation from IPT to XYZ.
%
%        Output:
%           -imgOut: converted image in XYZ or IPT.
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

if(inverse == 0)   
    imgLMS = ConvertXYZtoLMS(img, 0);
    
    imgOut = ConvertLMStoIPT(imgLMS, 0);
    
else
    imgLMS = ConvertLMStoIPT(img, 1);
    
    imgOut = ConvertXYZtoLMS(imgLMS, 1);
end
            
end
