function [ldrv, stats_v, hists_v] = ldrvAnalysis(ldrv, percentile, crop_rect, bHistogram)
%
%         [ldrv, stats_v, hists_v] = ldrvAnalysis(ldrv, percentile, crop_rect, bHistogram)
%
%        This function computes the statistics of all frames of an HDR
%        video.
%
%        Input:
%           -ldrv: a open HDR video structure
%           -percentile: the percentile for robust statistics
%           -crop_rect:
%           -bHistogram:
%
%        Output:
%           -ldrv  : a close HDR video structure
%           -stats_v  : harmonic mean of each frame
%           -hists_v : max of each frame
%
%     Copyright (C) 2021  Francesco Banterle
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

if(~exist('bHistogram', 'var'))
    bHistogram = 0;
end

nBins = 4096;

stats_v = zeros(ldrv.totalFrames, 6);
hists_v = zeros(ldrv.totalFrames, nBins);

ldrv = ldrvopen(ldrv);
for i=1:ldrv.totalFrames
    [frame, ldrv] = ldrvGetFrame(ldrv, i);    
        
    if(bCR)
        [r,c,~] = size(frame);    
        frame = frame(crop_rect(1):(r - crop_rect(1)), ...
                      crop_rect(2):(c - crop_rect(2)), :);
    end
    
    %remove specials
    frame = RemoveSpecials(frame); 
    
    %avoid negative values
    L = lum(frame.^2.2);
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

ldrv = hdrvclose(ldrv);

end