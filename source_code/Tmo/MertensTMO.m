function imgOut = MertensTMO(img, imageStack, weights, bWarning)
%
%
%        imgOut = MertensTMO(img, imageStack, weights, bWarning )
%
%        This function applies exposure fusion operator to an image or a
%        stack.
%
%        Input:
%           -img: input HDR image
%           -imageStack: an exposure stack of LDR images (use ReadLDRStack.m)
%           -weights: a three value vector:
%               -weights(1): the weight for the well exposedness in [0,1]. Well exposed
%                   pixels are taken more into account if the wE is near 1
%                   otherwise they are not taken into account.
%               -weights(2): the weight for the saturation in [0,1]. Saturated
%                   pixels are taken more into account if the wS is near 1
%                   otherwise they are not taken into account.
%               -weights(3): the weight for the contrast in [0,1]. Strong edgese are 
%                    taken more into account if the wE is near 1
%                    otherwise they are not taken into account.
%           -iterations: number of iterations for improving the movements'
%           -bWarning: a debugging flag to turn on/off the gamma
%           encoding notice.
%
%        Output:
%           -imgOut: tone mapped image
%
%        Note: Gamma correction is not needed because it works on gamma
%        corrected images.
% 
%     Copyright (C) 2010-2016 Francesco Banterle
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
%     "Exposure Fusion"
% 	  by Tom Mertens, Jan Kautz, Frank Van Reeth
%     in Proceedings of Pacific Graphics 2007
%

%default parameters if they are not present
if(~exist('weights', 'var'))
    weights = ones(1, 3);
end

wE = weights(1);
wS = weights(2);
wC = weights(3);

if(~exist('bWarning', 'var'))
    bWarning = 1;
end

%imageStack generation
if(~exist('imageStack', 'var'))
    imageStack = [];
end

if(~isempty(img)) %convert the HDR image into a imageStack
    checkNegative(img);
    [imageStack, ~] = CreateLDRStackFromHDR(img, 1);
else
    if(isa(imageStack, 'single'))
        imageStack = double(imageStack);
    end

    if(isa(imageStack, 'uint8'))
        imageStack = double(imageStack) / 255.0;
    end
        
    if(isa(imageStack, 'uint16'))
        imageStack = double(imageStack) / 655535.0;
    end
end

%number of images in the stack
[r, c, col, n] = size(imageStack);

%compute the weights for each image
total  = zeros(r, c);
weight = ones(r, c, n);
for i=1:n
    if(wE > 0.0)
        weightE = MertensWellExposedness(imageStack(:,:,:,i));
        weight(:,:,i) = weight(:,:,i) .* weightE.^wE;
    end
    
    if(wC > 0.0)
        if(size(imageStack(:,:,:,i), 3) > 1)
            L = mean(imageStack(:,:,:,i), 3);
        else
            L = imageStack(:,:,:,i);
        end
        
        weightC = MertensContrast(L);
        weight(:,:,i) = weight(:,:,i) .* (weightC.^wC);
    end

    if(wS > 0.0)
        weightS = MertensSaturation(imageStack(:,:,:,i));
        weight(:,:,i) = weight(:,:,i) .* (weightS.^wS);
    end
    
    weight(:,:,i) = weight(:,:,i) + 1e-12;
    
    total = total + weight(:,:,i);
end

for i=1:n %weights normalization
    weight(:,:,i) = weight(:,:,i) ./ total;
end

%empty pyramid
pyrAcc = [];
for i=1:n
    %Laplacian pyramid: image
    pyrImg = pyrImg3(imageStack(:,:,:,i), @pyrLapGen);
    %Gaussian pyramid: weight   
    pyrW   = pyrGaussGen(weight(:,:,i));
    %image times weight
    pyrImgW = pyrLstS2OP(pyrImg, pyrW, @pyrMul);
   
    if(i == 1)
        pyrAcc = pyrImgW;
    else %accumulate
        pyrAcc = pyrLst2OP(pyrAcc, pyrImgW, @pyrAdd);
    end
end

%reconstruction
imgOut = zeros(r, c, col);
for i=1:col
    imgOut(:,:,i) = pyrVal(pyrAcc(i));
end

%clamp to values in [0,1]
min_i = min(imgOut(:));
max_i = max(imgOut(:));
imgOut = ClampImg((imgOut - min_i) / (max_i - min_i),  0.0, 1.0);

if(bWarning)
    warning('This algorithm outputs images with gamma encoding. Inverse gamma is not required to be applied.');
end

end