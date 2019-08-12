function stack = ReadRAWStack(dir_name, format, saturation_level)
%
%       stack = ReadRAWStack(dir_name, format, saturation_level)
%
%
%        Input:
%           -dir_name: the folder name where the stack is stored
%           -format: an LDR format for reading LDR images
%           -saturation_level: when the camera satures for RAW files. Note
%           that if saturation_level is a negative value, it will be
%           computed from the stack (this process may be slow).
%
%        Output:
%           -stack: a stack of exposure values from images in dir_name with
%           format
%
%     Copyright (C) 2015-16  Francesco Banterle
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

list = dir([dir_name, '/*.', format]);
n = length(list);

if(saturation_level < 0)
    saturation_level = 2^16 - 1;
    for i=1:n
        name = [dir_name, '/', list(i).name];
        saturation_level_i = getRAWSaturationLevel(name);
        saturation_level = min([saturation_level, saturation_level_i]);
    end
end

if(n > 0)
    info = read_raw_info([dir_name, '/', list(1).name]);
      
    stack = zeros(info.Height, info.Width, info.NumberOfSamples, n, 'single');

    for i=1:n
        name = [dir_name, '/', list(i).name];
        %read an image, and convert it into floating-point
        [img, ~, saturation_level] = read_raw(name, saturation_level);
        
        %store in the stack
        stack(:,:,:,i) =  single(img) / (2^16 - 1);    
    end
end

end