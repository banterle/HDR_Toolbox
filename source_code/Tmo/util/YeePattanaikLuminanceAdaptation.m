function La = YeePattanaikLuminanceAdaptation(img, maxLayers)
%
%
%       La = YeePattanaikLuminanceAdaptation(img, maxLayers)
%
%
%       Input:
%           -img: HDR image
%           -maxLayers: the number of layers in [16,96]
%
%       Output:
%           -La: luminance adaptation
% 
%     Copyright (C) 2010-2020  Francesco Banterle
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
%     "Segmentation and Adaptive Assimilation for Detail-Preserving Display of High-Dynamic Range Images"
% 	  by Hector Yee, Sumanta N. Pattanaik
%     in Elsevier The Visual Computer 2003
%

%is it a three color channels image?
check13Color(img);

checkNegative(img);

%check parameters
if(~exist('maxLayers', 'var'))
    maxLayers = 32;
end

if((maxLayers < 16) || (maxLayers > 96))
    maxLayers = 32;
end

maxLayers = round(maxLayers);

%these could be parameters
bin_size1 = 0.5;
bin_size2 = 2.0;

%compute luminance channel
L = lum(img);

%compute the adaptation
L_log = log10(L + 1e-6);
minL_Log = min(L_log(:));

La = zeros(size(L));

for i=0:(maxLayers - 1)
    bin_size = bin_size1 + (bin_size2 - bin_size1) * i / (maxLayers - 1);    
    category = round((L_log - minL_Log) / bin_size) + 1; 

    %compute layers
    [imgLabel, ~, ~] = computeConnectedComponents(category, 8);    
    labels = unique(imgLabel);      
    
    for j=1:length(labels) %adaptation group
        indx = find(imgLabel == labels(j));
        La(indx) = La(indx) + mean(L_log(indx));
    end
end

La = 10.^(La / maxLayers);
La(La < 0.0) = 0.0;

end
