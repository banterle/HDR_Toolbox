function imgRec = HDRJPEG2000Dec(name)
%
%
%       imgRec = HDRJPEG2000Dec(name)
%
%
%       Input:
%           -name: the prefix of the compressed HDR images using JPEG HDR
%
%       Output:
%           -imgRec: the reconstructed HDR image
%
%     Copyright (C) 2011-2015  Francesco Banterle
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

info = imfinfo(name); %read metadata
decoded = sscanf(cell2mat(info.Comments), '%g', 7);

nBit = decoded(end);
imgRec = double(imread(name)) / (2^nBit - 1);
for i=1:size(imgRec, 3)
    xMax = decoded((i - 1) * 2 + 1);
    xMin = decoded((i - 1) * 2 + 2);
    %range expansion
    imgRec(:,:,i) = exp(imgRec(:,:,i) * (xMax - xMin) + xMin) - 1e-6;
end

imgRec(imgRec < 0.0) = 0;

end