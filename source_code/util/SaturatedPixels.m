function imgOut = SaturatedPixels(img, t_min, t_max)
%
%
%        imgOut = SaturatedPixels(img, t_min, t_max)
%
%
%        Input:
%           -img: input image with saturated pixels
%           -t_min: low level for under-exposed values
%           -t_max: high level for over-exposed values
%
%        Output:
%           -imgOut: a mask with1 over-exposed and under-exposed pixels
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

imgOut = ones(size(img));
imgOut(img < t_min) = 0;
imgOut(img > t_max) = 0;

end