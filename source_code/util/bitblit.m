function imgOut = bitblit(img, sprite, sprite_xy, sprite_modulation, bNormalize)
%
%		 imgOut = bitblit(img, sprite, sprite_xy, sprite_modulation, bNormalize)
%
%		 Input:
%           -img: the input image where to copy a sprite.
%           -sprite: an image to be copied multiple times over img.
%			-sprite_xy: the (x,y) positions where to copy sprite.
%           -sprite_modulation: modulation values when copying sprite.
%
%		 Output:
%			-imgOut: the result of copying sprite multiple times on img.
%
%     Copyright (C) 2023  Francesco Banterle
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

if(~exist('sprite_modulation', 'var'))
    sprite_modulation = ones(size(sprite_xy, 1), 1);
end

if(~exist('bNormalize', 'var'))
    bNormalize = 0;
end

if isempty(img)
    error('Image is empty');
end

if size(img, 3) ~= size(sprite, 3)
    error('img and sprite have different color channels.');
end

counter = zeros(size(img,1), size(img, 2));
rS = size(sprite, 1);
cS = size(sprite, 2);

n = size(sprite_xy, 1);

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

[r, c, col] = size(img);
imgOut = img;

for i=1:n
    x = sprite_xy(i, 1);
    y = sprite_xy(i, 2);
    
    minX = max([x - ch, 1]);
    maxX = min([x + ch + dx, c]);

    minY = max([y - rh, 1]);
    maxY = min([y + rh + dy, r]);

    diff_x = abs((x - ch) - minX);
    diff_y = abs((y - rh) - minY);
    y_coord = (minY:maxY) - minY + 1 + diff_y;
    x_coord = (minX:maxX) - minX + 1 + diff_x;
    
    sprite_i = sprite_modulation(i) * sprite(y_coord, x_coord);
    %tmp = imgOut(minY:maxY, minX:maxX, :);
    %size(tmp)
    %size(sprite_i)
    
    imgOut(minY:maxY, minX:maxX, :) = imgOut(minY:maxY, minX:maxX, :) + sprite_i;
    
    counter(minY:maxY, minX:maxX,:) = counter(minY:maxY, minX:maxX,:) + 1;
end

%imshow(counter);

if bNormalize
    disp('Normalize');
    counter(counter < 1.0) = 1.0;
    imgOut = imgOut ./ counter;
end

end
