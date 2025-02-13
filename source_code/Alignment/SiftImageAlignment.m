function [imgOut, H] = SiftImageAlignment(img1, img2, maxIterations)
%
%       [imgOut, H] = SiftImageAlignment(img1, img2, maxIterations)
%
%       This function computes alignment using SIFT from VL Feat.
%
%
%       input:
%           -img1: reference image.
%           -img2: image to be aligned to img1.
%           -maxIterations: number of iterations for RANSAC (typically
%           32-100).
%
%       output:
%           -imgOut: img2 aligned to img1 using a homography.
%           -H: the homography for aligning img2 onto img1.
%
%
%     This code is written by Francesco Banterle, based upon the 
%     "SIFT_MOSAIC" example from the VL Fleat library by Andrea Vedaldi
%     and Brian Fulkerson (starting team), and the whole VL Feat team.
%     For more details please visit the website of the package:
%                   http://www.vlfeat.org/
%     
%   BSD license:
%       Copyright (C) 2007-11, Andrea Vedaldi and Brian Fulkerson
%       Copyright (C) 2012-13, The VLFeat Team
%       All rights reserved.
% 
%   Redistribution and use in source and binary forms, with or without
%   modification, are permitted provided that the following conditions are
%   met:
%   1. Redistributions of source code must retain the above copyright
%      notice, this list of conditions and the following disclaimer.
%   2. Redistributions in binary form must reproduce the above copyright
%      notice, this list of conditions and the following disclaimer in the
%      documentation and/or other materials provided with the
%      distribution.
% 
%    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
%   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
%   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
%   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
%   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
%   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

if(~exist('maxIterations', 'var'))
    maxIterations = 1000;
end

if(maxIterations < 1)
    maxIterations = 1000;
end

im1g = single(lum(img1));
im2g = single(lum(img2));

m1 = mean(im1g(:));
m2 = mean(im2g(:));

if (m1 <= 0.0) || (m2 <= 0.0)
    error('One of the two images has only 0 or negative values.')
end

if(m1 > m2)
    im2g = ClampImg(im2g * m1 / m2, 0, 1);
else
    im1g = ClampImg(im1g * m2 / m1, 0, 1);
end

im1g = RemoveSpecials(im1g);
im2g = RemoveSpecials(im2g);

%extract points features
points1 = detectBRISKFeatures(im1g);
points2 = detectBRISKFeatures(im2g);

%extract descriptors
[features1,valid_points1] = extractFeatures(im1g,points1, 'Method', 'SIFT');
[features2,valid_points2] = extractFeatures(im2g,points2, 'Method', 'SIFT');

%match descriptors
indexPairs = matchFeatures(features1, features2);

%get matched points
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);
%showMatchedFeatures(im1g,im2g, matchedPoints1, matchedPoints2);

n = length(matchedPoints1);

X1 = [];
X2 = [];
thr = 0.3 * max([size(img1), size(img2)]);
for i=1:n
    x1 = [matchedPoints1(i).Location, 1];
    x2 = [matchedPoints2(i).Location, 1];

    d = x1 - x2;
    l = sqrt(sum(d.*d));

    if (l < thr)    
        X1 = [X1; x1];
        X2 = [X2; x2];
    end
end
n = max(size(X1));

%compute homography using robustly with RANSAC
inliers = [];

for i = 1:maxIterations
  % estimate homography
  subset = randperm(n, 4);

  H_i = estimateHomography(X2(subset, :), X1(subset,:));

  %compute homography inliers
  inliers_i = [];
  for j=1:n
      p1_j = X1(j,:)';
      p2_j = X2(j,:)';
      Hp2_j = H_i * p2_j;
      Hp2_j = Hp2_j / Hp2_j(3);

      d = (Hp2_j - p1_j);
      d_sq = sum(d.*d);

      if (d_sq < 4)
          inliers_i = [inliers_i, j];
      end
  end

  if length(inliers_i) > length(inliers)
      inliers = inliers_i;
  end
end

X2i = X2(inliers, :);
X1i = X1(inliers, :);
H = estimateHomography(X2i, X1i);

%non-linear refinement
function err = residual(H)
    u = H(1) * X2i(:,1) + H(4) * X2i(:,2) + H(7);
    v = H(2) * X2i(:,1) + H(5) * X2i(:,2) + H(8);
	d = H(3) * X2i(:,1) + H(6) * X2i(:,2) + 1;
	du = X1i(:,1) - u ./ d;
	dv = X1i(:,2) - v ./ d;
	err = sum(du.*du + dv.*dv);
end

opts = optimset('Display', 'none', 'TolFun', 1e-9, 'TolX', 1e-9);
H(1:8) = fminsearch(@residual, H(1:8)', opts);

%apply homography H
H = inv(H);
ur = 1:size(img2, 2);
vr = 1:size(img2, 1);
[u1, v1] = meshgrid(ur, vr) ;

z2 =  H(3,1) * u + H(3,2) * v + H(3,3) ;
u2 = (H(1,1) * u + H(1,2) * v + H(1,3)) ./ z2 ;
v2 = (H(2,1) * u + H(2,2) * v + H(2,3)) ./ z2 ;

imgOut = zeros(size(img1));

for i=1:size(img2, 3)
    imgOut(:,:,i) = RemoveSpecials(interp2(u1, v1, img2(:,:,i), u2, v2, 'linear', NaN));
end

%mask = zeros(size(imgOut));
%for j=1:3
%    mask(imgOut(:,:,j) <= 0) = mask(imgOut(:,:,j) <= 0) + 1;
%end
%imgOut = CriminisiInpainting(imgOut, ClampImg(lum(mask)*4, 0,1), 15);

end
