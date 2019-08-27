function [eMin, eMax] = getFstops(img, img_percentile)
%
%
%        [eMin, eMax] = getFstops(img, img_percentile)
%
%
%        Input:
%           -img: the input image
%           -img_percentile: a percentile value for robust statistics
%
%        Output:
%           -eMin: the minimum f-stop
%           -eMax: the maximum f-stop
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

if(~exist('img_percentile', 'var'))
    img_percentile = 0.001;
end

if(img_percentile < 0.0)
    img_percentile = 0.001;
end

if(img_percentile > 1.0)
    img_percentile = 0.001;
end

L = lum(img);

maxL = MaxQuart(L, 1.0 - img_percentile);
minL = MaxQuart(L, img_percentile);

eMin = round(log2(minL + 1e-6));
eMax = round(log2(maxL + 1e-6));

end