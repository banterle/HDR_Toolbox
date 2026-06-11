function mtx = CreateMatrixFromPrimaries(R, G, B, Wp)
%
%       mtx = CreateMatrixFromPrimaries(R, G, B, Wp)
%
%
%        Input:
%           -R: the red primary for the given color space expressed as an
%           XYZ color.
%           -G: the green primary for the given color space expressed as an
%           XYZ color.
%           -B: the blue primary for the given color space expressed as an
%           XYZ color.
%           -Wp: the white-point primary for the given color space expressed as an
%           XYZ color.
%
%        Output:
%           -mtx: a conversion matrix from RGB color space to the color
%           space defined by the three input primaries (R, G, and B) and
%           white point (Wp).
%
%     Copyright (C) 2018  Francesco Banterle
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

P = [R G B];
scaling = inv(P) * Wp;

mtx_scaling = zeros(3,3);
mtx_scaling(1,1) = scaling(1);
mtx_scaling(2,2) = scaling(2);
mtx_scaling(3,3) = scaling(3);

mtx = P * mtx_scaling;

end
