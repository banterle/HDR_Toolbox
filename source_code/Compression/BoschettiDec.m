function imgRec = BoschettiDec(name)
%
%
%       imgRec = BoschettiDec(name)
%
%       Input:
%           -name: the prefix of the compressed HDR images using Boschetti
%           et al. method.
%
%
%     Copyright (C) 2012  Francesco Banterle
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

%Read metadata
info = imfinfo([name, '_bos_RGB.jp2']);
decoded = sscanf(cell2mat(info.Comments), '%g', 3);
nBit = decoded(1);
maxE = decoded(2);
minE = decoded(3);

maxVal = 2^nBit - 1;

%Reading and Decoding Eq
EqDec = double(imread([name, '_bos_E.jp2'])) / maxVal;
EDec = EqDec * (maxE - minE) + minE;
mult = 2.^EDec;

%Decoding RGB
RGBDec = double(imread([name, '_bos_RGB.jp2'])) / maxVal;

%Reconstruction
imgRec = zeros(size(RGBDec));
for i=1:size(imgRec, 3)
    imgRec(:,:,i) = (RGBDec(:,:,i)) .* mult;
end

end