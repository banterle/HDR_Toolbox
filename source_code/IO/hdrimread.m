function [img, hdr_info] = hdrimread(filename)
%
%       [img, hdr_info] = hdrimread(filename)
%
%       This function reads from a file with name filename an HDR image, if
%       the format can not be opened, it tries to open it as it was an LDR
%       image using imread from MATLAB Image Processing Toolbox.
%
%       NOTE: JPEG2000 file passed as input are meant to be compressed
%       using HDR JPEG-2000. 
%
%        Input:
%           -filename: the name of the file to open
%
%        Output:
%           -img: the opened image
%           -hdr_info: RGBE format extra datum such as: exposure, gamma, etc.
%
%     Copyright (C) 2011-15  Francesco Banterle
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

if(~exist('filename', 'var'))
    error('A filename with extension needs to be passed as input!');
end

extension = lower(fileExtension(filename));

%Radiance format can have different extensions: .hdr, .rgbe and .pic
if((strcmpi(extension,'pic')==1) || (strcmpi(extension,'rgbe')==1))
    extension = 'hdr';
end

img = [];
hdr_info = [];
bLDR = 1;

switch extension
    
    %PIC-HDR format by Greg Ward
    case 'hdr'
        try
	    %HDR Toolbox's HDR Reader
            [img, hdr_info] = read_rgbe(filename);  
            bLDR = 0;
        catch err  
            try 
                %MATLAB HDR Reader
                img = double(hdrread(filename));
                bLDR = 0;
            catch err
                warning('This .hdr/.pic file cannot be read.');
            end
        end
        
    %OpenEXR support using TinyEXR
    case 'exr'
        try
            img = read_exr(filename);
            bLDR = 0;            
        catch err
            hdr_info = struct('loaded', 0);
            warning('This .exr file cannot be read.');
        end
        
    %Portable float map
    case 'pfm'
        try
            img = read_pfm(filename);
            bLDR = 0;            
        catch
            hdr_info = struct('loaded', 0);
            warning('This .pfm file cannot be read.');
        end
        
    %HDR JPEG-2000
    case 'jp2'
        try
            img = HDRJPEG2000Dec(filename);
            bLDR = 0;            
        catch err
            hdr_info = struct('loaded', 0);            
            warning('This .jpg2 file cannot be read as an HDR JPEG 2000 file.');
        end        
end

if(isempty(img))
    if(bLDR == 1)
        img = ldrimread(filename);
        if(isempty(img))
            hdr_info = struct('loaded', 0);                
            warning(['This image, ', filename,', cannot be loaded as an LDR image.']);
        else
            hdr_info = struct('loaded', 1);                
            warning(['This image, ', filename,', has been loaded as an LDR image.']);
        end
    else
        hdr_info = struct('loaded', 0);        
        error(['This image, ',filename,', cannot be loaded with LDR or HDR readers.']);
    end
else
    hdr_info.loaded = 1;
end

%Remove specials
img = RemoveSpecials(img);

end