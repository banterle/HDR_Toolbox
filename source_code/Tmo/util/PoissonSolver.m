function x = PoissonSolver(f, smoothingCost)
%
%       x = PoissonSolver(f, smoothingCost)
%
%
%       Input:
%           -f: function
%
%       Output:
%           -x: result of Poisson equation
% 
%     Copyright (C) 2010-2012 Francesco Banterle
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

if(~exist('smoothingCost', 'var'))
    smoothingCost = 0;
end

[r,c] = size(f);
n = r * c;

%b vector
b = -reshape(f, r * c, 1);

%Build A matrix
if(smoothingCost > 0.0)
    A = spdiags((4 + smoothingCost) * ones(n, 1), 0, n, n);
else
    A = spdiags(4 * ones(n, 1), 0, n, n);
end

T = ones(n,1);
O = T;
T(1:r:n) = 0;
B = spdiags(-T, 1, n, n) + spdiags(-O, r, n, n);
A = A + B + B';

%Solve Poisson equation: Ax = b
if(~isa(b, 'double')) %force in case no double values are not used
    b = double(b);
end

x = A \ b;
x = x(1:n);
x = reshape(x, r, c);

end