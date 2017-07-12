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

%Filtering the image to avoid noise
L = GaussianFilter(L, 1);

%Lmax, Lmin
Lmin = min(L(L > 0.0));
Lmax = max(L(:));

%Max and Min in log10
l10Min = log10(Lmin);
l10Max = log10(Lmax);

%Max and Min sign
sMin = sign(l10Min);
sMax = sign(l10Max);

%Discretization
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

for i=l10Min:l10Max %skimming levels
    bMin = 10^i;
    bMax = 10^(i + 1);   
    imgBin(L >= bMin & L < bMax) = i - l10Min + 1;
end

%Number of pixels
areaTot = n * m;

%Thresholds
threshold = 0.005;
perCent = round(threshold * areaTot);

%Merging layers...
imgOri    = imgBin;
imgBinOld = imgBin;
for LOOP=1:100
    layer = GenerateMasks(imgBin, nLevels);

    for i=1:nLevels%for each luminance level
        comp = layer(:,:,i);
        nc = max(comp(:));

        for j=1:nc %For each connected component (CC)
            [r, c] = find(comp==j);
            [yy, xx] = size(r);
            tot = xx * yy;
        
            %Is it a small CC?
            if(tot < perCent && tot > 0)
                listOfNeighbors   = FindNeighbours(i, r , c, tot, imgBin);
                [imgBin, nlv] = FusionMask(listOfNeighbors, comp, imgBin,j);
                
                if(nlv > 0)%Update
                    %clear('layer');
                    layer = GenerateMasks(imgBin, nLevels);
                    comp  = layer(:,:,i);
                end
            end            
        end
    end
    
    %Check for ending
    delta = imgBinOld - imgBin;    
    val   = abs(sum(delta(:)));
    if(val < 1e-4)
        %disp([val,LOOP]);
        break;
    else
        imgBinOld = imgBin;
    end
end

%Sanity check
for i=1:nLevels
    indx = find(imgBin == i);
    if(~isempty(indx))
        val = round(mean(imgOri(indx)));
        imgBin(indx) = val;
        %disp([i,val]);
    end
end

%clear('layer');
%clear('comp');

imgBin = imgBin + l10Min - 1;

end

