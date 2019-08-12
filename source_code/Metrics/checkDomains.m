function [img_ref, img_dist, domain, max_value] = checkDomains(img_ref, img_dist)
%
%
%      [img_ref, img_dist, domain] = checkDomains(img_ref, img_dist)
%
%       This function checks if images belong to the same domain or not
%
%       Input:
%           -img_ref: input reference image
%           -img_dist: input distorted image
%
%       Output:
%           -img_ref: input reference image (cast to double)
%           -img_dist: input distorted image (cast to double)
%           -domain: image domain
%           -max_value: maximum value of domain
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

if(isSameImage(img_ref, img_dist) == 0)
    error('The two images are different they can not be used or there are more than one channel.');
end

count = zeros(4, 1);
str{1} = 'uint8';
str{2} = 'uint16';
str{3} = 'single';
str{4} = 'double';

for i=1:length(str)
    
    if(isa(img_ref, str{i}))
        img_ref = double(img_ref);
        count(i) = count(i) + 1;
    end

    if(isa(img_dist, str{i}))
        img_dist = double(img_dist);
        count(i) = count(i) + 1;
    end
end

[value, index] = max(count);

if(value ~= 2)
    error('The two images have different domains.');
end

domain = str{index};

switch domain
    case 'uint8'
        max_value = 2^8 - 1;

    case 'uint16'
        max_value = 2^16 - 1;

    case 'single'
        max_value = max(img_ref(:));

    case 'double'
        max_value = max(img_ref(:));      
end

end