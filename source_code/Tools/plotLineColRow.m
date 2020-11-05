function plotLineColRow(img, bColRow, channel)
%
%
%        plotLineColRow(img, bColRow, channel)
%
%        This function plots columns/rows of a color channel of an image.
%
%        Input:
%           -img: an image.
%           -bColRow: 1 --> plot a Column
%                     0 --> plot a row
%           -channel: the number of the channel; if negative it plots img's
%           luminance.
%
%     Copyright (C) 2020  Francesco Banterle
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

[~, ~, col] = size(img);

if(channel > 0)
    slice = img(:, :, mod(channel, col) + 1);
else
    slice = lum(img);
end

figure(1);
imshow(img);
hold on;
[x, y] = ginput(1);
plot([x, y], 'r+');

figure(2);
if(bColRow)
   line = slice(:, round(x)); 
else
   line = slice(round(y), :);     
end

plot(line);

end
