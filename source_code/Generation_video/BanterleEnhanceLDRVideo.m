function BanterleEnhanceLDRVideo(ldrv, hdri, filenameOutput, crf, scaleFactor)
%
%
%        BanterleEnhanceLDRVideo(ldrv, hdri, filenameOutput, crf, scaleFactor)
%
%
%        Input:
%           -ldrv:
%           -hdri:
%           -filenameOutput:
%           -crf:
%           -scaleFactor:
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

if(~exist('filenameOutput', 'var'))
    filenameOutput = 'output.exr';
end

%HDR Background
%1.5 CANON 550D;
%1.6 CANON 550D 2;
%3.6 WEBCAM LOW;
%3.1 WEBCAM HIGH 2;

ldrv = ldrvopen(ldrv, 'r');

%first frame
[img1, ldrv] = ldrvGetFrame(ldrv, 1);

if(~exist('crf', 'var'))
    crf = findHDRLDRCRF(hdri, img1);
end

img1 = tabledFunction(round(img1 * 255), crf);

%Number of frames
nameOutput = RemoveExt(filenameOutput);
ext = fileExtension(filenameOutput);

if(~exist('scaleFactor', 'var'))
    scaleFactor = findHDRLDRScale(hdri, img1);
end

if(scaleFactor > 0.0)
   hdri = hdri / scaleFactor;
else
    error('Scale factor is negative!');
end

for i=1:(ldrv.totalFrames - 1)
    disp(['Processing frame ', num2str(i)]);
    
    [img2, ldrv] = ldrvGetFrame(ldrv, i + 1);
    
    %linearization
    img2 = tabledFunction(img2, crf);
             
    imgHDR = BanterleEnhanceLDRFrame(img1, img2, hdri, 'linear');
    
    hdrimwrite(imgHDR, [nameOutput, '_', sprintf('%.10d', i), '.', ext]);
    
    %next frame
    img1 = img2;   
end

ldrclose(ldrv);

end