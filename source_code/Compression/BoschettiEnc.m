function BoschettiEnc(img, name, bos_rateE, bos_rateRGB, nBit, tmo_operator)
%
%
%       BoschettiEnc(img, name, bos_rateE, bos_rateRGB, nBit)
%
%
%       Input:
%           -img: input HDR image
%           -name: is output name of the image. If img is empty
%                  an HDR image with filename 'name' is loaded
%           -bos_rateE: JPEG2000 compression rate for the E layer
%           -bos_rateRGB: JPEG2000 compression rate for the RGB layer
%           -nBit: number of bit of the encoding. The maximum is 16.
%           -tmo_operator: an handle to a tone mapping operator
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

if(~exist('name', 'var'))
    name = 'bosc_enc';
end

if(~exist('bos_rateRGB', 'var'))
    rateRGB = 15;
else
    rateRGB = bos_rateRGB;
end

if(~exist('bos_rateE', 'var'))
    rateE = 15;
else
    rateE = bos_rateE;
end

if(~exist('nBit','var'))
    nBit = 16;
end

if(~exist('tmo_operator','var'))
    tmo_operator = @ReinhardTMO;
end

%Tone mapping
imgTMO = tmo_operator(img);
%LDR Encoding
imgTMO = GammaTMO(imgTMO, 2.2, 0.0, 0);

%Quantization
maxVal = 2^nBit - 1;
imgTMO = round(imgTMO * maxVal) / maxVal;

%Computing E
epsilon = 1e-4;
epi = 1.0 / maxVal;
E = log2(img ./ (imgTMO + epi) + epsilon);
E = mean(E, 3);

%Encoding E
maxE = max(E(:));
minE = min(E(:));
Eq = (E - minE) / (maxE - minE);

%metadata string
metatadata = [num2str(nBit), ' ', num2str(maxE), ' ', num2str(minE)];

if(nBit == 16)
    Eq = uint16(Eq * maxVal);
end

imwrite(Eq,[name,'_bos_E.jp2'], 'Mode', 'lossy', 'CompressionRatio', rateE);

%Decoding E
EqDec = double(imread([name, '_bos_E.jp2'])) / maxVal;
EDec = EqDec * (maxE - minE) + minE;

%Computing RGB
RGB = zeros(size(img));
div = 2.^EDec;
for i=1:size(img, 3)
    RGB(:,:,i) = (img(:,:,i) ./ div);
end

%Encoding RGB
if(nBit == 16)
    RGB = uint16(RGB * maxVal);
end

nameOut = [name,'_bos_RGB.jp2'];
imwrite(RGB, nameOut, 'Mode', 'lossy', 'CompressionRatio', rateRGB, 'Comment', metatadata);
end