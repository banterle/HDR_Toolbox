function pyr = dwt2Decomposition(img, filterType, maxBand)
%
%
%      pyr = dwt2Decomposition(img, mode)
%
%
%       Input:
%           -img: an image
%           -filterType: the type of filter to use in the DWT:
%            'db1' or 'haar', 'db2', ... ,'db10', ... , 'db45'
%            Please have a look to the MATLAB reference for dwt2.
%           -maxBand: how many bands to have
%
%
%       Output:
%           -pyr: the DWT decomposition 
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

if(~exist('maxBand', 'var'))
    maxBand = -1;
end

if(maxBand == -1)
    maxBand = floor(log2(min([size(img,1),size(img,2)])));
end

pyr = [];

for i=1:maxBand
    S = size(img);
    
    [img, cH, cV, cD] = dwt2(img, filterType);       
    
    cur = struct('cA', [], 'cH', cH, 'cV', cV, 'cD', cD, 'S', S);
    pyr = [pyr, cur];
end

n = length(pyr);

if(n>0)
    pyr(n).cA = img;
end

end