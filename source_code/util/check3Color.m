function check3Color(img)
%
%
%        check3Color(img)
%
%
%        Input:
%           -img: an image to be tested if it is a three color channels
%           image
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

%is a three color channels image?
if(size(img, 3) ~= 3)
    error('The image has to be a three color channels image.');
end

end