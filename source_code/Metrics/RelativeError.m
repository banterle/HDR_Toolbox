function re = RelativeError(img_ref, img_dist)
%
%
%      re = RelativeError(img_ref, img_dist)
%
%       the relative error between two images
%
%       Input:
%           -img_ref: input reference image
%           -img_dist: input distorted image
%
%       Output:
%           -re: the relative error between img_ref and img_dist
% 
%     Copyright (C) 2014  Francesco Banterle
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

[img_ref, img_dist, ~] = checkDomains(img_ref, img_dist);

checkNegative(img_ref);
checkNegative(img_dist);

delta = abs(img_ref - img_dist);

relErr = delta ./ img_ref;

indx = find(img_ref > 0);

if(~isempty(indx))
    re = mean(relErr(indx));
else
    error('all values in img_ref are 0! This function cannot be applied.');
end

end