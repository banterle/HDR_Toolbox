function [hdrv, stats_v, hists_v] = hdrvAnalysis(hdrv, percentile, crop_rect, bHistogram)
%
%         [hdrv, stats_v, hists_v] = hdrvAnalysis(hdrv, percentile, crop_rect, bHistogram)
%
%        This function computes the statistics of all frames of an HDR
%        video.
%
%        Input:
%           -hdrv: a open HDR video structure
%           -percentile: the percentile for robust statistics
%           -crop_rect:
%           -bHistogram:
%
%        Output:
%           -hdrv  : a close HDR video structure
%           -stats_v  : harmonic mean of each frame
%           -hists_v : max of each frame
%
%     Copyright (C) 2013-17  Francesco Banterle
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

if(~exist('percentile', 'var'))
    percentile = 0.99;
end

if(percentile > 1)
    percentile = 0.99;
end

if(percentile < 0.5)
    percentile = 0.5 + 1e-6;
end

if(~exist('crop_rect', 'var'))
    bCR = 0;
else    
    if(~isempty(crop_rect))
        bCR = (crop_rect(1) > 0 & crop_rect(2) > 0);
    else
        bCR = 0;
    end
end

nBins = 4096;

stats_v = zeros(hdrv.totalFrames, 6);
hists_v = zeros(hdrv.totalFrames, nBins);

hdrv = hdrvopen(hdrv);
for i=1:hdrv.totalFrames
    [frame, hdrv] = hdrvGetFrame(hdrv, i);    
        
    if(bCR)
        [r,c,~] = size(frame);    
        frame = frame(crop_rect(1):(r - crop_rect(1)), ...
                      crop_rect(2):(c - crop_rect(2)), :);
    end
    
    %remove specials
    frame = RemoveSpecials(frame); 
    
    %avoid negative values
    L = lum(frame);
    indx = find(L >= 0.0);
    if(~isempty(indx))
        stats_v(i, 1) = min(L(indx));
        stats_v(i, 2) = max(L(indx));
        stats_v(i, 3) = MaxQuart(L(indx), 1 - percentile);
        stats_v(i, 4) = MaxQuart(L(indx), percentile);
        stats_v(i, 5) = mean(L(indx));
        stats_v(i, 6) = logMean(L(indx));       
        if(bHistogram)
            hists_v(i, :) = HistogramHDR(L(indx), nBins, 'log10', [-6, 6], 0, 0, 1e-6);
        end
    end
end

hdrv = hdrvclose(hdrv);

end