function H = LaplacianKernel(sigma)
%
%
%      H = LaplacianKernel(sigma)
%
%
%       Input:
%           -sigma: the input image
%
%       Output:
%           -H: 
%
%
%     Copyright (C) 2011-16  Francesco Banterle
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

%Laplacian mask
window = round(sigma * 7) + 1;
window_half = round(window / 2);

[X, Y] = meshgrid((-window_half):window_half, (-window_half):window_half);

sigma_sq_2 = 2 * sigma^2;

p1 = (1 - (X.^2 + Y.^2) / sigma_sq_2);
p2 = exp( - (X.^2 + Y.^2) / sigma_sq_2);
w = (-1 / (pi * sigma^4));
H =  w * p1 .* p2;

end