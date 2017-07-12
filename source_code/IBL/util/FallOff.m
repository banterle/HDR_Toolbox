function Y = FallOff(r, c)
%
%
%        Y = FallOff(r, c)
%
%
%        Input:
%           -(r,c): the height and the width of the fall-off
%
%        Output:
%           -Y: the cosine fall-off 
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

[~, Y] = meshgrid(1:c, 1:r);
Y = (0.5 - Y / r) * pi;
Y = cos(Y);

end