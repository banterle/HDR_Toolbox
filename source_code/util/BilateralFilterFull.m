function imgOut = BilateralFilterFull(img, imgEdges, sigma_s, sigma_r)
%
%		 imgOut = BilateralFilterFull(img, imgEdges, sigma_s, sigma_r)
%
%        This function implements a bilateral filter without
%        approximations. Note this function is very slow!
%
%		 Input:
%			-img: is an image to be filtered.
%           -imgEdges: is an edge image, where its edges will be transfered
%           to img. Note set this to [] if you do not want to transfer
%           edges.
%           -sigma_s: is the spatial sigma value. 
%           -sigma_r: is the range sigma value.
%
%		 Output:
%			-imgOut: is the filtered image.
%
%     Copyright (C) 2014-15  Francesco Banterle
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

if(isempty(imgEdges))
    imgEdges = img;
end

[r, c, col] = size(img);
imgOut = zeros(r,c,col);
imgWeight = zeros(r,c);

sigma_r2 = 2.0 * (sigma_r^2);
sigma_s2 = 2.0 * (sigma_s^2);

kernelSize = max([round(sigma_s * 5.0), 1]);
halfKernelSize = max([round(kernelSize / 2),1]);

%computing samples and their weights
[X,Y] = meshgrid(-halfKernelSize:halfKernelSize, -halfKernelSize:halfKernelSize);
[h, w] = size(X);
nSamples = h * w;
weight_s = exp(-(X.^2 + Y.^2)/sigma_s2);
weight_s = weight_s / sum(weight_s(:));

%computing the bilateral filter
for i=1:nSamples    
    imgFetch = imShift(img, [X(i), Y(i)]);
    imgFetch_Edge = imShift(imgEdges, [X(i), Y(i)]);

    if(col > 1)
        tmp = sum((imgFetch_Edge - imgEdges).^2, col);
    else
        tmp = (imgFetch_Edge - imgEdges).^2;
    end
    
    weight = exp(-tmp / sigma_r2) * weight_s(i);
    
    for j=1:col
        imgOut(:,:,j) = imgOut(:,:,j) + imgFetch(:,:,j) .* weight;
    end
    
    imgWeight = imgWeight + weight;
end

for j=1:col
    imgOut(:,:,j) = imgOut(:,:,j) ./ imgWeight;
end

imgOut(isinf(imgOut)) = img(isinf(imgOut));

end
