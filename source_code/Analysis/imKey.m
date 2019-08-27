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
    maxL = MaxQuart(L, 1 - bRobust);
    minL = MaxQuart(L(L > 0), bRobust);
else
    maxL = max(L(:));
    minL = min(L(:));
end

key = (log(Lav) - log(minL)) / (log(maxL) - log(minL));

end

