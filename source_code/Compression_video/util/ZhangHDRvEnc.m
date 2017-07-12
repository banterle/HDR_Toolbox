function ZhangHDRvEnc(hdrv, name, hdrv_profile, hdrv_quality)
%
%
%       ZhangHDRvEnc(hdrv, name, hdrv_profile, hdrv_quality)
%
%
%       Input:
%           -hdrv: a HDR video stream, use hdrvread for opening a stream
%           -name: this is the output name of the stream. For example,
%           'video_hdr.avi' or 'video_hdr.mp4'
%           -hdrv_profile: the compression profile (encoder) for compressing the stream.
%           Please have a look to the profile of VideoWriter from the MATLAB
%           help. Depending on the version of MATLAB some profiles may be not
%           be present.
%           -hdrv_quality: the output quality in [1,100]. 100 is the best quality
%           1 is the lowest quality.
%
%     Copyright (C) 2014  Francesco Banterle
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
%     The paper describing this technique is:
%     "HVS BASED HIGH DYNAMIC RANGE VIDEO COMPRESSION WITH OPTIMAL BIT-DEPTH TRANSFORMATION"
% 	  by Yang Zhang, Erik Reinhard, David Bull
%     in Proceedings of 2011 IEEE 18th International Conference on Image Processing
%
%

if(~exist('hdrv_quality', 'var'))
    hdrv_quality = 95;
end

if(hdrv_quality < 1)
    hdrv_quality = 95;
end

if(~exist('hdrv_profile', 'var'))
    hdrv_profile = 'Motion JPEG AVI';
end

if(strcmp(hdrv_profile,'MPEG-4') == 0)
    disp('Note that the H.264 profile needs to be used for fair comparisons!');
end

nameOut = RemoveExt(name);
fileExt = fileExtension(name);
nameLogLuv = [nameOut, '_ZRB11_LUV.', fileExt];

%number of bits is fixed due to limitation of MATLAB
n_bits = 8;

%Opening hdr stream
hdrv = hdrvopen(hdrv, 'r');

writerObj = VideoWriter(nameLogLuv, hdrv_profile);
writerObj.Quality = hdrv_quality;
open(writerObj);

table_y = zeros(hdrv.totalFrames, 2^n_bits);
a = zeros(1, hdrv.totalFrames);
b = zeros(1, hdrv.totalFrames);

for i=1:hdrv.totalFrames
    disp(['Processing frame ', num2str(i)]);
    
    %getting the HDR frame
    [frame, hdrv] = hdrvGetFrame(hdrv, i);

    %encoding it
    [frameOut, y] = ZhangFrameEnc(frame, n_bits);   
    table_y(i,:) = y;
    
    %writing the frame out
    writeVideo(writerObj, frameOut / 255.0);
end

close(writerObj);

save([nameOut,'_ZRB11_info.mat'], 'table_y');

hdrvclose(hdrv);

end
