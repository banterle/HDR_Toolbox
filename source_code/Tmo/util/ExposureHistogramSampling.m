function fstops = ExposureHistogramSampling(img, nBit, eh_overlap)
%
%
%        fstops = ExposureHistogramSampling(img, nBit, eh_overlap)
%
%
%
%        Input:
%           -img: input HDR image
%           -nBit: number of bits of the sampled image
%           -eh_overlap: overlap
%
%        Output:
%           -fstops: a set of fstops values covering the HDR image
%
%     Copyright (C) 2012-15  Francesco Banterle
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

if(~exist('nBit', 'var'))
    nBit = 8;
end

if(nBit < 1)
    nBit = 8;
end

if(~exist('eh_overlap', 'var'))
    eh_overlap = 0.0;
end

nBit_half = round(nBit / 2);

nBin = 2^nBit;

fstops = [];
[histo, bound, ~] = HistogramHDR(img, nBin, 'log2', [], 0, 0);

dMM = (bound(2) - bound(1)) / nBin;

if(eh_overlap > nBit_half)
    eh_overlap = 0.0;
end

removingBins = (nBit / (1.0 / (2^nBit * dMM)) + eh_overlap);
removingBins_h = round(removingBins / 2);

while(sum(histo) > 0)
    total = -1;
    index = -1;    
    ind_min = -1;
    ind_max = -1;

    for i=1:nBin        
        i_min = max([1, (i - removingBins_h)]);
        i_max = min([(i + removingBins_h), nBin]);
        tSum = sum(histo(i_min:i_max));

        if(tSum > total)
            index = i;
            total = tSum;
            ind_min = i_min;
            ind_max = i_max;
        end
    end
        
    if(index > 0)
        histo(ind_min:ind_max) = 0;
        value = -(index * dMM + bound(1)) - nBit_half;
        fstops = [fstops, value];    
    end
    
end

% dMM = (bound(2) - bound(1)) / nBin;
% removingBins = round((4.0 - eh_overlap) / dMM);
% 
% fstops = [];
% iter = 1;
% while(sum(histo) > 0)
%     [~, ind] = max(histo);
%     indMin = max([(ind - removingBins), 1]);
%     indMax = min([(ind + removingBins), nBin]);
%    
%     iter = iter + 1;
%     histo(indMin:indMax) = 0;
%     fstops = [fstops, (-(ind * dMM + bound(1)) - 1.0)];
% end

end