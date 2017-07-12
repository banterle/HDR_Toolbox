function [mask, s] = AkyuzLightSourcesDetection(img)
%
%       [mask, s] = AkyuzLightSourcesDetection(img)
%
%
%        Input:
%           -img: a HDR image
%
%        Output:
%           -mask: light sources mask
%           -s: spatially varying parameters
%
%     Copyright (C) 2017  Francesco Banterle
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

L = lum(img);
maxL = MaxQuart(L, 0.95);
minL = MaxQuart(L, 0.05);
delta = (maxL - minL);
[key, ~] = imKey(img, 0.05);

L_t = (0.6 + 0.4 * (1 - key)) * delta + minL;

mask = zeros(size(L));
mask(L >= L_t) = 1;

L_t0 = max([minL, L_t - 0.1 * delta]);
L_t1 = min([maxL, L_t + 0.1 * delta]);
s = (L - L_t + 0.1 * delta) / (L_t1 - L_t0);
s = 1 - 3.0 * s.^2 + 2 * s.^3;

s(L < L_t0) = 1;
s(L > L_t1) = 0;

end