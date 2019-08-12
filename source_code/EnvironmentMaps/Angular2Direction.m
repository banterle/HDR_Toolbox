function D = Angular2Direction(r, c)
%
%        D = LL2Direction(r, c)
%
%
%        Input:
%           -r: rows of the image in the Angular format
%           -c: columns of the image in the Angular format
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

[X, Y] = meshgrid(0:(c-1), 0:(r-1));
X = X / c;
Y = Y / r;

theta =   atan2((-2 * Y + 1),(2 * X - 1));
phi = pi * sqrt(( 2 * X - 1).^2+(2 * Y - 1).^2);

D = zeros(r, c, 3);

sinPhi = sin(phi);
D(:,:,1) = cos(theta) .* sinPhi;
D(:,:,2) = sin(theta) .* sinPhi;
D(:,:,3) = -cos(phi);

end