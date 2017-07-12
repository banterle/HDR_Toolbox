function [y, Y_min, Y_max] = ZhangQuantization(Y, n_bits)
%
%
%       [y, Y_min, Y_max] = ZhangQuantization(Y, n_bits)
%
%
%       Input:
%           -Y: log luminance channel
%           -n_bits: number of bits for quantization
%
%       Output:
%           -y: centroids output from Llyod-Max algorithm
%           -Y_min: Y minimum value
%           -Y_max: Y maximum value
%
%     Copyright (C) 2013-2014  Francesco Banterle
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

if(~exist('n_bits','var'))
    n_bits = 8;
end

%Assuming 16-bits quantization from LogLuv
L = 2^n_bits;
N = 2^16;

%computing the histogram
Y_max = max(Y(:));
Y_min = min(Y(:));

P = zeros(1, N);
for i=Y_min:Y_max
    P(i) = length(find(Y==i));
end

y = sort(round(rand(1,L)*N));

converged = 0;
iter = 0;
sigma_2_old = 1e20;
maxIterations = 1000;

while((~converged)&&(iter < maxIterations))
    b = round([y(1) + 1, y(2:L) + y(1:(L-1)), N + y(L) ]/2);
    b = ClampImg(b, 1, N);
       
    %computing the mean square error
    sigma_2 = 0.0;
    for i=1:L
        for k=b(i):b(i+1)
            sigma_2 = sigma_2 + P(k)*(k - y(i)).^2;
        end       
    end
    
    %updating y
    for i=1:L
        y_new = 0;
        norm = 0;
        for k=b(i):b(i+1)           
            y_new = y_new  + k * P(k);
            norm = norm + P(k);
        end
        
        if(norm>0)
            y(i) = y_new / norm;
        end
    end
    
    if(sigma_2>sigma_2_old)
        converged = 1;
    end
    
    sigma_2_old = sigma_2;
    
    iter = iter + 1;
end

end