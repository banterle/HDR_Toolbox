function sigma = KrawczykMaxDistance(C, bound)
%
%
%       sigma = KrawczykMaxDistance(C, bound)
%
%
%       Input:
%          -C: centroids.
%          -bound: histogram bounds.
%
%       Output:
%          -sigma: maximum distance between centroids.
% 
%     Copyright (C) 2015 Francesco Banterle
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

K = length(C);

if(K > 1)
    sigma = -1;
    for i=1:(K - 1)
        dist_adj = abs(C(i) - C(i + 1));
        sigma = max([sigma, dist_adj]);
    end
else 
    sigma = bound(2) - bound(1);
end

end