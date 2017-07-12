function stackOut = RegularSpatialSampling(stack, sort_index, nSamples)
%
%       stackOut = RegularSpatialSampling(stack, sort_index, nSamples)
%
%
%        Input:
%           -stack_exposure:
%           -stack: a stack of LDR images; 4-D array where values are
%           -nSamples: the number of samples for sampling the stack
%
%        Output:
%           -stackOut: a stack of LDR samples for Debevec and Malik method
%           (gsolve.m)
%
%     Copyright (C) 2015  Francesco Banterle
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

[r, c, col, stackSize] = size(stack);

minSamples = max([round(r * c * 0.001), 512]);

if(~exist('nSamples', 'var'))
    nSamples = minSamples;
end

if(nSamples < 1)
    nSamples = minSamples;
end

stackOut = zeros(nSamples, stackSize, col);

f = round(sqrt(nSamples) + 1);
rate_x = max([ceil(c / f), 1]);
rate_y = max([ceil(r / f), 1]);

[X, Y] = meshgrid(1:rate_x:c, 1:rate_y:r);
 
X = round(X(:));
Y = round(Y(:));

nSamples = length(X);

c = 1;
for i=1:nSamples
    tmp = zeros(stackSize, col);
    for j=1:col
        for k=1:stackSize
           tmp(k,j) = stack(Y(i), X(i), j, k);
        end
    end
               
    check = checkMonotonicity(sort_index, tmp);
    
    if(check > 0)
        stackOut(c,:,:) = tmp;
        c = c + 1;
    end
end

stackOut(c : end, :, :) = [];

end