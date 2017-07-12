function [imgOut, counter_map] = imSplat(r, c, imSprite, splat_pos, splat_power)
%
%		 [imgOut, counter_map] = imSplat(r, c, imSprite, splat_pos, splat_power)
%
%
%		 Input:
%           -r: the height of the output image
%           -c: the width of the output image
%			-imSprite: an input image to be splat
%           -splat_pos: splatting coordinates
%           -splat_power: the power of each splat (optional)
%
%		 Output:
%			-imgOut: the final image after splatting
%           -counter_map: a map for counting splats per pixel
%
%     Copyright (C) 2012-14  Francesco Banterle
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

col = size(splat_power, 2);

if(~exist('splat_power', 'var'))
    splat_power = ones(size(splat_pos, 2), col);
end

imgOut = zeros(r, c, col);
counter_map = zeros(r, c);

[rS, cS, ~] = size(imSprite);
imSprite_counting = ones(rS, cS);

n = size(splat_pos, 2);

if(mod(rS, 2) == 0)
    rh = round(rS / 2);
    dy = -1;
else
    rh = floor(rS / 2);    
    dy = 0;
end

if(mod(cS, 2) == 0)
    ch = round(cS / 2);
    dx = -1;
else
    ch = floor(cS / 2);        
    dx = 0;
end

for i=1:n
    x = splat_pos(1, i);
    y = splat_pos(2, i);
    
    minX = max([x - ch, 1]);
    maxX = min([x + ch + dx, c]);

    minY = max([y - rh, 1]);
    maxY = min([y + rh + dy, r]);

    diff_x = abs((x - ch) - minX);
    diff_y = abs((y - rh) - minY);
    y_coord = (minY:maxY) - minY + 1 + diff_y;
    x_coord = (minX:maxX) - minX + 1 + diff_x;
    
    for j=1:col
        imgOut(minY:maxY,minX:maxX,j) = imgOut(minY:maxY, minX:maxX, j) + ...
                                        splat_power(i, j) .* imSprite(y_coord, x_coord);
    end
    
    counter_map(minY:maxY, minX:maxX,:) = counter_map(minY:maxY, minX:maxX,:) + ...
                                          imSprite_counting(y_coord, x_coord,:);
end

counter_map(counter_map < 1.0) = 1.0;

end
