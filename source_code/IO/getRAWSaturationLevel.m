function saturation_level = getRAWSaturationLevel(name)
%
%       saturation_level = getRAWSaturationLevel(name)
%
%       This function computes the saturation level of a RAW image file
%       using dcraw. Please download dcraw from: 
%               https://www.cybercom.net/~dcoffin/dcraw/
%
%        Input:
%           -name: the file name of an RAW image file
%
%        Output:
%           -saturation_level: the maximum saturation level
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

dos(['dcraw -v -D -T -4 ', name]);
name_we = RemoveExt(name);
img = imread([name_we, '.tiff']);
delete([name_we, '.tiff']);

saturation_min = 2^12;
[counts, x] = imhist(img, 2^16);

lap_counts = conv(counts, [-1 2 -1]);

peak = max(lap_counts(x > saturation_min));

index = find(lap_counts == peak);

saturation_level = max(index);

if(saturation_level < saturation_min)
    saturation_level = saturation_min;
end

end

