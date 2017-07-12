function frameHDR = MaiHDRvDecFrame(frameTMO, l, v, frameR, r_min, r_max)
%
%
%       frameHDR = MaiHDRvDecFrame(frameTMO, l, v, frameR, r_min, r_max, fSaturation, tmo_gamma)
%
%
%       Input:
%           -frameTMO: a tone mapped frame from the video stream with values in [0,255] at 8-bit
%           -l: tone mapping function
%           -v: tone mapping function
%           -frameR: a residual frame from the residuals stream with values in [0,255] at 8-bit
%           -r_min: the minimum value of frameR
%           -r_max: the maximum value of frameR
%
%       Output:
%           -frameHDR: the reconstructed HDR frame
%
%     Copyright (C) 2013-14  Francesco Banterle
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
%     "Optimizing a Tone Curve for Backward-Compatible High Dynamic Range Image and Video Compression"
% 	  by Chul Zicong Mai, Hassan Mansour, Rafal Mantiuk, Panos Nasiopoulos,
%     Rabab Ward, and Wolfgang Heidrich
%     in IEEE TRANSACTIONS ON IMAGE PROCESSING, VOL. 20, NO. 6, JUNE 2011
%
%

%decompression of the residuals frame
frameR = frameR(:,:,1);
frameR = double(frameR) / 255.0;
frameR = frameR * (r_max - r_min) + r_min;

%decompression of the tone mapped frame
frameTMO = double(frameTMO) / 255.0;
L = lum(frameTMO);
%inverse tone mapping with (l,v);
Lw = 10.^interp1(v, l, L, 'linear'); 

%expanding luminance
epsilon = 0.05;
h = exp(frameR) .* (Lw + epsilon);

%adding colors
frameHDR = RemoveSpecials(ChangeLuminance(frameTMO, L, h));

end

