function imgLap = LaplacianFilter(img, sigma)
%
%
%       imgBlur = LaplacianFilter(img, sigma)
%
%
%       Input:
%           -img: the input image
%
%       Output:
%           -imgLap: a filtered image
%
%
%     Copyright (C) 2011-16  Francesco Banterle
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

H = LaplacianKernel(sigma);

imgLap = imfilter(img, H, 'replicate');

end
