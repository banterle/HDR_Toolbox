function imgBin = CreateSegmentsApprox(img)
%
%
%       imgBin = CreateSegmentsApprox(img)
%
%
%       Input:
%           -img: an HDR image
%
%       Output:
%           -imgBin: the segmented HDR image
% 
%       This function segments an image into different dynamic range zones
%       based on their order of magnitude.
%
%     Copyright (C) 2016  Francesco Banterle
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

L = lum(img);

%Filtering the image to avoid noise
L = GaussianFilter(L, 1);

min_display = 0.015;
epsilon = min_display / 2.0;
L_log10 = log10(L + epsilon);
imgBin = round(L_log10);

%Number of pixels
[n, m] = size(L);
areaTot = n * m;

%Thresholds
threshold = 0.005;
maxIterations = ceil(sqrt(threshold * areaTot));

L_log10_min = min(L_log10(:));

min_L = max([L_log10_min, min(imgBin(:))]);

imgBin = imgBin - min_L + 1;

guide = log10(L) - min_L + 1;

imgBin_max = max(guide(:));

for i=1:(maxIterations / 4)
    imgBin = bilateralFilter(imgBin, guide, 0, imgBin_max, 4, 0.25);
end

imgBin = round(imgBin);

imgBin = imgBin + min_L - 1;

end

