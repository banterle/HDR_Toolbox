function imgOut = ChiuTMO(img, c_k, c_sigma, c_clamping, glare_opt)
%
%       imgOut = ChiuTMO(img, c_k, c_sigma, c_clamping, glare_opt)
%
%
%        Input:
%           -img: input HDR image
%           -c_k: scale correction
%           -c_sigma: local window size
%           -c_clamping: number of iterations for clamping and reducing
%                      halos. If it is negative, the clamping wL_invl not be
%                      calculate in the final image.
%           -glare_opt(1): [0,1]. If it is negative, the glare effect will
%           not be calculated in the final image. The default value is 0.8.
%           -glare_opt(2): appearance (1,+Inf]. The default is 8.
%           -glare_opt(3): size of the filter for calculating glare. The
%           default is 121.
%
%        Output:
%           -imgOut: tone mapped image in linear space.
% 
%     Copyright (C) 2010-16 Francesco Banterle
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
%     "Spatially Nonuniform Scaling Functions for High Contrast Images"
% 	  by Kenneth Chiu and M. Herf and Peter Shirley and S. Swamy and Changyaw Wang and Kurt Zimmerman
%     in Proceedings of Graphics Interface '93
%

%is it a three color channels image?
check13Color(img);

checkNegative(img);

%Luminance channel
L = lum(img);

r = size(img, 1);
c = size(img, 2);

%default parameters
if(~exist('c_k', 'var'))
    c_k = 8;
end

if(c_k <= 0)
    c_k = 8;
end

if(~exist('c_sigma', 'var'))
    c_sigma = round(16 * max([r, c]) / 1024) + 1;
end

if(~exist('c_clamping', 'var'))
    c_clamping = 500;
end

if(c_sigma <= 0)
    c_sigma = round(16 * max([r, c]) / 1024) + 1;
end

if(~exist('glare_opt', 'var'))
    glare_opt(1) = 0.8;
    glare_opt(2) = 8;    
    glare_opt(3) = 121;
end

%calculate s
s = RemoveSpecials(1 ./ (c_k * filterGaussian(L, c_sigma)));

if(c_clamping > 0) %clamp s
    L_inv = RemoveSpecials(1 ./ L);
    indx = find(s >= L_inv);
    s(indx) = L_inv(indx);

    %smoothing s
    H = [0.080 0.113 0.080;...
         0.113 0.227 0.113;...
         0.080 0.113 0.080];

    for i=1:c_clamping
        s = imfilter(s, H, 'replicate');
    end
end

%tone map the luminance
Ld = ChiuGlare(L .* s, glare_opt);

%change luminance
imgOut = ChangeLuminance(img, L, Ld);

end