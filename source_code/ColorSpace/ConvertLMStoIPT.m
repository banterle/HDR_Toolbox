function imgOut = ConvertLMStoIPT(img, inverse)
%
%       imgOut = ConvertLMStoIPT(img, inverse)
%
%
%        Input:
%           -img: image to convert from LMS to IPT or from IPT to LMS.
%           -inverse: takes as values 0 or 1. If it is set to 1 the
%                     transformation from LMS to IPT is applied, otherwise
%                     the transformation from IPT to LMS.
%
%        Output:
%           -imgOut: converted image in LMS or IPT.
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

%matrix conversion from LMS to IPT
mtxLMStoIPT = [0.4000 0.4000 0.2000; 4.4550 -4.8510 0.3960; 0.8056 0.3572 -1.1628];

if(inverse == 0)
    gamma = 0.43;
    
    ind0 = find(img >= 0.0);    
    ind1 = find(img < 0.0);
    img(ind0) = img(ind0).^gamma;
    img(ind1) = -(-img(ind1)).^gamma;
    
    imgOut = ConvertLinearSpace(img, mtxLMStoIPT);
else
    invGamma = 1.0/0.43;
    
    imgOut = ConvertLinearSpace(img, inv(mtxLMStoIPT));

    ind0 = find(imgOut >= 0.0);    
    ind1 = find(imgOut < 0.0);
    imgOut(ind0) = imgOut(ind0).^invGamma;
    imgOut(ind1) = -(-imgOut(ind1)).^invGamma;
end
            
end
