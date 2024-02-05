function alpha = ReinhardAlpha(L, delta)
%
%
%      alpha = ReinhardAlpha(L, delta)
%
%       This function estimates the exposure, \alpha, for ReinhardTMO
%
%       Input:
%           -L: luminance channel 
%
%       Output:
%           -alpha: exposure
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

if(~exist('delta', 'var'))
    delta = 1e-6;
end

LMin = MaxQuart(L, 0.01);
LMax = MaxQuart(L, 0.99);

log2Min     = log2(LMin + delta);
log2Max     = log2(LMax + delta);
logAverage  = logMean(L);
log2Average = log2(logAverage + delta);

alpha = 0.18*4^((2.0*log2Average - log2Min - log2Max)/( log2Max - log2Min));

end