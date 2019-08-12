function light = CreateLight(xMin, xMax, yMin, yMax, L, img)
%
%
%        light = CreateLight(xMin, xMax, yMin, yMax, L, img)
%
%
%        Input:
%           -(xMin,xMax,yMin,yMax): the bounding box of a region in img
%           -L: the luminance channel of img
%           -img: the full size image
%
%        Output:
%           -light: a directional light
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

tot  = (yMax - yMin + 1) * (xMax - xMin + 1);
tmpL = L(yMin:yMax, xMin:xMax);
totL = sum(tmpL(:));

if((tot > 0) && (totL > 0))
    %color value
    col = reshape(img(yMin:yMax, xMin:xMax,:), tot, 1, size(img, 3));
    value = sum(col, 1);    
    %position
    [r, c] = size(L);
    [X, Y] = meshgrid(xMin:xMax, yMin:yMax);   
    x_light = sum(sum(tmpL .* X)) / (totL * c);    
    y_light = sum(sum(tmpL .* Y)) / (totL * r);  
    %struct
    light = struct('col', value, 'x', x_light, 'y', y_light, ...
                   'x_bound', [xMin, xMax], 'y_bound', [yMin, yMax]);
else
    light = [];   
end

end