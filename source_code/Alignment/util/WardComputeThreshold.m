function [imgThr, imgEb] = WardComputeThreshold(img, wardPercentile, wardTolerance)
%
%
%       [imgThr, imgEb] = WardComputeThreshold(img, wardPercentile, wardTolerance)
%
%       This function computes the Ward's MTB.
%
%       Input:
%           -img: an input image
%           -wardPercentile: a value for thresholding the image. This is
%           typically set to 0.5.
%           -wardTolerance: a tolerance threshold for classifying pixels
%           falling around edges.
%
%       Output:
%           -imgThr: Ward's threshold image. This image is set to 1 if the
%           the pixel value is greater or equal to the median value.
%           -imgEb: a tolerance mask of pixels around edges of imgThr.
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

if(~exist('wardPercentile', 'var'))
    wardPercentile = 0.5;
end

if(~exist('wardTolerance', 'var'))
    wardTolerance = 4 / 256;
end

if(size(img, 3) == 1)
    grey = img;
else
    grey = (54 * img(:,:,1) + 183 * img(:,:,2) +  19 * img(:,:,3)) / 256;
end

medVal = MaxQuart(grey, wardPercentile);
    
imgThr = zeros(size(grey));
imgThr(grey > medVal) = 1.0;

A = medVal - wardTolerance;
B = medVal + wardTolerance;
imgEb = ones(size(grey));
imgEb((grey >= A) & (grey <= B)) = 0.0;

end