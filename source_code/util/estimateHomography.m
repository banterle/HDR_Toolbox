function H = estimateHomography(p1, p2)
%
%       H = estimateHomography(dir_name, format)
%
%       This function estimates a homography matrix from p1 to p2.
%
%        Input:
%           -p1: a set of points in image I1
%           -p2: a set of points in image I2
%
%        Output:
%           -H: a homography matrix from p1 to p2
%
%     Copyright (C) 2025  Francesco Banterle
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

[pn1, mtx1] = normalizeCoordinates(p1);
[pn2, mtx2] = normalizeCoordinates(p2);

n1 = size(pn1, 1);
n2 = size(pn2, 1);

if (n1 ~= n2)
    error('Coordiante vectors have different number of points.');
end

n = n1;
A = zeros(n * 2, 9);

for i=1:n
    j = (i - 1) * 2 + 1;

    A(j, 4) = pn1(i, 1);
    A(j, 5) = pn1(i, 2);
    A(j, 6) = 1.0;
    A(j, 7) = -pn2(i, 2) * pn1(i, 1);
    A(j, 8) = -pn2(i, 2) * pn1(i, 2);
    A(j, 9) = -pn2(i, 2);

    j = j + 1;

    A(j, 1) = pn1(i, 1);
    A(j, 2) = pn1(i, 2);
    A(j, 3) = 1.0;
    A(j, 7) = -pn2(i, 1) * pn1(i, 1);
    A(j, 8) = -pn2(i, 1) * pn1(i, 2);
    A(j, 9) = -pn2(i, 1);    
end

[U,S,V] = svd(A);
V = reshape(V(:, size(V,1)), 3, 3);
H = inv(mtx2) * V * mtx1;
H = H / H(3,3);

end

function [pn, mtx] = normalizeCoordinates(p)
    mu = mean(p);

    pn(:,1) = p(:,1) - mu(1);
    pn(:,2) = p(:,2) - mu(2);
    s = mean(sqrt(pn(:,1) .* pn(:,1) + pn(:,2) .* pn(:,2)));
    s = s / sqrt(2.0);
    pn = pn / s;

    mtx = zeros(3,3);
    mtx(1,1) = 1.0 / s;
    mtx(2,2) = 1.0 / s;
    mtx(1,3) = -mu(1) / s;
    mtx(2,3) = -mu(2) / s;
    mtx(3,3) = 1.0;

end