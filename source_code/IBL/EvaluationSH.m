function imgOut = EvaluationSH(SH, Dx,Dy,Dz)
%
%
%        imgOut = EvaluationSH(SH, Dx,Dy,Dz)
%
%
%        Input:
%           -SH: spherical harmonics coefficients
%           -Dx: X-axis values for directions
%           -Dy: Y-axis values for directions
%           -Dz: Z-axis values for directions
%
%        Output:
%           -imgOut: result of the evalutation of SH in (Dx,Dy,Dz)
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

c = [0.429043,0.511664,0.743125,0.886227,0.247708];

col = size(SH,1);
[r1,c1] = size(Dx);
imgOut = zeros(r1,c1,col);

for i=1:col
    imgOut(:,:,i) = ...
        c(1)*SH(i,9) * (Dx.^2 - Dy.^2) +...
        c(3)*SH(i,7) * (Dz.^2) +...
        c(4)*SH(i,1) -...
        c(5)*SH(i,7) +...
        2 * c(1) * (SH(i,5) * (Dx .* Dy) + SH(i,8) * (Dx .* Dz) + SH(i,6) * (Dy .* Dz)) +...
        2 * c(2) * (SH(i,4) * Dx + SH(i,2) * Dy + SH(i,3) * Dz);                    
end

end