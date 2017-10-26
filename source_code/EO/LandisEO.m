function imgOut = LandisEO(img, l_alpha, l_threshold,  maxOutput, gammaRemoval)
%
%       imgOut = LandisEO(img, l_alpha, l_threshold, maxOutput, gammaRemoval)
%
%
%        Input:
%           -img:  input LDR image with values in [0,1]
%           -l_alpha: this value defines the 
%           -l_threshold: threshold for applying the iTMO
%           -maxOutput: maximum output luminance
%           -gammaRemoval: the gamma value to be removed if known
%
%        Output:
%           -imgOut: an expanded image
%
%     Copyright (C) 2011-13  Francesco Banterle
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

if(~exist('l_alpha','var'))
    l_alpha = 2.0;  
    disp('WARNING: l_alpha is set to 2.0');
end

if(l_alpha <= 0.0)
    l_alpha = 2.0;
end

if(~exist('l_threshold','var'))
    l_threshold = 0.5;
    disp('WARNING: l_threshold is set to 0.5');    
end

if(l_threshold <= 0.0)
    l_threshold = 0.5;
    disp('WARNING: l_threshold is set to 0.5');        
end

%Luminance channel
L = lum(img);


if(l_threshold <= 0) %Expanding from the mean value
    l_threshold = mean(L(:));
end

%Finding pixels needed to be expanded
toExpand = find(L >= l_threshold);

%Exapnsion using a power function
weights = ((L(toExpand) - l_threshold) / (max(L(:)) - l_threshold)).^l_alpha;

Lexp = L;
Lexp(toExpand) = L(toExpand) .* (1 - weights) + maxOutput * L(toExpand) .* weights;

%Removing the old luminance
imgOut = ChangeLuminance(img, L, Lexp);

end