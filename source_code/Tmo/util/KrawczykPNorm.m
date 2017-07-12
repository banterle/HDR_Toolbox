function P_norm = KrawczykPNorm(C, LLog10, sigma)
%
%
%       P_norm = KrawczykPNorm(C, LLog10, sigma)
%
%
%       Input:
%          -C: centroids.
%          -LLog10: luminance in log10 domain.
%          -sigma: 
%
%       Output:
%          -P_norm: normalization factor for P_i.
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

sigma_sq_2 = 2 * sigma^2;
P_norm = zeros(size(LLog10));

for i=1:length(C)
    P_norm = P_norm + exp(-(C(i) - LLog10).^2 / sigma_sq_2);
end

end