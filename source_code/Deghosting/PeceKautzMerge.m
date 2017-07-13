function imgOut = PeceKautzMerge(imageStack, weights, iterations, ke_size, kd_size, ward_percentile)
%
%
%        imgOut = PeceKautzMerge(imageStack, weights, iterations, kernelSize, ward_percentile)
%
%
%        Input:
%           -imageStack: an exposure stack of LDR images
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
%           mask
%           -ke_size: size of the erosion kernel
%           -kd_size: size of the dilation kernel
%           -ward_percentile: 
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
%     "Bitmap Movement Detection: HDR for Dynamic Scenes"
% 	  by Fabrizio Pece, Jan Kautz
%     in Conference on Visual Media Production (CVMP)
%     London, UK, November 2010
%

%default parameters if they are missing
if(~exist('weights', 'var'))
    weights = ones(1, 3);
end

if(isempty(weights))
    weights = ones(1, 3);
end

wE = weights(1);
wS = weights(2);
wC = weights(3);

%imageStack generation
if(~exist('imageStack', 'var'))
    imageStack = [];
end
       
if(isa(imageStack, 'uint8'))
    imageStack = single(imageStack) / 255.0;
end
       
if(isa(imageStack, 'uint16'))
    imageStack = single(imageStack) / 655535.0;
end

if(~exist('iterations', 'var'))
    iterations = 1;
end

if(~exist('ke_size', 'var'))
    ke_size = 3;
end

if(~exist('kd_size', 'var'))
    kd_size = 17;
end

if(~exist('ward_percentile', 'var'))
    ward_percentile = 0.5;
end

%number of images in the stack
[r, c, col, n] = size(imageStack);

%Computation of weights for each image
total  = zeros(r, c);
weight = ones(r, c, n);

for i=1:n
    if(wE > 0.0)
        weightE = MertensWellExposedness(imageStack(:,:,:,i));
        weight(:,:,i) = weight(:,:,i) .* weightE.^wE;
    end
    
    if(wC > 0.0)
        L = mean(imageStack(:,:,:,i), 3);  
        weightC = MertensContrast(L);
        weight(:,:,i) = weight(:,:,i) .* (weightC.^wC);
    end

    if(wS > 0.0)
        weightS = MertensSaturation(imageStack(:,:,:,i));
        weight(:,:,i) = weight(:,:,i) .* (weightS.^wS);
    end
    
    weight(:,:,i) = weight(:,:,i) + 1e-12;
end

weight_move = weight;

[moveMask, num] = PeceKautzMoveMask(imageStack, iterations, ke_size, kd_size, ward_percentile);

for i=0:num
    indx = find(moveMask == i);
    
    Wvec = zeros(n,1);
    for j=1:n
        W = weight(:,:,j);
        Wvec(j) = sum(W(indx));
    end
    [~, j] = max(Wvec);

    W = zeros(r, c);
    W(indx) = 1;
    W_inv = 1.0 - W;

    for k=1:n
        if(j ~= k)
            weight_move(:,:,k) = weight_move(:,:,k) .* W_inv;
        end
    end
end

%Normalization of weights
for i=1:n
    %hdrimwrite(weight_move(:,:,i),['weight_move',num2str(i),'.pfm']);
    total = total + weight_move(:,:,i);
end

%empty pyramid
tf = [];
for i=1:n
    %Laplacian pyramid: image
    pyrImg = pyrImg3(imageStack(:,:,:,i), @pyrLapGen);

    %Gaussian pyramid: weight_i
    weight_i = RemoveSpecials(weight_move(:,:,i) ./ total);
    pyrW   = pyrGaussGen(weight_i);

    %Multiplication image times weights
    tmpVal = pyrLstS2OP(pyrImg, pyrW, @pyrMul);
   
    if(i == 1)
        tf = tmpVal;
    else
        %accumulation
        tf = pyrLst2OP(tf, tmpVal, @pyrAdd);    
    end
end

%Evaluation of Laplacian/Gaussian Pyramids
imgOut = zeros(r, c, col);
for i=1:col
    imgOut(:,:,i) = pyrVal(tf(i));
end

%Clamping
imgOut = ClampImg(imgOut / max(imgOut(:)), 0.0, 1.0);

disp('This algorithm outputs images with gamma encoding. Inverse gamma is not required to be applied!');
end

