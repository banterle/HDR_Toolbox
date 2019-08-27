function n = imNumPixels(img)
%
%
%       n = imNumPixels(img)
%
%       This function computes image key.
%
%       Input:
%           -img: an image
%
%       Output:
%           -n: the numer of pixel in img
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

n = size(img, 1) * size(img, 2);

end

