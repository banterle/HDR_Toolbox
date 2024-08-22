function FalseColorTMOv(hdrv, filenameOutput, FC_compress, FC_LRange, tmo_quality, tmo_video_profile)
%
%
%      FalseColorTMOv(hdrv, filenameOutput, tmo_alpha, tmo_white, tmo_gamma, tmo_quality, tmo_video_profile)
%
%
%       Input:
%           -hdrv: a HDR video structure; use hdrvread to create a hdrv
%           structure
%           -filenameOutput: output filename (if it has an image extension,
%           single files will be generated)
%           -FC_compress:
%           -FC_LRange: 
%           -tmo_quality: the output quality in [1,100]. 100 is the best quality
%           1 is the lowest quality.%
%           -tmo_video_profile: the compression profile (encoder) for compressing the stream.
%           Please have a look to the profile of VideoWriter from the MATLAB
%           help. Depending on the version of MATLAB some profiles may be not
%           be present.
%
%     Copyright (C) 2013-15 Francesco Banterle
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
%     "Real-time Automated Tone Mapping System for HDR Video"
% 	  by Chris Kiser, Erik Reinhard, Mike Tocci and Nora Tocci
%     in IEEE International Conference on Image Processing, 2012 
%
%

if(~exist('FC_compress', 'var'))
    FC_compress = 'log10';
end

if(~exist('FC_LRange', 'var'))
    FC_LRange = [0, 64.0];
end

if(~exist('tmo_quality', 'var'))
    tmo_quality = 95;
end

if(~exist('tmo_video_profile', 'var'))
    tmo_video_profile = 'MPEG-4';
end

name = RemoveExt(filenameOutput);
ext  = fileExtension(filenameOutput);

bVideo = 0;
writerObj = 0;

if(strcmp(ext, 'avi') == 1 || strcmp(ext, 'mp4') == 1)
    bVideo = 1;
    writerObj = VideoWriter(filenameOutput, tmo_video_profile);
    writerObj.FrameRate = hdrv.FrameRate;
    writerObj.Quality = tmo_quality;
    open(writerObj);
end

hdrv = hdrvopen(hdrv);

disp('False Color...');

for i=1:hdrv.totalFrames
    disp(['Processing frame ', num2str(i)]);
    [frame, hdrv] = hdrvGetFrame(hdrv, i);
        
    %only physical values allowed from this point
    frame = RemoveSpecials(frame);
    frame(frame < 0) = 0;
     
    %compute statistics for the current frame
    frameOut = FalseColor(frame, FC_compress, 0, FC_LRange);
            
    if(bVideo)
        writeVideo(writerObj, frameOut);
    else
        imwrite(frameOut, [name, sprintf('%.10d',i), '.', ext]);
    end
end

disp('OK');

if(bVideo)
    close(writerObj);
end

hdrvclose(hdrv);

end