function imgOut = WardGlobalTMO(img, Ld_max)
%
%       imgOut = WardTMO(img, Ld_max)
%
%
%       Input:
%           -img: input HDR image
%           -Ld_max: maximum monitor LDR luminance in cd/m^2
%
%       Output
%           -imgOut: tone mapped image
% 
%     Copyright (C) 2010 Francesco Banterle
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
%     "A Contrast-Based Scalefactor for Luminance Display"
% 	  by Greg J. Ward
%     in Graphics Gems IV
%

%is it a gray/three color channels image?
check13Color(img);

checkNegative(img);

if(~exist('Ld_max', 'var'))
    Ld_max = 100;
end

if(Ld_max <= 0.0)
    Ld_max = 100;
end

%compute luminance channel
L = lum(img);

Lwa = logMean(L); %compute geometry mean

%contrast scale
m = (((1.219 + (Ld_max / 2)^0.4) / (1.219 + Lwa^0.4))^2.5);

imgOut = ClampImg(img * m / Ld_max, 0.0, 1.0);

end