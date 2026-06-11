function mtx = CreateMatrixFromPrimaries_xy(R_xy, G_xy, B_xy, Wp_xy)
%
%       mtx = CreateMatrixFromPrimaries_xy(R_xy, G_xy, B_xy, Wp_xy)
%
%
%        Input:
%           -R_xy: the red primary for the given color space expressed as an
%           xy color.
%           -G_xy: the green primary for the given color space expressed as an
%           xy color.
%           -B_xy: the blue primary for the given color space expressed as an
%           xy color.
%           -Wp_xy: the white-point primary for the given color space expressed as an
%           xy color.
%
%        Output:
%           -mtx: a conversion matrix from XYZ color space to the color
%           space defined by the three input primaries (R, G, and B) and
%           white point (Wp).
%
%     Copyright (C) 2022  Francesco Banterle
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

R_xyz = Conv(R_xy, 1.0);
G_xyz = Conv(G_xy, 1.0);
B_xyz = Conv(B_xy, 1.0);
Wp_xyz = Conv(Wp_xy, 1.0);

mtx = CreateMatrixFromPrimaries(R_xyz, G_xyz, B_xyz, Wp_xyz);

end

function out = Conv(p, Y_val)
    out = zeros(3,1);
    out(1) = p(1) / p(2);
    out(2) = Y_val;
    out(3) = (1.0 - p(1) - p(2)) / p(2);
end
