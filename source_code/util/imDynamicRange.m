function [dr, dr_log] = imDynamicRange(img, bRobust)
%
%
%        [dr, dr_log] = imDynamicRange(img, bRobust)
%
%
%        Input:
%           -img: the input image
%           -bRobust: if bRobust > 0 --> robust statistics for min and max 
%                     luminance values. bRboust becomes the percentile!
%
%        Output:
%           -dr: dynamic range of img
%           -dr_log: dynamic range of img in log10 space space
%
%     Copyright (C) 2011-18  Francesco Banterle
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

if(~exisst('bRobust', 'var'))
    bRobust = 0;
end

if(bRobust >= 0.5)
   bRobust = 0.01; 
end

L = lum(img);

if(bRobust > 0.0)
    minL = MaxQuart(L, bRobust);
    maxL = MaxQuart(L, 1 - bRobust);
else
    minL = min(L(:));
    maxL = max(L(:));
end

if(minL < 1-e6)
    warning('imDynamicRange: minL is less than 1e-6');
end

dr = maxL / minL;

dr_log = log10(maxL + 1e-6) / log10(minL + 1e-6);

end