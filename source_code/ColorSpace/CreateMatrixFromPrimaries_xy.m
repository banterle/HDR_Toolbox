function mtx = CreateMatrixFromPrimaries_xy(R, G, B, Wp)
%
%       mtx = CreateMatrixFromPrimaries_xy(R, G, B, Wp)
%
%
%        Input:
%           -R: the red primary for the given color space expressed as an
%           xy color.
%           -G: the green primary for the given color space expressed as an
%           xy color.
%           -B: the blue primary for the given color space expressed as an
%           xy color.
%           -Wp: the white-point primary for the given color space expressed as an
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


R  = ConvertXYZtoYxy(reshape([1.0,  R], 1, 1, 3), 1);
G  = ConvertXYZtoYxy(reshape([1.0,  G], 1, 1, 3), 1);
B  = ConvertXYZtoYxy(reshape([1.0,  B], 1, 1, 3), 1);
Wp = ConvertXYZtoYxy(reshape([1.0, Wp], 1, 1, 3), 1);

mtx = CreateMatrixFromPrimaries(R, G, B, Wp);

end
