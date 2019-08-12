function [imgOut, hdr_info] = read_rgbe(filename)
%
%       [imgOut, hdr_info] = read_rgbe(filename)
%
%        Input:
%           -filename: the name of the file to open
%
%        Output:
%           -imgOut: a float image
%           -hdr_info: RGBE format extra datum such as: exposure, gamma, etc.
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

imgOut = 0;

fid = fopen(filename,'r');

%is it a RGBE file?
while(~feof(fid))
    line = fgetl(fid);
    if(contains(line,'#?'))
        break;
    end
end

if(feof(fid))
    fclose(fid);
    return; 
end

line = fgetl(fid);
RLE = 0;
exposure = 1.0;
gamma = 1.0;

while(~isempty(line))
    %Properties of the RGBE image:
    
    %Compression format
	if(~isempty(strfind(line, 'FORMAT=')))
       if(~isempty(strfind(line, '32-bit_rle_rgbe')))
           RLE = 1;
       end
    end
    
    %Gamma
    lst = strfind(line,'GAMMA=');
	if(~isempty(lst))
        gamma = str2double(line((lst(1)+7):end));
    end    
    
    %Exposure
    lst = strfind(line,'EXPOSURE=');
	if(~isempty(lst))
        exposure = str2double(line((lst(1)+9):end));
    end
    line = fgetl(fid);
end

%read the height and the width of the image
[len, count] = fscanf(fid,'-Y %d +X %d',2);
line = fgetl(fid);
%[retChar, count] = fread(fid,1,'uint8');

%read pixels...
[tmpImg, count] = fread(fid,inf,'uint8');

height = len(1);
width  = len(2);

%uncompressed?
if(~RLE||(count==(width * height * 4)))
    tmpImg2 = zeros(width, height, 4);
    for i=1:4
        tmpImg2(:,:,i) = reshape(tmpImg(i:4:(width*height*4)),width,height);
    end
    
    %from RGBE to Float
    tmpImg = RGBE2float(tmpImg2);   
    imgOut = zeros(height,width,3);
    for i=1:3
        imgOut(:,:,i) = tmpImg(:,:,i)';   
    end    
else
    %RLE decompression...
    imgRGBE = zeros(height,width,4);

    buffer = [];

    c = 5;
    %decompression of each line
    for i=1:height
        %decompression of each RGBE channel
        for j=1:4 
            k = 1;            
            %decompression of a single channel line
            while(k <= width)
                num = tmpImg(c);
                if(num > 128)
                    num = num - 128;                   
                    buffer(k:(k + num - 1),j) = tmpImg(c + 1);

                    c = c + 2;
                    k = k + num;
                else
                    buffer(k:(k + num - 1),j) = tmpImg((c + 1):(c + num));
                    
                    c = c + num + 1;
                    k = k + num;
                end
            end
        end
        c = c + 4;
        imgRGBE(i,:,:) = reshape(buffer, 1, width, 4);
    end
    %from RGBE to Float
    imgOut = RGBE2float(imgRGBE);
end
fclose(fid);

hdr_info = struct('exposure', exposure, 'gamma', gamma);

end