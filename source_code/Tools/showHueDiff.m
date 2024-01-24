function imgOut = showHueDiff(img_dst, img_ref)
%
%        imgOut = showHueDiff(img)
%
%        This shows the hue difference between two images.
%
%        Input:
%           -img1:
%           -img2:
%
%        Output:
%           -imgOut: hue difference 
%
%     Copyright (C) 2024 Francesco Banterle
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

[~, delta_hue] = distHue(img_dst, img_ref);

delta_hue = abs(delta_hue + pi);
delta_hue(delta_hue > pi) = pi - (delta_hue(delta_hue > pi) - pi);
delta_hue = pi - delta_hue;

imgOut = FalseColor(delta_hue, 'lin', 1, -1, pi, 'Delta Hue', 0, 'Delta Hue');

end
