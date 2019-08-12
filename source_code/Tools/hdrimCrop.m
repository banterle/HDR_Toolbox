function [imgOut, rect] = hdrimCrop(img)
%
%     [imgOut, rect] = hdrimCrop(img)
%
%     This functions crops an HDR image.
%
%     Input:
%       -img: input image to be cropped.
%
%     Output:
%       -imgOut: a cropped HDR image.
%       -rect: the cropping rectangle
%
%
%     Copyright (C) 2015  Francesco Banterle
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

img_tmo = ReinhardTMO(img);
img_tmo = GammaTMO(img_tmo, 2.2);

[~, rect] = imcrop(img_tmo);

imgOut = imcrop(img, rect);

end
