function D = CubeMap2Direction(r, c)
%
%        D = CubeMap2Direction(r, c)
%
%
%        Input:
%           -r: rows of the image in the CubeMap format
%           -c: columns of the image in the CubeMap format
%        Output:
%           -D: 3D directions of the mapping
%
%     Copyright (C) 2011-15  Francesco Banterle
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

D = zeros(r, c, 3);

%Generation of the tile of directions
tile = round(max([r / 4, c / 3]));
[X, Z] = meshgrid(1:tile,1:tile);

tmpDir = zeros(tile, tile, 3);
tmpDir(:,:,1) = X / tile * 2 - 1;
tmpDir(:,:,3) = Z / tile * 2 - 1;
tmpDir(:,:,2) = ones(tile);
N = sqrt(tmpDir(:,:,1).^2 + tmpDir(:,:,2).^2 + tmpDir(:,:,3).^2);

for i=1:3
    tmpDir(:,:,i) = tmpDir(:,:,i) ./ N;
end

%Repeating the tile of directions
C1 = [1,(2*tile+1),(tile+1),(3*tile+1),(tile+1),(tile+1)];
C2 = [tile,(3*tile),(2*tile),(4*tile),(2*tile),(2*tile)];
C3 = [(tile+1),(tile+1),(tile+1),(tile+1),1,(2*tile+1)];
C4 = [(2*tile),(2*tile),(2*tile),(2*tile),tile,(3*tile)];

X = [ 1, 1, 1,1,-2, 2];
Y = [ 2,-2,-3,3,-3,-3];
Z = [-3, 3,-2,2,-1, 1];

for i=1:6
    D(C1(i):C2(i),C3(i):C4(i),1) =  sign(X(i)) * tmpDir(:,:,abs(X(i)));
    D(C1(i):C2(i),C3(i):C4(i),2) =  sign(Y(i)) * tmpDir(:,:,abs(Y(i)));
    D(C1(i):C2(i),C3(i):C4(i),3) =  sign(Z(i)) * tmpDir(:,:,abs(Z(i)));    
end

end