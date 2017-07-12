function imgOut = KimKautzConsistentTMO(img, Ld_max, Ld_min, KK_c1, KK_c2)
%
%
%      imgOut = KimKautzConsistentTMO(img, Ld_max, Ld_min, KK_c1, KK_c2)
%
%
%       Input:
%           -img: input HDR image
%           -Ld_max: max luminance of the LDR monitor in cd/m^2
%           -Ld_min: max luminance of the LDR monitor in cd/m^2
%           -KK_c1: this parameter adjusts the shape of Gaussian fall-off
%           within the width of tis characteristic curve. It influcences
%           the resulting brightness and local details of the tone-mapped
%           image. A good value is 3.0 (tradeoff between compression and
%           lost details)
%           -KK_c2: the ratio between the dynamic range (in log10) of an
%           8-bit imag (2.4) and the dynamic range (in log10) of the 
%           LDR monitor for visualization
%
%       Output:
%           -imgOut: output tone mapped image in linear domain
%
%     Copyright (C) 2013-15  Francesco Banterle
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
%     The paper describing this technique is:
%     "Consistent Tone Reproduction"
% 	  by Min H. Kim, Jan Kautz
%     in CGIM '08 Proceedings of the Tenth IASTED
%     International Conference on Computer Graphics and Imaging  2008
%

checkNegative(img);

if(~exist('Ld_max', 'var'))
    Ld_max = 300; %300 cd/m^2
end

if(~exist('Ld_min', 'var'))
    Ld_min = 0.3; %0.3 cd/m^2
end

if(~exist('KK_c1', 'var'))
    KK_c1 = 3.0; %as in the original paper
end

if(~exist('KK_c2', 'var'))
    KK_c2 = 0.5; %as in the original paper
end

L = lum(img);

L_log = log(L + 1e-6);

mu = mean(L_log(:));

maxL = max(L_log(:));
minL = min(L_log(:));

maxLd = log(Ld_max);
minLd = log(Ld_min);

k1 = (maxLd - minLd) / (maxL - minL);

d0 = maxL / minL;
sigma = d0 / KK_c1;

sigma2 = (sigma^2) * 2;
w = exp(-(L - mu).^2 / sigma2);
k2 = (1 - k1) * w + k1;

Ld = exp(KK_c2 * k2 .* (L_log - mu) + mu);

%Percentile clamping
maxLd = MaxQuart(Ld, 0.99);
minLd = MaxQuart(Ld, 0.01);

Ld(Ld > maxLd) = maxLd;
Ld(Ld < minLd) = minLd;

Ld = (Ld - minLd) / (maxLd - minLd);

%Changing luminance
imgOut = ChangeLuminance(img, L, Ld);
imgOut = RemoveSpecials(imgOut);

end
