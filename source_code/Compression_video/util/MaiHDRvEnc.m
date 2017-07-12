function MaiHDRvEnc(hdrv, name, hdrv_profile, hdrv_quality)
%
%
%       MaiHDRvEnc(hdrv, name, hdrv_profile, hdrv_quality)
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
%     Copyright (C) 2013-14  Francesco Banterle
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
%     "Optimizing a Tone Curve for Backward-Compatible High Dynamic Range Image and Video Compression"
% 	  by Chul Zicong Mai, Hassan Mansour, Rafal Mantiuk, Panos Nasiopoulos,
%     Rabab Ward, and Wolfgang Heidrich
%     in IEEE TRANSACTIONS ON IMAGE PROCESSING, VOL. 20, NO. 6, JUNE 2011
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

if(strcmp(hdrv_profile, 'MPEG-4') == 0)
    disp('Note that the H.264 profile needs to be used for fair comparisons!');
end

nameOut = RemoveExt(name);
fileExt = fileExtension(name);
nameTMO = [nameOut, '_MAI11_tmo.', fileExt];
nameResiduals = [nameOut, '_MAI11_residuals.', fileExt];

%Opening hdr stream
hdrv = hdrvopen(hdrv, 'r');

%Tone mapping pass
writerObj = VideoWriter(nameTMO, hdrv_profile);
writerObj.Quality = hdrv_quality;
open(writerObj);

tone_function = [];

for i=1:hdrv.totalFrames
    disp(['Processing frame ',num2str(i)]);
    
    %HDR frame
    [frame, hdrv] = hdrvGetFrame(hdrv, i);   
    
    [frameTMO, l, v] = MaiFrameEnc(frame);
    
    writeVideo(writerObj, ClampImg(frameTMO,0,1));
    tone_function = [tone_function, struct('l', l, 'v', v)];  
    
end
close(writerObj);

%video Residuals pass
readerObj = VideoReader(nameTMO);

writerObj_residuals = VideoWriter(nameResiduals, hdrv_profile);
writerObj_residuals.Quality = hdrv_quality;
open(writerObj_residuals);

r_min = zeros(1,hdrv.totalFrames);
r_max = zeros(1,hdrv.totalFrames);

for i=1:hdrv.totalFrames
    disp(['Processing frame ',num2str(i)]);
    
    %HDR frame
    [frame, hdrv] = hdrvGetFrame(hdrv, i);
    h = lum(frame);
    
    %Tone mapped frame
    frameTMO = double(read(readerObj, i))/255;
    L = lum(frameTMO);    
    lr = 10.^interp1(tone_function(i).v, tone_function(i).l, L, 'linear'); 
    %Residuals
    r = RemoveSpecials(log(h./(lr+0.05)));
    
    %Normalize in [0,1]
    r_min(i) = min(r(:));
    r_max(i) = max(r(:));    
    r = (r - r_min(i)) / (r_max(i) - r_min(i));
    
    %writing residuals
    writeVideo(writerObj_residuals, r);
end

close(writerObj_residuals);

save([nameOut, '_MAI11_info.mat'], 'tone_function', 'r_min', 'r_max');

hdrvclose(hdrv);

end
