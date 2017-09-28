function info = read_raw_info(name)
%
%       info = read_raw_info(name)
%
%       This function extracts information from a RAW image file using
%       dcraw. Please download dcraw from: 
%               https://www.cybercom.net/~dcoffin/dcraw/
%
%        Input:
%           -name: the file name of an RAW image file.
%
%        Output:
%           -info: a structure with information from the camera.
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

%reading info from the raw file
[~, output] = dos(['dcraw -i -v ', name]);

if(contains(strfind(output, 'is not recognized as an internal')))
    error('ERROR: dcraw is not installed or not present in your path!');
end

%getting shutter speed
i0 = strfind(output, 'Shutter: ');
i1 = strfind(output, 'sec');
shutter_str = output((i0 + 8):(i1 - 1));
shutter_speed = str2num(shutter_str);

%getting ISO 
i0 = strfind(output, 'ISO speed: ');
tmp = output(i0:end);
tmp = strread(tmp, '%s', 'delimiter', '\n');
tmp = char(tmp(1));

iso_str = tmp(12:end);
iso = str2num(iso_str);

%getting Aperture 
i0 = strfind(output, 'Aperture: f/');
tmp = output(i0:end);
tmp = strread(tmp, '%s', 'delimiter', '\n');
tmp = char(tmp(1));

aperture_str = tmp(13:end);
aperture = str2num(aperture_str);

%getting Colors 
i0 = strfind(output, 'Raw colors: ');
tmp = output(i0:end);
tmp = strread(tmp, '%s', 'delimiter', '\n');
tmp = char(tmp(1));

colors_str = tmp(13:end);
colors = str2num(colors_str);

%getting focal length 
i0 = strfind(output, 'Focal length: ');
i1 = strfind(output, 'mm');
focal_length_str = output((i0 + 14):(i1 - 1));
focal_length = str2num(focal_length_str);

%getting image size
i0 = strfind(output, 'Image size: ');
tmp = output(i0:end);
tmp = strread(tmp, '%s', 'delimiter', '\n');
tmp = char(tmp(1));

i1 = strfind(tmp, 'x');
width_str = tmp(12:(i1 - 1));
height_str = tmp((i1 + 1):end);

width = str2num(width_str);
height = str2num(height_str);

info = struct('FNumber', aperture, 'ISOSpeedRatings', iso, 'FocalLength', focal_length, ...
              'ExposureTime', shutter_speed, 'Width', width, 'Height', height, 'NumberOfSamples', colors);

end