function ldrv = ldrvread(filename)
%
%        ldrv = ldrvread(filename)
%
%
%        Input:
%           -filename: the name or the folder path of the LDR video to open
%
%        Output:
%           -ldrv: a LDR video structure
%
%     Copyright (C) 2013-2016  Francesco Banterle
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

if(isdir(filename))
    
    if(filename(end) == '/')
       filename(end) = []; 
    end
    
    %PNG?
    tmp_list = dir([filename, '/', '*.png']);
    type = 'TYPE_LDR_PNG';
    
    %JPEG?
    if(isempty(tmp_list))
        tmp_list = dir([filename, '/', '*.jpg']);
        
        if(isempty(tmp_list))
            tmp_list = dir([filename, '/', '*.jpeg']);
        end
        
        type = 'TYPE_LDR_JPEG';
    end
    
    %JPEG-2000?
    if(isempty(tmp_list))
        tmp_list = dir([filename, '/', '*.jp2']);
        
        if(isempty(tmp_list))
            type = 'TYPE_NONE';
        else
            type = 'TYPE_LDR_JPEG_2000';
        end
    end
    
    totalFrames = length(tmp_list);
    
    ldrv = struct('type', type, 'path', filename, 'list', tmp_list, ...
                  'totalFrames', totalFrames, 'FrameRate', 24, ...
                  'frameCounter', 1, 'streamOpen', 1, 'permission', 'r');
else
    stream = VideoReader(filename);
    ldrv = struct('type', 'TYPE_LDR_VIDEO', 'path', filename, ...
                  'totalFrames', stream.NumberOfFrames, 'FrameRate', ...
                  stream.FrameRate, 'frameCounter', 1, 'streamOpen', 1, ...
                  'stream', stream, 'permission', 'r');
end

end
