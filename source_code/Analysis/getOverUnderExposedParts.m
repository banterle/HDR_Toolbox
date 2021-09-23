function [mask, pO, pU] = getOverUnderExposedParts(img, tue, toe)
%
%
%        mask = getOverUnderExposedParts(img)
%
%
%        Input:
%           -img: an 8-bit image with values in [0,1]
%           -tue: threshold for under exposed values; e.g., 0.05
%           -toe: threshold for over exposed values; e.g., 0.95
%
%        Output:
%   `       -mask: a mask with over-exposed pixels (1), and under-exposed
%            pixels (-1)
%           -pO: percentage of over-exposed pixels
%           -pU: percentage of under-exposed pixels
% 
%     Copyright (C) 2015-18  Francesco Banterle
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

if(~exist('toe', 'var'))
    toe = 248 / 255;
end

if(~exist('tue', 'var'))
    tue =   7 / 255;
end

[r, c, ~] = size(img);

over_exp = max(img, [], 3);
under_exp = min(img, [], 3);
    
mask = zeros(r, c);
mask(over_exp >= toe) = 1;
mask(under_exp <= tue) = -1;

nPixels = r * c;
pO = length(find(mask > 0.5))  / nPixels;
pU = length(find(mask < -0.5)) / nPixels;
    
end