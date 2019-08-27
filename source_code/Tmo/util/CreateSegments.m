function imgBin = CreateSegments(img)
%
%
%       imgBin = CreazioneZone(img)
%
%
%       Input:
%           -img: an HDR image
%
%       Output:
%           -imgBin: the segmented HDR image
% 
%       This function segments an image into different dynamic range zones
%       based on their order of magnitude.
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

L = lum(img);

%filter the image to avoid noise
L = filterGaussian(L, 1);

%compute Lmin and Lmax
Lmin = min(L(L > 0.0));
Lmax = max(L(:));

%compute min and max in log10
l10Min = log10(Lmin);
l10Max = log10(Lmax);

%Max and Min sign
sMin = sign(l10Min);
sMax = sign(l10Max);

%discretize
if(sMin > 0)
    l10Min = sMin * floor(abs(l10Min));
else
    l10Min = sMin * ceil(abs(l10Min));
end

if(sMax > 0)
    l10Max = sMax * ceil(abs(l10Max));
else
    l10Max = sMax * floor(abs(l10Max));
end
    
imgBin = zeros(size(L));

[n,m]   = size(L);
nLevels = l10Max - l10Min + 1;

for i=l10Min:l10Max %skim levels
    bMin = 10^i;
    bMax = 10^(i + 1);   
    imgBin(L >= bMin & L < bMax) = i - l10Min + 1;
end

%compute the number of pixels
areaTot = n * m;

%set thresholds
threshold = 0.005;
perCent = round(threshold * areaTot);

%merge layers...
imgOri    = imgBin;
imgBinOld = imgBin;
for LOOP=1:100
    layer = GenerateMasks(imgBin, nLevels);

    for i=1:nLevels%for each luminance level
        comp = layer(:,:,i);
        nc = max(comp(:));

        for j=1:nc %for each connected component (CC)
            [r, c] = find(comp == j);
            [yy, xx] = size(r);
            tot = xx * yy;
        
            %is it a small CC?
            if(tot < perCent && tot > 0)
                listOfNeighbors   = findNeighbors(i, r , c, tot, imgBin);
                [imgBin, nlv] = computeFusionMask(listOfNeighbors, comp, imgBin,j);
                
                if(nlv > 0)%update
                    layer = GenerateMasks(imgBin, nLevels);
                    comp  = layer(:,:,i);
                end
            end            
        end
    end
    
    %check for ending
    delta = imgBinOld - imgBin;    
    val   = abs(sum(delta(:)));
    if(val < 1e-4)        
        break;
    else
        imgBinOld = imgBin;
    end
end

%sanity check
for i=1:nLevels
    indx = find(imgBin == i);
    if(~isempty(indx))
        val = round(mean(imgOri(indx)));
        imgBin(indx) = val;
    end
end

imgBin = imgBin + l10Min - 1;

end

function [imgBin, nlv] = computeFusionMask(listOfNeighbors, comp, imgBin, j)

nlv = length(listOfNeighbors);

if(nlv > 0) %take the smallest cluster in the list for the merging step
imgBin(comp == j) = listOfNeighbors(1);
end

end
