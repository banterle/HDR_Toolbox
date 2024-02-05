function [imgOut, pAlpha] = ReinhardRobustTMO(img, pAlpha)
%
%
%      [imgOut, pAlpha] = ReinhardRobustTMO(img, pAlpha)
%
%
%       Input:
%           -img: input HDR image
%           -pAlpha: value of exposure of the image, if not specified it
%           will be automaticallyc computed
%
%       Output:
%           -imgOut: output tone mapped image in linear domain
%           -pAlpha: as in input
%
%     Copyright (C) 2024 Francesco Banterle
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
%     This is a robust version of the paper:
%     "Photographic Tone Reproduction for Digital Images"
% 	  by Erik Reinhard, Michael Stark, Peter Shirley, James Ferwerda
%     in Proceedings of SIGGRAPH 2002
%

delta = 1e-5;
L = lum(img);

Lmin 	= MaxQuart(L, 0.01);
Lmax 	= MaxQuart(L, 0.99);
%clamp luminance using percentiles; i.e., 1-st and 99-th.
L_c = ClampImg(L, Lmin, Lmax);

Lwa = logMean(L_c, delta);

if (~exist('pAlpha', 'var'))
    pAlpha = ReinhardAlpha(L_c, delta);
end

%scale luminance according to Lwa and pAlpha
L_s    = (pAlpha ./ Lwa) .* L_c;
%tone map using the simple sigmoid fnction
Ld    = L_s ./ (1.0 + L_s);

imgOut = ChangeLuminance(img, L, Ld);

end