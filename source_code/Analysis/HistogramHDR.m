function [histo, bounds, haverage] = HistogramHDR(img, nBins, typeLog, bounds, bNormalized, bPlot, epsilon)
%
%
%        [histo, bounds, haverage] = HistogramHDR(img, nBins, typeLog, bounds, bNormalized, bPlot, epsilon)
%
%
%        Input:
%           -img: input HDR image
%           -nBins: number of bins for calculating the histogram
%           -typeLog: type of space for calculating the histogram: 'linear'
%           for linear space, 'log2' for base 2 logarithm space, 'loge', for
%           natural logarithm space, 'log10' for base 10 logarithm space
%           -bounds: the maximum, bounds(2), and minimum, bounds(1) value
%           of the histogram
%           -bNormalized: the histogram is normalized
%           -bPlot: if it is true the histogram is visualised
%
%        Output:
%           -histo: the histogram of the image
%           -bounds: maximum, bounds(2), and minimum, bounds(1), values of
%           the histogram
%           -haverage: the average of values in the histogram
%
%     Copyright (C) 2011-15  Francesco Banterle
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

if(~exist('nBins', 'var'))
    nBins = 256;
end

if(~exist('typeLog', 'var'))
    typeLog = 'log10';
end

if(~exist('bNormalized', 'var'))
    bNormalized = 0;
end

if(~exist('bounds', 'var'))
    bounds = [];
end

if(~exist('bPlot', 'var'))
    bPlot = 0;
end

if(~exist('epsilon', 'var'))
    epsilon = 1e-6;
end

L  = lum(img);
L  = L(:);
L2 = L;

switch typeLog
    case 'log2'
    	L = log2(L + epsilon);
        
    case 'loge'
        L = log(L + epsilon);
        
    case 'log10'
    	L = log10(L + epsilon);
end

histo = zeros(nBins, 1);

if(isempty(bounds))
    Lmin = min(L);
    Lmax = max(L);
    bounds(1) = Lmin;
    bounds(2) = Lmax;
else
    Lmin = bounds(1);
    Lmax = bounds(2);
end

dMM  = (Lmax - Lmin) / (nBins - 1);

haverage = 0;
total = 0;

for i=1:nBins
    indx  = find(L >= (dMM * (i - 1) + Lmin) & L < (dMM * i + Lmin));
    count = numel(indx);
    
    if(count > 0)
        histo(i) = count;
        haverage = haverage + MaxQuart(L2(indx), 0.5) * count;
        total    = total + count;
    end
end

if(bNormalized)
    norm = sum(histo);
    if(norm > 0)
        histo = histo / norm;
    end
end

haverage = haverage / (total);

if(bPlot)
    x = ((1:nBins) / nBins) * (Lmax - Lmin) + Lmin;
    bar(x, histo);
end

end