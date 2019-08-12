function img = GenerateLightMap(lights, width, height)
%
%
%        img = GenerateLightMap(lights, width, height)
%
%
%        Input:
%           -lights: a list of directional lights
%           -width: the width of the output image
%           -height: the height of the output image
%
%        Output:
%           -img: an HDR image with the point rendering of
%                 lights
%
%     Copyright (C) 2011  Francesco Banterle
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

if(isempty(lights))
    error('lights can not be empty');
end

if(~exist('width', 'var') || ~exist('height', 'var'))
    width  = 512;
    height = 256;
end

col = length(lights(1).col);

img = zeros(height, width, col);

for i=1:length(lights)
    YY = ClampImg(round(lights(i).y * height), 1, height);
    XX = ClampImg(round(lights(i).x * width),  1, width);
    
    if(isnan(XX) == 0)
        for j=1:col
            img(YY, XX, j) = lights(i).col(j);
        end
    end
end

end