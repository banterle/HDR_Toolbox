function C = IPTColorfullness(imgIPT)
%
%       C = IPTColorfullness(imgIPT)
%
%       This computes the colorfullness in the IPT color space
%
%       input:
%         - imgIPT: an image in the IPT color space
%
%       output:
%         - C: colorfullness
%
%     Copyright (C) 2015  Francesco Banterle
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

check3Color(imgIPT);

C = sqrt(imgIPT(:,:,2).^2 + imgIPT(:,:,3).^2);

end