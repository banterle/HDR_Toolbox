function [X1, Y1] = Direction2CubeMap(D, r, c)
%
%        [X1, Y1] = Direction2CubeMap(D, r, c)
%
%
%        Input:
%           -D: 3D directions of the img format
%        Output:
%           -X1: X coordinates in the CubeMap format
%           -Y1: Y coordinates in the CubeMap format
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

[rD, cD, ~] = size(D);

X1 = zeros(rD, cD);
Y1 = zeros(rD, cD);
totD = rD * cD;

face_cm = round((r / 4 + c / 3) / 2);

%Calculating faces' directions
Mul = [1, 1, 1, -1, -1, -1];

T = [2, 1, 3, 2, 1, 3]; 
A = [1, 3, 1, 1, 3, 1]; 
B = [3, 2, 2, 3, 2, 2];

X1_1 = [1.5,2.5, 1.5, 1.5, 0.5, 1.5];
X1_2 = [0.5,0.5, 0.5,-0.5, 0.5,-0.5];
Y1_1 = [2.5,1.5, 3.5, 0.5, 1.5, 1.5];
Y1_2 = [0.5,0.5,-0.5, 0.5,-0.5,-0.5];

for i=1:6
    indx = find(    (Mul(i) * D(:,:,T(i)) > 0)&...
                    (Mul(i) * D(:,:,T(i)) >= abs(D(:,:,A(i))))&...
                    (Mul(i) * D(:,:,T(i)) >= abs(D(:,:,B(i)))));
                
    indx_shifted = indx + (T(i) - 1) * totD;
                
    X1(indx) = X1_1(i) + X1_2(i) * D(indx + (A(i) - 1) * totD) ./ D(indx_shifted);
    Y1(indx) = Y1_1(i) + Y1_2(i) * D(indx + (B(i) - 1) * totD) ./ D(indx_shifted);
end

X1 = RemoveSpecials(X1) * face_cm;
Y1 = flipud(RemoveSpecials(Y1) * face_cm);

end