function [img1_rot, rot, err] = AlignLLPanoramas(img1, img2, bVisualization)
%
%
%     [img1_rot, rot, err] = AlignLLPanoramas(img1, img2, bVisualization)
%
%     This function finds the rotation around Y-axis in pixel for aligning
%     the panorma img1 (in longitude-latitude format) to the panorma
%     img2 (in longitude-latitude format).
%       
%     Note that img1 and img2 have to share the same Y-axis in order to
%     produce a meaningful result!
%
%
%     Input:
%       -img1: unaligned image
%       -img2: reference panorama for alignment
%       -bVisualization: if it set to 1 this will show the result of 
%                        minimization
%
%     Output:
%       -img1_rot: img1 rotated to be aligned to img2
%       -rot: rotation in pixel. Img1 needs to be shifted of rot pixels in
%             order to be aligned to img2. For the rotation use imShiftWrap.m
%       -err: matching error
%
%     Copyright (C) 2012-16  Francesco Banterle
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

if(~exist('bVisualization', 'var'))
    bVisualization = 0;
end

c = size(img1, 2);

%Calculate the descriptor
Lwa_ext = (logMean(lum(img1)) + logMean(lum(img2))) / 2.0;

img1_tmo = ReinhardTMO(img1, 0.15, 1e9, 'global', [], Lwa_ext);
img2_tmo = ReinhardTMO(img2, 0.15, 1e9, 'global', [], Lwa_ext);

line1 = LLDescriptor(img1_tmo, 1)';
line2 = LLDescriptor(img2_tmo, 1)';

%minimization of the rotation
rot = 0;
err = sum((line1 - line2).^2);

for i=1:(c - 1)
    line1 = circshift(line1, 1);
    tmpErr = sum((line1 - line2).^2);

    if(tmpErr < err)
        rot = i;
        err = tmpErr;
    end
end

%plotting the result
if(bVisualization)
    line1 = circshift(line1, rot);
    plot(1:c, line1, 1:c, line2);
end

img1_rot = imShiftWrap(img1, rot);

end