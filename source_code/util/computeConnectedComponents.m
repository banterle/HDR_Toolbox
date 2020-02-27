function [imgLabel, labels, labels_shift] = computeConnectedComponents(img, mode)
%
%
%       [imgLabel, labels, labels_shift] = computeConnectedComponents(img, mode)
%
%
%        Input:
%           -img: an integer grayscale image
%           -mode: 4 or 8 neighbors; this is the connetion type
%
%        Output:
%           -imgLabel: labelled image
%           -labels: all labels in imgLabel
%           -labels_shift:
%
%     Copyright (C) 2011-2020  Francesco Banterle
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

r = size(img, 1);
c = size(img, 2);
imgLabel = zeros(r, c);

labels = unique(img);
n = length(labels);
totLabels = 0;

if(~exist('type', 'var'))
    
end

if(mode ~= 4 || mode ~= 8)
    mode = 4;
end

labels_shift = 0;

for i=1:n
    
    indx = find(img == labels(i));   
    if(~isempty(indx))
        imbBin_i = zeros(r,c); %create a binary image
        imbBin_i(indx) = 1;
        segmented_i = bwlabel(logical(imbBin_i), mode);
        
        imgLabel = imgLabel + (segmented_i + totLabels);
        totLabels = totLabels + max(segmented_i(:)) + 1;
        
        labels_shift = [labels_shift, totLabels];
    end    
end

end

