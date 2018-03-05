function [img, info, saturation_level] = read_raw(name, saturation_level)
%
%       [img, info, saturation_level] = read_raw(name, saturation_level)
%
%       This function develops a RAW image file using
%       dcraw. Please download dcraw from: 
%               https://www.cybercom.net/~dcoffin/dcraw/
%
%        Input:
%           -name: the file name of an RAW image file.
%           -saturation_level: the maximum saturation level; to avoid
%           magenta cast when developing the image.
%
%        Output:
%           -img: the developed RAW image.
%           -info: a structure with information from the camera.
%           -saturation_level: the maximum saturation level.
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

if(~exist('saturation_level', 'var'))
    saturation_level = 2^12 - 1;
end

try
    %reading the raw file    
    [~, output] = dos(['dcraw -6 -w -W -S ', num2str(saturation_level), ' -q 3 -g 1 1 -T ', name]);

    if(contains(output, 'is not recognized as an internal'))
        error('dcraw is not installed or not present in your path!');
    end    
    
    name_we = RemoveExt(name);
    img = imread([name_we, '.tiff']);
    delete([name_we, '.tiff']);
    
    info = read_raw_info(name);
    
catch expr
    disp(expr);
    
    img = [];
    info = [];
end

end