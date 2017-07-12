function D = LL2Direction(r, c)
%
%        D = LL2Direction(r, c)
%
%
%        Input:
%           -r: rows of the image in the LongitudeLatitude format
%           -c: columns of the image in the LongitudeLatitude format
%        Output:
%           -D: 3D directions of the mapping
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

[X0, Y0] = meshgrid(0:(c - 1),0:(r - 1));
phi   =  pi * ((X0 / c) * 2 - 1) - pi * 0.5;
theta =  pi * (Y0 / r);

sinTheta = sin(theta);
D = zeros(r, c, 3);
D(:,:,1) =  cos(phi) .* sinTheta;
D(:,:,2) =  cos(theta);
D(:,:,3) =  sin(phi) .* sinTheta;

end