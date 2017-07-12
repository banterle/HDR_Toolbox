function L_adapt = ReinhardFiltering(L, pAlpha, pPhi, pEpsilon)  
%
%
%      L_adapt = ReinhardFiltering(L, pAlpha, pPhi, pEpsilon)  
%
%
%       Input:
%           -L: input grayscale image
%           -pAlpha: value of exposure of the image
%           -pPhi: a parameter which controls the sharpening
%           -pEpsilon: smoothing threshold
%
%       Output:
%           -L_adapt: filtered image
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

if(~exist('pAlpha', 'var'))
    pAlpha = ReinhardAlpha(L);
end

if(~exist('pPhi', 'var'))
    pPhi = 8;
end

if(~exist('pEpsilon', 'var'))
    pEpsilon = 0.05;%as in the original paper
end

%precompute 9 filtered images
sMax = 8; 
[r, c] = size(L);
V_vec = zeros(r, c, sMax);

alpha1 = 1 / (2 * sqrt(2));    
constant = (2^pPhi) * pAlpha;

s = 1;
for i=1:sMax        
    V_vec(:,:,i) = ReinhardGaussianFilter(L, s, alpha1);
    s = s * 1.6;
end  
    
%threshold is a constant for solving the band-limited 
%local contrast LC at a given image location.
    
%adaptation image
L_adapt = V_vec(:,:,sMax);
mask = zeros(r,c);
for i=1:(sMax - 1)
    V1 = V_vec(:,:,i);
    V2 = V_vec(:,:,i + 1);
    
    V = (V1 - V2) ./ ((constant / (s^2)) + V1);
    V = abs(V);
        
    indx = find((V > pEpsilon) & (mask < 0.5));
    if(~isempty(indx))
        mask(indx) = i;       
        L_adapt(mask == i) = V1(mask == i);
    end
end

end