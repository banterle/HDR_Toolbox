function wp = ReinhardWhitePoint(L)
%
%
%      alpha = ReinhardWhitePoint(L)
%
%       This function estimates the white point wp for ReinhardTMO
%
%       Input:
%           -L: luminance channel 
%
%       Output:
%           -wp: the white point
% 
%     Copyright (C) 2013  Francesco Banterle
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

LMin = MaxQuart(L, 0.01);
LMax = MaxQuart(L, 0.99);

log2Min     = log2(LMin + 1e-9);
log2Max     = log2(LMax + 1e-9);

wp = 1.5 * 2^(log2Max - log2Min - 5);

end