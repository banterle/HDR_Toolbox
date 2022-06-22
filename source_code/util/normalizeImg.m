function [out, img_min, img_max] = normalizeImg(img, img_min, img_max)
%
%        [out, img_min, img_max] = normalizeImg(img, img_min, img_max)
%
%       
%        Simple TMO, which divides an image by the best exposure
%
%        Input:
%           -img: input HDR image
%           -img_min: the minimum of img
%           -img_max: the maximum of img
%
%        Output:
%           -out: the normalized image in [0,1]
%           -img_min: the minimum of img
%           -img_max: the maximum of img
% 
%     Copyright (C) 2010-22 Francesco Banterle
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

if(~exist('img_min', 'var'))
   img_min = MaxQuart(img, 0.01);
end

if(~exist('img_max', 'var'))
   img_max = MaxQuart(img, 0.999);
end

if img_min < 0.0
   img_min = min(img(:));
end

if img_max < 0.0
   img_max = max(img(:));
end

delta = img_max - img_min;

if(delta > 0.0)
    out = (img - img_min) / delta;
    out = ClampImg(out, 0.0, 1.0);
else
    out = img;
end

end
