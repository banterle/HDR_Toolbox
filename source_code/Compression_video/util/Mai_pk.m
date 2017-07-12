function pk = Mai_pk(P, k, l, bounds)
%
%
%       pk = Mai_pk(P, k, l, bounds)
%
%
%       Input:
%           -P: histogram
%           -k: 
%           -l: segments
%           -bounds: min and max luminance value for P
%
%       Output:
%           -pk: evaluation
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

N = length(P);

M = length(l);
lk  = l(k);
lkp = l(min([k + 1, M]));

lk = ClampImg(lk, bounds(1), bounds(2));
lkp = ClampImg(lkp, bounds(1), bounds(2));

a = floor((N-1) * (lk  - bounds(1)) / (bounds(2) -  bounds(1))) + 1;
b = ceil((N-1) * (lkp - bounds(1)) / (bounds(2) -  bounds(1))) + 1;

pk = 0.0;

for i=a:b
    pk = pk + P(i);
end

end