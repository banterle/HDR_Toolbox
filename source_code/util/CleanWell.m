function imgOut = CleanWell(img, iter)
%
%
%       imgOut = CleanWell(img,iter)
%
%
%        Input:
%           -img: image to be filtered
%           -iter: number of iteration of the filter
%
%        Output:
%           -imgOut: image without single pixels
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
tmp = bwmorph(img, 'clean');
img = tmp;

for i=1:iter
    tmp=bwmorph(tmp, 'erode');
    tmp=bwmorph(tmp, 'clean');
end

for i=1:(iter + 2)
    tmp=bwmorph(tmp, 'dilate');
end

imgOut = tmp .* img;
imgOut = bwmorph(imgOut, 'clean');

end