function layer = GenerateMasks(imgBin, nLevels)
%
%
%       layer = GenerateMasks(imgBin, nLevels)
%
%
%       Input:
%           -imgBin:
%           -nLevels: 
%
%       Output:
%           -layer:
%
%       This function computes connected components for each dynamic range
%       zone.
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

[r, c] = size(imgBin);
layer = zeros(r, c, nLevels);

for i=1:nLevels    
    indx = find(imgBin == i);
    
    if(~isempty(indx))
        tmpBin = zeros(r, c);
        tmpBin(indx) = 1;
        layer(:,:,i) = bwlabel(tmpBin, 8); 
    else
        layer(:,:,i) = 0;
    end
end

clear('lab');
clear('tmpBin');

end
