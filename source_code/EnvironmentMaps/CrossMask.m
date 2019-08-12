function mask = CrossMask(r, c)
%
%        mask = CrossMask(r, c)
%
%       This function creates a mask for a cube map
%
%        Input:
%           -r: rows of the image in the CubeMap format
%           -c: columns of the image in the CubeMap format
%        Output:
%           -mask: a mask where the CubeMap is defined
%
%     Copyright (C) 2011-12  Francesco Banterle
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

mask = zeros(r, c, 3);

tileSize = round(max([r / 4, c / 3]));

mask(tileSize:(2*tileSize-1),1:tileSize,:) = 1;
mask(tileSize:(2*tileSize-1),tileSize:(2*tileSize-1),:) = 1;
mask(tileSize:(2*tileSize-1),(2*tileSize):(3*tileSize-1),:) = 1;

mask(1:tileSize,tileSize:(2*tileSize-1),:) = 1;
mask((2*tileSize-1):(3*tileSize-1),tileSize:(2*tileSize-1),:) = 1;
mask((3*tileSize-1):(4*tileSize-1),tileSize:(2*tileSize-1),:) = 1;

end