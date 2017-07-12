function ret = hdrimwrite(img, filename, hdr_info)
%
%       ret = hdrimwrite(img, filename, hdr_info)
%
%
%        Input:
%           -img: the image to write on the hard disk.
%           -filename: the name of the image to write.
%	    -hdr_info: a MATLAB struct with datum for writing:
%		-RGBE: exposure (exposure), RLE compression enable (bRLE),
%		and gamma (gamma). Note that gamma and exposure have to be
%		applied by the user before writing the file.
%		-HDR JPEG2000: the compression ratio (compression_ratio).
%
%        Output:
%           -ret: a boolean value, it is set to 1 if the write succeed, 0 otherwise.
%
%     Copyright (C) 2011-2013  Francesco Banterle
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

%if it is a gray image we create three channels
col = size(img, 3);

if(isempty(img))
    error('Empty images cannot be written!');
end

if(~exist('filename', 'var'))
    error('A filename with extension needs to be passed as input!');
end

if(col == 1)
    [r, c] = size(img);
    imgOut = zeros(r, c, 3);
    
    for i=1:3
        imgOut(:,:,i) = img;
    end
    
    img = imgOut;
end

ret = 0;

if(~exist('hdr_info', 'var'))
    hdr_info = struct('exposure', 1.0, 'gamma', 1.0, 'compression_ratio', 2.0);
end

extension = lower(fileExtension(filename));

if(strcmpi(extension,'pic') == 1)
    extension = 'hdr';
end

switch extension
    
    %PIC-HDR format by Greg Ward (.hdr)
    case 'hdr'
        try
            write_rgbe(img, filename, hdr_info);
        catch
            error('This PIC/HDR file can not be written.');
        end

    %OpenEXR support using TinyEXR
    case 'exr'
        try
            if(~isa(img, 'double'))
                disp('Warning: This image is not a double, automatic cast to double for saving it as EXR.');
                img = double(img);
            end
            
            write_exr(img, filename);
        catch
            error('This EXR file can not be written.');
        end

    %Portable float map (.pfm)
    case 'pfm'
        try
            write_pfm(img, filename);
        catch
            error('This PFM file can not be written.');
        end
        
    %HDR JPEG2000 (.jp2)
    case 'jp2'
         try
            if(~exist('hdr_info.compression_ratio', 'var'))
                HDRJPEG2000Enc(img, filename, 2.0);
            else
            	HDRJPEG2000Enc(img, filename, hdr_info.compression_ratio);
            end
         catch
             error('This HDR JPEG 2000 file can not be written.');
         end        
        
    otherwise %try to save as LDR image
        try
            imwrite(ClampImg(img, 0, 1), filename);
        catch
            error('This format is not supported.');
        end
end

ret = 1;

end
