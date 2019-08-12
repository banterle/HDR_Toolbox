function imgOut = ExponentialTMO(img, exp_k)
%
%       imgOut = ExponentialTMO(img, exp_k) 
%
%
%       Input:
%           -img: input HDR image
%           -exp_k: appearance value [1, +inf)
%
%       Output
%           -imgOut: tone mapped image
% 
%     Copyright (C) 2010-15 Francesco Banterle
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

%is it a three color channels image?
check13Color(img);

checkNegative(img);

if(~exist('exp_k', 'var'))
    exp_k = 1;
end

if(exp_k <= 0)
    exp_k = 1;
end

%Luminance channel
L = lum(img);

Lwa = logMean(L); %geometric mean

%dynamic range reduction
Ld = 1 - exp(-exp_k * ( L / Lwa));

%change luminance in img
imgOut = ChangeLuminance(img, L, Ld);

end
