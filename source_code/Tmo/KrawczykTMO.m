function imgOut = KrawczykTMO(img)
%
%
%       imgOut = KrawczykTMO(img)
%
%
%       Input:
%          -img: an input HDR image
%
%       Output:
%          -imgOut: a tone mapped image
% 
%     Copyright (C) 2010-15 Francesco Banterle
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
%     "Lightness Perception in Tone Reproduction for High Dynamic Range Images"
% 	 by Grzegorz Krawczyk, Karol Myszkowski, Hans-Peter Seidel
%      in Proceedings of EUROGRAPHICS 2005
%

%is it a luminance or a three color channels image?
check13Color(img);
checkNegative(img);

%compute luminance
L = lum(img);

%compute the image histrogram in log space
[histo, bound, ~] = HistogramHDR(img, 256, 'log10', [], 0, 0, 1e-6);

LLog10 = log10(L + 1e-6);

%k-means for computing centroids
[C, totPixels] = KrawczykKMeans(bound, histo);

%partition the image into frameworks
[framework, distance, C] = KrawczykImagePartition(C, LLog10, bound, totPixels);

%compute P_i
sigma = KrawczykMaxDistance(C, bound);
[height, width, ~] = size(img);
sigma_sq_2 = 2 * sigma^2;
K = length(C);
A = zeros(K, 1);
P = zeros(height, width, K);
P_norm = zeros(size(L));
sigma_a_sq_2 = 2 * 0.33^2;

half_dim =  min([height, width]) / 2;
for i=1:K
    indx = find(framework == i);
    if(~isempty(indx))
        %compute the articulation of the i-th framework
        maxY = max(LLog10(indx));
        minY = min(LLog10(indx));        
        A(i) = 1 - exp(-(maxY - minY)^2 / sigma_a_sq_2);
        %compute the probability P_i
        P(:,:,i) = exp(-(C(i) - LLog10).^2 / sigma_sq_2);
        %spatial processing
        P(:,:,i) = bilateralFilter(P(:,:,i), [], 0, 1, half_dim, 0.4);
        %normalization
        P_norm = P_norm + P(:,:,i) * A(i);
    end
end

%compute probability maps
Y = LLog10;
for i=1:K
    indx = find(framework == i);
    if(~isempty(indx))
        %P_i normalization
        P(:,:,i) = RemoveSpecials(P(:,:,i) * A(i) ./ P_norm);        
        %anchoring
        W = MaxQuart(LLog10(indx), 0.95);
        Y = Y - W * P(:,:,i);
    end
end

%clamp in the range [-2, 0]
Y = ClampImg(Y, -2, 0);
%remap values in [0,1]
Ld = (10.^(Y + 2)) / 100;

%change luminance
imgOut = ChangeLuminance(img, L, Ld);
end
