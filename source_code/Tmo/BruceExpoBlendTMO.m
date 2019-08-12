function imgOut = BruceExpoBlendTMO(img, imageStack, beb_R, beb_beta)
%
%
%        imgOut = BruceExpoBlendTMO(img, imageStack, beb_R, beb_beta)
%
%
%        Input:
%           -img: input HDR image
%           -imageStack: an exposure stack of LDR images (use ReadLDRStack.m)
%           -beb_R: radius in pixels for computing entropy, R parameter
%           from the original paper
%           -beb_beta: beta parameter from the original paper
%
%        Output:
%           -imgOut: tone mapped image
%
%        Note: Gamma correction is not needed because it works on gamma
%        corrected images.
% 
%     Copyright (C) 2013-15  Francesco Banterle
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
%     "ExpoBlend: Information preserving exposure blending based on
%                 normalized log-domain entropy"
% 	  by Neil D. B. Bruce
%     in Elsevier Computer&Graphics, 2013
%

%imageStack generation
if(~exist('imageStack', 'var'))
    imageStack = [];
end

if(~exist('beb_beta', 'var'))
    beb_beta = 6;
end

if(~exist('beb_R', 'var'))
    beb_R = 29;
end

if(~isempty(img))
    %convert the HDR image into a imageStack
    checkNegative(img);

    [imageStack, ~] = CreateLDRStackFromHDR(img, 1);
else
    if(isa(imageStack, 'single'))
        imageStack = doubel(imageStack);
    end

    if(isa(imageStack, 'uint8'))
        imageStack = single(imageStack) / 255.0;
    end

    if(isa(imageStack, 'uint16'))
        imageStack = single(imageStack) / 655535.0;
    end
end


%number of images in the imageStack
[r, c, col, n] = size(imageStack);

H_local = zeros(r, c, n);
totalE1 = zeros(r, c);

kernel = zeros(beb_R * 2 + 1);
[X,Y] = meshgrid(1:(beb_R * 2 + 1), 1:(beb_R * 2 + 1));
kernel((((X - beb_R - 1).^2 + (Y - beb_R - 1).^2) <= (beb_R.^2))) = 1;

for i=1:n   
    logI = log(imageStack(:,:,:,i) + 1);
    H_local(:,:,i) = entropyfilt(lum(logI), kernel);
    totalE1 = totalE1 + H_local(:,:,i);
end

totalE2 = zeros(r, c);
for i=1:n
    H_norm = H_local(:,:,i) ./ totalE1;
    H_local(:,:,i) = exp(beb_beta * H_norm);
    totalE2 = totalE2 + H_local(:,:,i);
end

imgOut = zeros(r, c, col);
for i=1:n    
    H_norm = H_local(:,:,i) ./ totalE2;
    logI   = log(1 + imageStack(:,:,:,i));
    
    for j=1:col
        logI(:,:,j) = logI(:,:,j) .* H_norm;
    end
    
    imgOut = imgOut + logI;
end

imgOut = exp(imgOut); 
maxL = max(imgOut(:));
minL = min(imgOut(:));
imgOut = (imgOut - minL) / (maxL - minL);

disp('This algorithm outputs images with gamma encoding. Inverse gamma is not required to be applied!');
end