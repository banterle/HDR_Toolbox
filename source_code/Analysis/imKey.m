function [key, Lav] = imKey(img, bRobust)
%
%
%       key = imKey(img)
%
%       This function computes image key.
%
%       Input:
%           -img: an image
%
%       Output:
%           -key: the image's key
%           -Lav: 
% 
%       This function segments an image into different dynamic range zones
%       based on their order of magnitude.
%
%     Copyright (C) 2016  Francesco Banterle
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

if(~exist('bRobust', 'var'))
    bRobust = 0.01;
end

%Calculate image statistics
L = lum(img);
Lav  = logMean(L);

if(bRobust > 0.0)
    index = find(L > 0.0);
    
    if ~isempty(index)
        minL = MaxQuart(L(index), bRobust);
        maxL = MaxQuart(L(index), 1 - bRobust);
    else
        minL = 1.0;
        maxL = 1.0;
    end
else
    minL = min(L(:));
    maxL = max(L(:));    
end

maxL = log(maxL);
minL = log(minL);
delta = maxL - minL;

if (delta > 0.0) && (~isnan(maxL)) && (~isnan(minL)) && (~isinf(maxL)) && (~isinf(minL))
    key = (log(Lav) - minL) / delta;
else
    key = -1.0;
end

end

