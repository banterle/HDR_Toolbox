function imgOut = AkyuzEO(img, maxOutput, a_gamma, gammaRemoval)
%
%       imgOut = AkyuzEO(img, maxOutput, a_gamma, gammaRemoval)
%
%
%        Input:
%           -img: input LDR image with values in [0,1]
%           -maxOutput: the maximum output luminance value defines the 
%           -a_gamma: this value defines the appearance, for well-exposed
%                              content this value can be set to 1.0
%           -gammaRemoval: the gamma value to be removed if known
%
%        Output:
%           -imgOut: an expanded image
%
%     Copyright (C) 2011-2016  Francesco Banterle
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

check13Color(img);

checkIn01(img);

if(maxOutput <= 0.0)
    error('maxOutput needs to be a positive value');
end

if(gammaRemoval > 0.0)
    img = img.^gammaRemoval;
else
    warning(['gammaRemoval < 0.0; gamma removal has not been applied. ', ...
    'img is assumed to be linear.']);
end

if(a_gamma <= 0.0)
    error('a_gamma needs to be a positive value');
end


L = lum(img);
L_min = min(L(:));
L_max = max(L(:));
Lexp = maxOutput * (((L - L_min) / (L_max - L_min)).^a_gamma);

%remove the old luminance
imgOut = ChangeLuminance(img, L, Lexp);

end
