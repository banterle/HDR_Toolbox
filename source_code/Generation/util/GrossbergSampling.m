function stackOut = GrossbergSampling(stack, nSamples)
%
%       stackOut = GrossbergSampling(stack, nSamples)
%
%
%        Input:
%           -stack: a stack of LDR histograms; 
%           -nSamples: the number of samples for sampling the stack
%
%        Output:
%           -stackOut: a stack of LDR samples for Debevec and Malik method
%           (gsolve.m)
%
%     Copyright (C) 2013-15  Francesco Banterle
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

if(~exist('nSamples', 'var'))
    nSamples = 256;
end

if(nSamples < 1)
    nSamples = 256;
end

debug = 0;

[~, col, stackSize] = size(stack);

%Compute CDF
if(debug)
    figure(4);
    hold on;
end

for i=1:stackSize
    for j=1:col
        h_cdf = cumsum(stack(:,j,i));
        stack(:,j,i) = h_cdf / max(h_cdf(:));
    end
    
    if(debug)
        plot((0:255)/255,stack(:,1,i));
    end
end

delta = 1.0 / (nSamples - 1);
u = 0.0:delta:1.0;

stackOut = zeros(length(u), stackSize, col);

for i=1:length(u)
    for j=1:col
        for k=1:stackSize
           [~, val] = min(abs(stack(:,j,k) - u(i)));
           stackOut(i,k,j) = val - 1;
        end
    end
end

end