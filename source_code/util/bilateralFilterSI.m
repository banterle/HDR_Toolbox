function imgOut = bilateralFilterSI(img, imgEdges, sigma_s, sigma_r)
%
%		 imgOut = bilateralFilterSI(img, imgEdges, sigma_s, sigma_r)
%
%        This function implements a bilateral filter without
%        approximations. Note this function is very slow!
%
%		 Input:
%			-img: is an image to be filtered.
%           -imgEdges: is an edge image, where its edges will be transfered
%           to img. Note set this to [] if you do not want to transfer
%           edges.
%           -sigma_s: is the spatial sigma value. 
%           -sigma_r: is the range sigma value.
%
%		 Output:
%			-imgOut: is the filtered image.
%
%     Copyright (C) 2014-18  Francesco Banterle
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

output_class = class(img);

if ~isa(img, 'double')
    img = double(img);
end

if ~isa(imgEdges, 'double')
    imgEdges = double(imgEdges);
end

if ~isa(sigma_s, 'double')
    sigma_s = double(sigma_s);
end

if ~isa(sigma_r, 'double')
    sigma_r = double(sigma_r);
end

imgOut = bilateralFilterS(img, imgEdges, sigma_s, sigma_r);

if strcmp(output_class, class(imgOut)) == 0
    imgOut = cast(imgOut, output_class);
end

end
