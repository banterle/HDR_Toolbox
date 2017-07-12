function [angle_rot, bCheck] = WardSimpleRot(img1, img2)
%
%
%       [angle_rot, bCheck] = WardSimpleRot(img1, img2)
%
%       This function computes the Ward's MTB.
%
%       Input:
%           -img1: the target image
%           -img2: the image that needs to be aligned to img1
%
%       Output:
%           -rot: rotation angle (degree) for aligning img2 into img1.
%
%     Copyright (C) 2013-15  Francesco Banterle. A big thank to Greg J. Ward
%     for help during the implementation.
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

[r, c, ~] = size(img1);

blocksY = 3;
blocksX = 4;
sizeY = round(r / blocksY);
sizeX = round(c / blocksX);

angle = [];

%Analyzing blocks
for i=1:blocksY
    rect  = [sizeY * (i - 1) + 1, sizeY * i, 1, sizeX];
    [tmpAngle, check] = WardSimpleRotAux(img1, img2, rect);
    if(check == 1)
        angle = [angle, tmpAngle];
    end
end

%Final Merging
if(isempty(angle))
    angle_rot = 0.0;
    bCheck = 0;
else
    rotThreshold = (0.07 * 180.0) / pi;
    npos = 0;
    nneg = 0;
    for i=1:length(angle)

        if(angle(i) >  rotThreshold)
            npos = npos + 1;
        end

        if(angle(i) < -rotThreshold)
            nneg = nneg + 1;
        end
    end

    if(bitand(nneg, npos))
        angle_rot = 0.0;
        bCheck = 0;
    else
        angle_rot = mean(angle);
        bCheck = 1;
    end
end

end