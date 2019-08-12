function imgOut = dwt2Reconstruction(pyr, filterType)
%
%
%      img = dwt2Decomposition(pyr, mode)
%
%
%       Input:
%           -pyr: the DWT decomposition 
%           -filterType: the type of filter to use in the DWT:
%            'db1' or 'haar', 'db2', ... ,'db10', ... , 'db45'
%            Please have a look to the MATLAB reference for dwt2.
%
%       Output:
%           -imgOut: the reconstructed image from pyr
% 
%       This function decomposes an image using the DWT. Please have a look
%       to the reference of dwt2.
%
%     Copyright (C) 2013-14  Francesco Banterle
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

imgOut = pyr(length(pyr)).cA;

for i=length(pyr):-1:1
    imgOut = idwt2(imgOut, pyr(i).cH, pyr(i).cV, pyr(i).cD, filterType, pyr(i).S);       
end

end