function imgOut = imShift(img, shift_vector, bFill)
%
%		 imgOut = imShift(img, shift_vector, bFill)
%
%
%		 Input:
%           -img: an input image to be shifted
%           -shift_vector: a 2D shift vector;  amount (in pixels)
%           -bFill: filling value
%
%		 Output:
%			-imgOut: the final shifted image
%
%     Copyright (C) 2012-21  Francesco Banterle
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

if(~exist('bFill', 'var'))
    bFill = 0;
end

is_dx = shift_vector(1);
is_dy = shift_vector(2);

imgOut = zeros(size(img));
img_tmp = zeros(size(img));

[r,c,col] = size(img);

if(abs(is_dx) > 0)
    if(is_dx > 0)
        img = padarray(img, [0, is_dx], 'replicate', 'pre'); 
        img_tmp(:,1:end,:) = img(:,1:c,:);    
        %img_tmp(:,(is_dx + 1):end,:) = img(:,1:(end - is_dx),:);
    else
        img = padarray(img, [0, -is_dx], 'replicate', 'post');   
        img_tmp(:,1:end,:) = img(:,(1 - is_dx):(c - is_dx),:);    
        %img_tmp(:,1:(end + is_dx),:) = img(:,(1 - is_dx):end,:);  
    end
else
    img_tmp = img;
end

if(abs(is_dy) > 0)
    
    if(is_dy > 0)
        img_tmp = padarray(img_tmp, [is_dy, 0], 'replicate', 'pre'); 
        imgOut(1:end,:,:) = img_tmp(1:r,:,:);
        %imgOut((is_dy + 1):end,:,:) = img_tmp(1:(end - is_dy),:,:);
    else
        img_tmp = padarray(img_tmp, [-is_dy, 0], 'replicate', 'post'); 
        imgOut(1:end,:,:) = img_tmp((1 - is_dy):(r - is_dy),:,:); 
        %imgOut(1:(end + is_dy),:,:) = img_tmp((1 - is_dy):end,:,:);    
    end
else
    imgOut = img_tmp;
end

end
