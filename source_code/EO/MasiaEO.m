function [imgOut, bWarning] = MasiaEO(img, maxOutput, m_noise, m_multi_reg, gammaRemoval)
%
%       [imgOut, bWarning] = MasiaEO(img, maxOutput, m_noise, m_multi_reg, gammaRemoval)
%
%
%        Input:
%           -img: input LDR image with values in [0,1]
%           -maxOutput: maximum output luminance in cd/m^2
%           -m_noise: if set to 1 it removes noise or artifacts
%           using the bilateral filter
%           -m_multi_reg: if set to 1 it applies multi regression (2),
%           otherwise it uses SIGGRAPH ASIA paper regression (1)
%           -gammaRemoval: the gamma value to be removed if known
%
%        Output:
%           -imgOut: an expanded image
%           -bWarning: a flag if there was gamma inversion
%
%     Copyright (C) 2011-16  Francesco Banterle
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
%     The papers describing this technique are:
%     1) "Evaluation of Reverse Tone Mapping Through Varying Exposure Conditions"
%     By B. Masia, S. Augustin, R. Fleming, O. Sorkine, D. Gutierrez
%     in SIGGRAPH ASIA 2009   
%
%     2) "Dynamic Range Expansion Based on Image Statistics"
%     By B. Masia, A. Serrano, D. Gutierrez
%     in Multimedia Tools and Applications 2015     
%

check13Color(img);

checkIn01(img);

if(maxOutput < 0.0)
    error('maxOutput needs to be a positive value');
end

if(gammaRemoval > 0.0)
    img = img.^gammaRemoval;
else
    disp('WARNING: gammaRemoval < 0.0; gamma removal has not been applied');
    disp('img is assumed to be linear!');        
end

%
%
%

if(~exist('m_noise', 'var'))
    m_noise = 1;
    disp('WARNING: m_noise is set to 1.0');        
end

if(~exist('m_multi_reg', 'var'))
    m_multi_reg = 0;
    disp('WARNING: m_multi_reg is set to 0.0');    
end

bWarning = 0;

%calculate luminance
L = lum(img);

[key, Lav] = imKey(img);

%calculate the gamma correction value
if(m_multi_reg == 0)
    a_var = 10.44;
    b_var = -6.282;
    m_gamma = key * a_var + b_var;
else
    %percentage of over-exposed pixels
    p_ov = length(find((L * 255) >= 254 )) / imNumPixels(L) * 100.0;
    %Equation 5 of (2) paper
    m_gamma = 2.4379 + 0.2319 * log(Lav) - 1.1228 * key + 0.0085 * p_ov;
end

if(m_noise)%noise removal using bilateral filter
    %note that the original paper does not provide parameters for filtering
    Lbase = bilateralFilter(L);
    Ldetail = RemoveSpecials(L ./ Lbase);
    Lexp = Ldetail .* (Lbase.^m_gamma);
else
    Lexp = L.^m_gamma;
end
Lexp = Lexp * maxOutput;

%change luminance
imgOut = ChangeLuminance(img, L, Lexp);

if(m_gamma <= 0.0)
    disp(['WARNING: m_gamma value is negative (', num2str(m_gamma), ') so the image may have a false color appearance.']);
    bWarning = 1;
end

end
