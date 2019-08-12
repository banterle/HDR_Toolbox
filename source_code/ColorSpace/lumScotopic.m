function V = lumScotopic(imgXYZ)
%
%       V = lumScotopic(imgXYZ)
%
%       This function calculates the scotopic luminance
%
%       input:
%           img: an XYZ image
%
%       output:
%           V: scotopic luminance approximation by Larson, Rushmeier and Piatko 1997
%
%     Copyright (C) 2011-14  Francesco Banterle
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

check3Color(imgXYZ);

eps = 1e-6;
t = (imgXYZ(:,:,2) + imgXYZ(:,:,3)) ./ (imgXYZ(:,:,1) + eps);
V = imgXYZ(:,:,2) .* (1.33 * (1.0 + t) - 1.68);

end
