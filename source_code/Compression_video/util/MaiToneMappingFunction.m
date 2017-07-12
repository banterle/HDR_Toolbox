function [l, s, v] = MaiToneMappingFunction(L, mai_delta)
%
%
%       [l, s, v] = MaiToneMappingFunction(L, mai_delta)
%
%
%       Input:
%           -L: HDR luminance
%           -mai_delta: delta value
%
%       Output:
%           -l: luminance in log10
%           -s: slopes
%           -v: vertical value for l
%
%     Copyright (C) 2013-2015  Francesco Banterle
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

if(~exist('mai_delta','var'))
    mai_delta = 0.1;
end

v_max = 10.0;
s_min = 0.5 / mai_delta;
s_max = 1.0 / log10(1.01);

nBin = 256;

[histo,bounds,haverage] = HistogramHDR(L, nBin, 'log10');

P = histo / sum(histo(:));

%l, v values
l = bounds(1):mai_delta:bounds(2);
s = zeros(size(l));
N = length(l);

%equation 14
norm = 0.0;
p = zeros(size(l));
for k=1:N
    p(k) = Mai_pk(P, k, l, bounds)^(1/3);
    norm = norm + p(k); 
end

out_of_bound = 0.0;
norm2 = 0.0;
for k=1:N
    s(k) = (v_max * p(k)) / ( mai_delta * norm );    

    if(s(k) > s_max)
        out_of_bound = out_of_bound + 1;
    else
        norm2 = norm2 + p(k);
    end
end

%final adjustment
if(out_of_bound > 0.0)
    for k=1:N
        if(s(k) > s_max)
            s(k) = s_max;
        else
            s(k) = (v_max - (s_max * mai_delta * out_of_bound)) * p(k);
            s(k) = s(k) / (mai_delta * norm2);
        end 
    end
end

v = zeros(size(l));
v(1) = 0;
for i=2:N
    v(i) = v(i - 1) + s(k) * mai_delta;
end

end
