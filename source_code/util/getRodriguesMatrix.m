function M = getRodriguesMatrix(vec, angle)
%
%        imgOut = getRodriguesMatrix(vec, angle)
%
%        This function computes Rodrigues' matrix.
%
%        Input:
%           -vec: a 3D vector
%           -angle: rotation angle
%
%        Output:
%           -M: a rotation matrix
%
%     Copyright (C) 2026 Francesco Banterle
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
% 

len_vec = norm(vec);

I = eye(3);
if(len_vec > 0.0)
    vec = vec / len_vec;

    c = cos(angle);
    s = sin(angle);

    ci = 1.0 - c;

    % a = vec;
    % M = [a(1)^2*ci + c, a(1)*a(2)*ci - s * a(3), a(1)*a(3)*ci+s*a(2);...
    %     a(1)*a(2) * ci + s * a(3), a(2)^2 * ci + c, a(2)*a(3)*ci-s*a(1);...
    %     a(1)*a(3) * ci - s*a(2), a(2)*a(3)*ci+s*a(1), a(3)^2 * ci + c];        

    K = [ 0,     -vec(3), vec(2); ...
          vec(3), 0.0,   -vec(1); ...
         -vec(2), vec(1), 0.0];

    M = I + s * K + ci * K * K;
else
    M = I;
end

end

