function stackOut = RandomSpatialSampling(stack, sort_index, nSamples)
%
%       stackOut = RandomSpatialSampling(stack, nSamples)
%
%
%        Input:
%           -stack: a stack of LDR images; 4-D array where values are
%           -sort_index: 
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

X = ClampImg(round(rand(nSamples, 1) * c), 1, c);
Y = ClampImg(round(rand(nSamples, 1) * r), 1, r);

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

t_min = 0.05;
t_max = 1.0 - t_min;
stackOut(stackOut < t_min | stackOut > t_max) = -1.0;

end
