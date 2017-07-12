function imgOut = RemoveNuked(img)
%
%
%        imgOut = RemoveNuked(img)
%
%
%        Description: this function removes nuked pixels from an image
%
%        Input:
%           -img: an input image
%
%        Output:
%           -imgOut: an image without nuked pixels
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

imgOut = img;

mask = [0 1 0; 1 0 1; 0 1 0] / 4;

img_mean = imfilter(img, mask);

imgOut(imgOut > 1e1) = img_mean(imgOut > 1e1);

end