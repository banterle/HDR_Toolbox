function imgOut = imShift(img, shift_vector)
%
%		 imgOut = imShift(img, shift_vector)
%
%
%		 Input:
%           -img: an input image to be shifted
%           -shift_vector: a 2D shift vector;  amount (in pixels)
%
%		 Output:
%			-imgOut: the final shifted image
%
%     Copyright (C) 2012-15  Francesco Banterle
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

if(~exist('shift_vector', 'var'))
    warning('No valid shift vector');
    return;
end

is_dx = shift_vector(1);
is_dy = shift_vector(2);

imgOut = zeros(size(img));
img_tmp = zeros(size(img));

if(abs(is_dx) > 0)
    if(is_dx > 0)
        img_tmp(:,(is_dx + 1):end,:) = img(:,1:(end - is_dx),:);
    else
        img_tmp(:,1:(end + is_dx),:) = img(:,(1 - is_dx):end,:);    
    end
else
    img_tmp = img;
end

if(abs(is_dy) > 0)
    
    if(is_dy > 0)
        imgOut((is_dy + 1):end,:,:) = img_tmp(1:(end - is_dy),:,:);
    else
        imgOut(1:(end + is_dy),:,:) = img_tmp((1 - is_dy):end,:,:);    
    end
else
    imgOut = img_tmp;
end

end
