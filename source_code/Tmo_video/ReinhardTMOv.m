function ReinhardTMOv(hdrv, filenameOutput, tmo_alpha, tmo_white, tmo_gamma, tmo_quality, tmo_video_profile)
%
%
%      ReinhardTMOv(hdrv, filenameOutput, tmo_alpha, tmo_white, tmo_gamma, tmo_quality, tmo_video_profile)
%
%
%       Input:
%           -hdrv: a HDR video structure; use hdrvread to create a hdrv
%           structure
%           -filenameOutput: output filename (if it has an image extension,
%           single files will be generated)
%           -tmo_alpha:
%           -tmo_white: 
%           -tmo_gamma: gamma for encoding the frame
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

if(~exist('tmo_alpha', 'var'))
    tmo_alpha = 0.5;
end

if(~exist('tmo_white', 'var'))
    tmo_white = 1e6;
end

if(~exist('tmo_gamma', 'var'))
    tmo_gamma = -2.2;
end

if(tmo_gamma < 0)
    bsRGB = 1;
else
    bsRGB = 0;
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

disp('Tone Mapping...');

beta = 0.5;

for i=1:hdrv.totalFrames
    disp(['Processing frame ', num2str(i)]);
    [frame, hdrv] = hdrvGetFrame(hdrv, i);
        
    %only physical values allowed from this point
    frame = RemoveSpecials(frame);
    frame(frame < 0) = 0;
     
    %compute statistics for the current frame
    L = lum(frame);
    Lav_cur = logMean(L);
   
    if(i == 1)
        Lav_prev = Lav_cur;
    end

    Lav = Lav_prev * (1 - beta) + beta * Lav_cur;
    
    %tone mapping
    [frameOut, ~, ~] = ReinhardTMO(frame, tmo_alpha, tmo_white, 'global', -1, Lav);
    
    %Gamma/sRGB encoding
    if(bsRGB)
        frameOut = ConvertRGBtosRGB(frameOut, 0);
    else
        frameOut = GammaTMO(frameOut, tmo_gamma, 0, 0);
    end
    
    frameOut = ClampImg(frameOut, 0.0, 1.0);
        
    if(bVideo)
        writeVideo(writerObj, frameOut);
    else
        imwrite(frameOut, [name, sprintf('%.10d',i), '.', ext]);
    end
    
    %update for the next frame
    Lav_prev = Lav;
end

disp('OK');

if(bVideo)
    close(writerObj);
end

hdrvclose(hdrv);

end
