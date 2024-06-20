function [L_h, L_ha] = RamseyTMOv(hdrv, filenameOutput, tmo_alpha, tmo_white, tmo_gamma, tmo_quality, tmo_video_profile)
%
%
%      [L_h, L_ha] = RamseyTMOv(hdrv, filenameOutput, tmo_alpha, tmo_white, tmo_quality, tmo_video_profile)
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
%     Copyright (C) 2013-17 Francesco Banterle
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
%     "Adaptive Temporal Tone Mapping"
% 	  by Shaun David Ramsey, J. Thomas Johnson III, Charles Hansen
%     in CGIM 2004 
%
%

if(~exist('tmo_alpha', 'var'))
    tmo_alpha = 0.18;
end

if(~exist('tmo_white', 'var'))
    tmo_white = -1;
end

if(tmo_white < 0.0)
    tmo_white = 1e10;
end

if(~exist('tmo_gamma', 'var'))
    tmo_gamma = -1.0;
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

%compute statistics
[hdrv, stats_v, ~] = hdrvAnalysis(hdrv, 0.99, [], 0);

hdrv = hdrvopen(hdrv);

L_h = stats_v(:, 6);

disp('Tone Mapping...');
for i=1:hdrv.totalFrames
    disp(['Processing frame ', num2str(i)]);
                
    %compute number of frames for smoothing
    minLhi = L_h(i) * 0.9;
    maxLhi = L_h(i) * 1.1;
    j = i;
    while((j > 1) && ((i - j) < 60))
        if((L_h(j) > minLhi) && (L_h(j) < maxLhi))
            j = j - 1;
        else
            if((i - j) < 4)
                j = j - 1;
            else
                break;
            end
        end
    end
    
    %compute L_ha
    L_ha = 0.0;
    for k=i:-1:j
        L_ha = L_ha + log(L_h(k));
    end
    L_ha = exp(L_ha / (i - j + 1));   
    
    %fetch the i-th frame
    [frame, hdrv] = hdrvGetFrame(hdrv, i);

    %only physical values
    frame = RemoveSpecials(frame);
    frame(frame < 0) = 0;   
    
    %tone map the current frame
    frameOut = ReinhardTMO(frame, tmo_alpha, tmo_white, 'global', -1, L_ha);
        
    %gamma/sRGB encoding
    if(bsRGB)
        frameOut = ConvertRGBtosRGB(frameOut, 0);
    else
        frameOut = GammaTMO(frameOut, tmo_gamma, 0, 0);
    end
    
    frameOut = ClampImg(frameOut, 0.0, 1.0);
    
    if(bVideo)
        writeVideo(writerObj, frameOut);
    else
        nameOut = [name, sprintf('%.10d',i), '.', ext];
        imwrite(frameOut, nameOut);
    end
end

disp('OK');

if(bVideo)
    close(writerObj);
end

hdrvclose(hdrv);

end
