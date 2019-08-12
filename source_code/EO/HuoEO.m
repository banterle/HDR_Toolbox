function imgOut = HuoEO(img, hou_s, hou_theta, gammaRemoval)
%
%       imgOut = HuoEO(img, hou_s, hou_theta, gammaRemoval)
%
%
%        Input:
%           -img:  input LDR image with values in [0,1]
%           -hou_s: a value which determines the dynamic range percentage
%            of the expanded image allocated to the high luminance level 
%            and low luminance level of the LDR image.
%           -hou_theta: a small value to avoid singularities. Note that
%           this drives the maximum output luminance
%           -gammaRemoval: the gamma value to be removed if known
%
%        Output:
%           -imgOut: an expanded image
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
%     The paper describing this technique is:
%     "Dodging and Burning Inspired Inverse Tone Mapping Algorithm"
% 	  by Yongqing HUO, Fan YANG, Vincent BROST 
%     in Journal of Computational Information Systems 9: 9 (2013) 3461–3468
%

check13Color(img);

checkIn01(img);

if(gammaRemoval > 0.0)
    img = img.^gammaRemoval;
else
    warning(['gammaRemoval < 0.0; gamma removal has not been applied. ', ...
    'img is assumed to be linear.']);
end

%
%
%

if(~exist('hou_s', 'var'))
    hou_s = 1.6; %default parameter from the original paper
end

if(~exist('hou_theta', 'var'))
    hou_theta = 1e-5;
end

%Calculate luminance
L = lum(img);

Lavg = mean(L(:));
Lm = (10^(-hou_s) * L) ./ (Lavg * (1.0 - L + hou_theta));

Lla = bilateralFilter(L, [], 0.0, 1.0, 16.0, (3.0 / 255.0));%as in the original paper
Lexp = Lm ./ Lla;

imgOut = zeros(size(img));

for i=1:size(img, 3)
    imgOut(:,:,i) = img(:,:,i) .* Lexp;
end

imgOut = RemoveSpecials(imgOut);
end