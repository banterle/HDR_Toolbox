function [X1, Y1] = Direction2Spherical(D, r, c)
%
%        [X1, Y1] = Direction2Spherical(D, r, c)
%
%
%        Input:
%           -D: 3D directions of the img format
%        Output:
%           -X1: X coordinates in the LongitudeLatitude format
%           -Y1: Y coordinates in the LongitudeLatitude format
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

radius = sin(0.5 * acos(-D(:,:,3))) ./ (2 * sqrt(D(:,:,1).^2 + D(:,:,2).^2));
u = (0.5 + radius .* D(:,:,1));
v = (0.5 - radius .* D(:,:,2));

X1 = round(RemoveSpecials(u) * c);
Y1 = round(RemoveSpecials(v) * r);

end

