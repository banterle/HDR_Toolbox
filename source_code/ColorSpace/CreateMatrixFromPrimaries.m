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
%           -mtx: a conversion matrix from XYZ color space to the color
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

A_R = [R(1) R(2) R(3) 0 0 0 0 0 0; ...
       0 0 0 R(1) R(2) R(3) 0 0 0; ...
       0 0 0 0 0 0 R(1) R(2) R(3)];
b_R = [1; 0; 0];

A_G = [G(1) G(2) G(3) 0 0 0 0 0 0; ...
       0 0 0 G(1) G(2) G(3) 0 0 0; ...
       0 0 0 0 0 0 G(1) G(2) G(3)];
b_G = [0; 1; 0];

A_B = [B(1) B(2) B(3) 0 0 0 0 0 0; ...
       0 0 0 B(1) B(2) B(3) 0 0 0; ...
       0 0 0 0 0 0 B(1) B(2) B(3)];
b_B = [0; 0; 1];

A_Wp = [Wp(1) Wp(2) Wp(3) 0 0 0 0 0 0; ...
       0 0 0 Wp(1) Wp(2) Wp(3) 0 0 0; ...
       0 0 0 0 0 0 Wp(1) Wp(2) Wp(3)];
   
b_Wp = [1; 1; 1];

A = [A_R; A_G; A_B; A_Wp];
b = [b_R; b_G; b_B;  b_Wp];

mtx = A \ b;

mtx = reshape(mtx, 3, 3)';

end
