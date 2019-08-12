function img = FallOffEnvMap(img)
%
%
%        img = FallOffEnvMap(img)
%
%
%        Input:
%           -img: an environment map in the latitude-longitude mapping
%
%        Output:
%           -img: the corrected image adding the fall-off
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

[r, c, col] = size(img);

Y = FallOff(r, c);

for i=1:col
    img(:,:,i) = img(:,:,i) .* Y;
end

end