function ConvHDRvtoLDRv(hdrv, filenameOutput, fstops, ldrv_gamma, ldrv_quality, ldrv_video_profile)
%
%
%        ConvHDRvtoLDRv(hdrv, filenameOutput, fstops, ldrv_gamma, ldrv_quality, ldrv_video_profile)
%
%        
%
%        Input:
%           -hdrv:
%           -filenameOutput:
%           -fstops:
%           -ftops:
%           -ldrv_gamma:
%           -ldrv_quality:
%           -ldrv_video_profile:
%
%
%     Copyright (C) 2016  Francesco Banterle
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

if(~exist('ldrv_gamma', 'var'))
    ldrv_gamma = 2.2;
end

if(~exist('ldrv_quality', 'var'))
    ldrv_quality = 95;
end

if(~exist('ldrv_video_profile', 'var'))
    ldrv_video_profile = 'MPEG-4';
end

if(ldrv_gamma < 0)
    bsRGB = 1;
else
    bsRGB = 0;
end

if(isempty(fstops))
    errir('ConvHDRvtoLDRv: fstops cannot be empty!');
end

name = RemoveExt(filenameOutput);
ext = fileExtension(filenameOutput);

bVideo = 0;
writerObj = 0;

if(strcmp(ext, 'avi') == 1 | strcmp(ext, 'mp4') == 1)
    bVideo = 1;
    writerObj = VideoWriter(filenameOutput, ldrv_video_profile);
    writerObj.FrameRate = hdrv.FrameRate;
    writerObj.Quality = ldrv_quality;
    open(writerObj);
end

if(bVideo == 0)
    mkdir([name,'_img']);
end

hdrv = hdrvopen(hdrv, 'r');

n = length(fstops);

for i=1:hdrv.totalFrames
    disp(['Processing frame ', num2str(i)]);
    [frame, hdrv] = hdrvGetFrame(hdrv, i);
        
    frame(frame < 0) = 0;
       
    j = mod(i, n) + 1;
   
    frameOut = frame * 2^fstops(j);
    
    %Gamma/sRGB encoding
    if(bsRGB)
        frameOut = ClampImg(ConvertRGBtosRGB(frameOut, 0), 0, 1);
    else
        frameOut = ClampImg(GammaTMO(frameOut, ldrv_gamma, 0, 0), 0, 1);
    end
      
    %Storing 
    if(bVideo)
        writeVideo(writerObj, frameOut);
    else
        nameOut = [name, '_img/frame_', sprintf('%.10d',i), '.', ext];
        imwrite(frameOut, nameOut);

        nameOut = [name, '_img/frame_', sprintf('%.10d',i), '.exr'];
        hdrimwrite(frame, nameOut);
    end    
end

hdrvclose(hdrv);
    
end