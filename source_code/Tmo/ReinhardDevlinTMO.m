function imgOut = ReinhardDevlinTMO(img, rd_m, rd_f, rd_a, rd_c, bNormalization)
%
%
%      imgOut = ReinhardDevlinTMO(img, pAlpha, pWhite, pLocal, phi)
%
%
%       Input:
%           -img: input HDR image
%           -rd_m: contrast in [0.3, 1.0]
%           -rd_f: intensity in [-8.0, 8.0]
%           -rd_a: light adaptation in [0.0, 1.0]
%           -rd_c: chromatic adaptation in [0.0, 1.0]
%           -bNormalization: if 1 it applies the normalization step as in
%           the original paper.
%
%       Output:
%           -imgOut: output tone mapped image in linear domain
%
%     Copyright (C) 2013-16  Francesco Banterle
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
%     "Dynamic range reduction inspired by photoreceptor physiology"
% 	  by Erik Reinhard, Kate Devlin
%     in IEEE Transaction on Computer Graphics and Visualization 2005
%

%is it a luminance or a three color channels image?
check13Color(img);

checkNegative(img);

%Luminance channel
L   = lum(img);
Lav = logMean(L);

if(~exist('rd_m', 'var'))
    Lmax = MaxQuart(L, 0.99);
    Lmin = MaxQuart(L, 0.01);
    
    Lmax = log2(Lmax + 1e-9);
    Lmin = log2(Lmin + 1e-9);
    
    k = (Lmax - log2(Lav + 1e-9)) / (Lmax - Lmin);
    
    rd_m = 0.3 + 0.7 * k^1.4;
else
    rd_m = ClampImg(rd_m, 0.3, 1.0);
end

if(~exist('rd_f', 'var'))
    rd_f = 0.0;
else
    rd_f = ClampImg(rd_f, -8.0, 8.0);
end

if(~exist('rd_c', 'var'))
   rd_c = 0.0; 
else
    rd_c = ClampImg(rd_c, 0.0, 1.0);
end

if(~exist('rd_a', 'var'))
    rd_a = 1.0;
else
    rd_a = ClampImg(rd_a, 0.0, 1.0);
end

if(~exist('bNormalization', 'var'))
    bNormalization = 1;
end

rd_f = exp(-rd_f);

[r, c, col] = size(img);
imgOut = zeros(r, c, col);

for i=1:col
    Cav = mean(mean(img(:,:,i)));
    C_i = img(:,:,i);
    
    I_l = rd_c * C_i + (1 - rd_c) * L;
    I_g = rd_c * Cav + (1 - rd_c) * Lav;
    I_a = rd_a * I_l + (1 - rd_a) * I_g;

    imgOut(:,:,i) = C_i ./ (C_i + (rd_f * I_a).^rd_m);
end

if(bNormalization)
    L = lum(imgOut);
    Lmax = max(L(:));
    Lmin = min(L(:));
    
    imgOut = ClampImg((imgOut - Lmin) / (Lmax - Lmin), 0, 1);
end

imgOut = RemoveSpecials(imgOut);

disp('WARNING: suggested gamma correction for displaying imgOut is 1.6.');

end