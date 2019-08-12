function value = VarianceRegion(img, xMin, xMax, yMin, yMax)
%
%
%        value = VarianceRegion(img, xMin, xMax, yMin, yMax)
%
%        Input:
%           -img: an image
%           -(xMin,xMax,yMin,yMax): the bounding box of a region in img
%
%        Output:
%           -value: the variance in the image
%
%     Copyright (C) 2014 Francesco Banterle
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

%computing the centroid of the region
[X,Y] = meshgrid(xMin:xMax,yMin:yMax);
tmpImg = img(yMin:yMax, xMin:xMax,:);

totImg = sum(tmpImg(:));

x_light = tmpImg.*X;
x_light = sum(x_light(:))/totImg;
    
y_light = tmpImg.*Y;
y_light = sum(y_light(:))/totImg;

%computing variance
d_p_squared = (X-x_light).^2 + (Y-y_light).^2;

value = tmpImg.*d_p_squared;
value = sqrt(sum(value(:)));

end