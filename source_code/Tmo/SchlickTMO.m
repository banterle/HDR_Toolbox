function imgOut = SchlickTMO(img, s_mode, p, nBit, L0, k)
%
%       imgOut = SchlickTMO(img, s_mode, p, nBit, L0, k)
%
%
%       Input:
%           -img: input HDR image.
%           -s_mode: parameters selection: 'manual', 'automatic', and 'nonuniform'.
%           -p: a model parameter which takes values in [1,+inf].
%           -nBit: number of bit for the quantization step.
%           -L0: lowest value of the LDR monitor that can be perceived
%           by the HVS.
%           -k: a value in [0,1].
%
%       Output
%           -imgOut: tone mapped image
% 
%     Copyright (C) 2010-15  Francesco Banterle
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
%     "Quantization Techniques for Visualization of High Dynamic Range Pictures"
% 	  by Christophe Schlick
%     in "Photorealistic Rendering Techniques" 1995 
%

checkNegative(img);

check13Color(img);

check3Color(img);

if(~exist('s_mode', 'var'))
    s_mode = 'automatic';
end

if(~exist('nBit', 'var'))
    nBit = 8;
end

if(~exist('L0',  'var'))
    L0 = 1;
end

if(~exist('k','var'))
    k = 0.5;
end

if(~exist('p', 'var'))
    p = 1 / 0.005;
end

%compute the luminance channel
L = lum(img);

%compute the min luminance
LMin = min(L(L > 0.0));

%compute the max luminance
LMax = max(L(L>0.0));

%mode selection
switch s_mode
    case 'manual'
        p = max([p, 1]);        
        
    case 'automatic'
        p = L0 * LMax / (2^nBit * LMin);
        
    case 'nonuniform'
        p = L0 * LMax / (2^nBit * LMin);     
        p = p * (1 - k + k * L / sqrt(LMax * LMin));
end

%dynamic range reduction
Ld = p .* L ./ ((p - 1) .* L + LMax);

%change luminance
imgOut = ChangeLuminance(img, L, Ld);

end
