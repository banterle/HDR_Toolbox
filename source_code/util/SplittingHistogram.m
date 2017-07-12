function pivot = SplittingHistogram(histo)
%
%
%        pivot = SplittingHistogram(histo)
%
%
%        Input:
%           -histo: an input histogram
%
%        Output:
%           -pivot: the pivot value for splitting the histogram in two
%           sub-histograms with similar sums:
%              MIN { sum(histo(1:pivot)) - sum(histo((pivot+1):end)) }
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

n     = length(histo);
pivot = n;
diff  = sum(histo) * 2;

for i=1:(n - 1)
    s0 = sum(histo(1:i));
    s1 = sum(histo((i + 1):end));
    tmpDiff = abs(s1 - s0);
    
    if(tmpDiff < diff)
        pivot = i;
        diff  = tmpDiff;
    end    
end