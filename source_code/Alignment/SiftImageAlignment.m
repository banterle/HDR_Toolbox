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

if(~exist('vl_colsubset') || ~exist('vl_sift') || ~exist('vl_ubcmatch'))
    error('This function needs VL Feat. Please download it from http://www.vlfeat.org/');
end

if(~exist('maxIterations', 'var'))
    maxIterations = 64;
end

if(maxIterations < 1)
    maxIterations = 64;
end

%converting into luminance
ratio_2_1 = RemoveSpecials(img2 ./ img1);
img1 = img1 * mean(ratio_2_1(:));

try
    im1g = single(ColorToGrayFusion(img1));
    im2g = single(ColorToGrayFusion(img2));
catch e
    disp(e);
    im1g = single(lum(img1));
    im2g = single(lum(img2));
end

%do we have out of range values?
max_1 = max(im1g(:));
max_2 = max(im2g(:));

if(max_1 > 1.0 || max_2 > 1.0)
    min_1 = min(im1g(:));
    min_2 = min(im2g(:));
    
    r_1 = max_1 / min_1;
    r_2 = max_2 / min_2;
    
    if(r_1 > 1000 || r_2 > 1000)
        Lwa = max([logMean(im1g), logMean(im2g)]);
        im1g = im1g / Lwa;
        im2g = im2g / Lwa;

        im1g = im1g ./ (im1g + 1.0);
        im2g = im2g ./ (im2g + 1.0);
    else
        max_val = max([max_1, max_2]);
        im1g = im1g / max_val;
        im2g = im2g / max_val;
        
    end   
end

im1g = RemoveSpecials(im1g);
im2g = RemoveSpecials(im2g);

%SIFT matches
[f1,d1] = vl_sift(im1g) ;
[f2,d2] = vl_sift(im2g) ;

[matches, ~] = vl_ubcmatch(d1, d2) ;

numMatches = size(matches,2) ;

X1 = f1(1:2,matches(1,:)); X1(3,:) = 1;
X2 = f2(1:2,matches(2,:)); X2(3,:) = 1;

% RANSAC with homography model
%clear H score ok ;
score = -1;
H = zeros(3, 3);
ok = [];

for t = 1:maxIterations
  % estimate homography
  subset = vl_colsubset(1:numMatches, 4);
  A = [] ;
  for i = subset
    A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i))));
  end
  
  [~, ~, V] = svd(A);
  H_t = reshape(V(:,9),3,3);

  %score homography
  X2_ = H_t * X1;
  du = X2_(1,:) ./ X2_(3,:) - X2(1,:)./X2(3,:);
  dv = X2_(2,:) ./ X2_(3,:) - X2(2,:)./X2(3,:);
  ok_t = (du.*du + dv.*dv) < 4;
  
  score_t = sum(ok_t);
  if(score_t > score) 
      H = H_t;
      score = score_t;
      ok = ok_t;
  end
end

%optional refinement
function err = residual(H)
    u = H(1) * X1(1,ok) + H(4) * X1(2,ok) + H(7);
    v = H(2) * X1(1,ok) + H(5) * X1(2,ok) + H(8);
	d = H(3) * X1(1,ok) + H(6) * X1(2,ok) + 1;
	du = X2(1,ok) - u ./ d;
	dv = X2(2,ok) - v ./ d;
	err = sum(du.*du + dv.*dv);
end

if(exist('fminsearch') ~= 0)
    try
        H = H / H(3, 3);
        opts = optimset('Display', 'none', 'TolFun', 1e-8, 'TolX', 1e-8);
        H(1:8) = fminsearch(@residual, H(1:8)', opts);
    catch err
        disp(err);
    end
else
    disp('Refinement disabled as fminsearch was not found.') ;
end

H = H / H(3,3);

%apply homography H
ur = 1:size(img1, 2);
vr = 1:size(img1, 1);
[u, v] = meshgrid(ur,vr) ;

z_ =  H(3,1) * u + H(3,2) * v + H(3,3) ;
u_ = (H(1,1) * u + H(1,2) * v + H(1,3)) ./ z_ ;
v_ = (H(2,1) * u + H(2,2) * v + H(2,3)) ./ z_ ;

for i=1:size(img2, 3)
    imgOut(:,:,i) = RemoveSpecials(interp2(u, v, img2(:,:,i), u_, v_, 'linear', NaN));
end

end
