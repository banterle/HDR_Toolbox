function [imgOut, color_wb, pos_wb] = imWhiteBalance(img, color_wb)
%
%     [imgOut, color_wb, pos_wb] = imWhiteBalance(img, color_wb)
%
%     This functions crops an HDR image.
%
%     Input:
%       -img: an input image that is linearized
%       -color_wb: color for applying the white balance
%       -pos_wb: position where to compute white balance color
%
%     Output:
%       -imgOut: an output image
%
%
%     Copyright (C) 2016-17 Francesco Banterle
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
pos_wb = [];

if(~exist('color_wb', 'var'))
    color_wb = [];
end

if(isempty(color_wb))
    patchSize = 8;
    
    hf = figure(4001);
    imshow(img);
    [x,y,button] = ginput(1);
    color_wb = mean(mean(img( (y - patchSize):(y + patchSize), (x - patchSize):(x + patchSize), :)));
    pos_wb = [x y];    
    close(hf);
end

scale = mean(color_wb);
scale_wb = scale ./ color_wb;

imgOut = zeros(size(img));
for i=1:size(img,3)
    imgOut(:,:,i) = img(:,:,i) * scale_wb(i);
end

end
