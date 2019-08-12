function [result,A] = LischinskiMinimization(L, g, W, LM_alpha, LM_lambda)
%
%
%      imgOut = LischinskiMinimization(L, g, W, LM_alpha, LM_lambda)
%
%       
%
%       Input:
%           -L: log luminance
%           -g: target exposure values
%           -W: constraints
%           -LM_alpha:
%           -LM_lambda:
%
%
%       Output:
%           -result: output of the minimization
% 
%     Copyright (C) 2010-2016 Francesco Banterle
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

%init
bInit = 0;

if(~exist('W', 'var'))
    W = [];
end

if(isempty(W))
    bInit = 1;
end

if(bInit)
    W = ones(size(L));
end

if(~exist('LM_alpha', 'var'))
    LM_alpha = 1;
end

if(~exist('LM_lambda', 'var'))
    LM_lambda = 0.4;
end

%epsilon constant
e = 1e-4;

[r,c] = size(L);
n = r * c;

%build b vector
g = g .* W;
b = reshape(g, r * c, 1);

%compute gradients
dy = diff(L, 1, 1);
dy = -LM_lambda ./ (abs(dy).^LM_alpha + e);
dy = padarray(dy, [1 0], 'post');
dy = dy(:);

dx = diff(L, 1, 2); 
dx = -LM_lambda ./ (abs(dx).^LM_alpha + e);
dx = padarray(dx, [0 1], 'post');
dx = dx(:);

%build A
A = spdiags([dx, dy], [-r,-1], n, n);
A = A + A'; %symmetric conditions

g00 = padarray(dx, r, 'pre'); g00 = g00(1:end-r);
g01 = padarray(dy, 1, 'pre'); g01 = g01(1:end-1);
D = reshape(W, r * c,1) - (g00 + dx + g01 + dy);
A = A + spdiags(D, 0, n, n);

%solve A\b
if(~isa(b, 'double')) %force in case no double values are not used
    b = double(b);
end

result = A \ b;

%reshape the output
result = reshape(result,r,c);
end