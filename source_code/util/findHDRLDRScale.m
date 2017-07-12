function scale = findHDRLDRScale(imgHDR, imgLDR)
%
%
%       scale = findHDRLDRScale(imgHDR, imgLDR)
%
%
%       Input:
%           -imgHDR: an HDR image
%           -imgLDR: an LDR image (in the linear domain)
%
%       Output:
%           -scale: the scaling factor
%
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

if(~isSameImage(imgHDR, imgLDR))
    error('The input images are different!');
end

low_threshold =  ( 32.0 / 255.0).^2.2;
high_threshold = (230.0 / 255.0).^2.2;

indx = find((imgLDR >= low_threshold) & (imgLDR <= high_threshold));

scale = (imgHDR(indx) ./ imgLDR(indx));
scale = mean(scale(:));

end
