function [frame, hdrv] = hdrvGetFrame(hdrv, frameCounter)
%
%       [frame, hdrv] = hdrvGetFrame(hdrv, frameCounter)
%
%
%        Input:
%           -hdrv: a HDR video structure
%           -frameCounter: a frame to be read, if it is not defined the
%           current frame will be read.
%
%        Output:
%           -frame: the frame at frameCounter
%           -hdrv: the updated HDR video structure
%
%     Copyright (C) 2013-2017  Francesco Banterle
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

%which frame?
maxFrames = hdrv.totalFrames;

if(~exist('frameCounter', 'var'))
    frameCounter = hdrv.frameCounter;
else
    if(frameCounter < 1)
        frameCounter = 1;
    end
    
    if(frameCounter > maxFrames)
        frameCounter = maxFrames;
    end
end

%read the actual frame
switch hdrv.type
    case 'TYPE_HDR_PFM'
        frame = hdrimread([hdrv.path,'/',hdrv.list(frameCounter).name]);
   
    case 'TYPE_HDR_RGBE'
        frame = hdrimread([hdrv.path,'/',hdrv.list(frameCounter).name]);

    case 'TYPE_HDR_EXR'
        frame = hdrimread([hdrv.path,'/',hdrv.list(frameCounter).name]);
    
    case 'TYPE_HDR_JPEG_2000'
        frame = hdrimread([hdrv.path,'/',hdrv.list(frameCounter).name]);

    case 'TYPE_HDR_VIDEO'
        if(~isempty(hdrv.streamTMO))
            frameTMO = read(hdrv.streamTMO, frameCounter); 
        else
            frameTMO = [];
        end
        
        if(~isempty(hdrv.streamR))
            frameR   = read(hdrv.streamR, frameCounter);       
        else
            frameR = [];
        end
        
        frame = HDRvDecodeFrame(frameTMO, frameR, hdrv.info);        
end

%update the counter
hdrv.frameCounter = mod(frameCounter + 1, maxFrames + 1);

end