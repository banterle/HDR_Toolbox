function imgOut = ReinhardGaussianFilter(img, s, alpha_i)
%
%
%      imgOut = ReinhardGaussianFilter(img, s, alpha_i)
%
%
%      Input:
%          -img: an image to be filtered
%          -s: size of the filter in pixel
%          -alpha_i: 
%
%      Output:
%          -imgOut: the filtered image
% 
%     Copyright (C) 2010 Francesco Banterle
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

alpha_s_sq = (alpha_i * s)^2;

% %Kernel of the filter
% s2 = round(s * 5);
% [X,Y] = meshgrid(-s2:s2, -s2:s2);
% H = exp(-(X.^2 + Y.^2) / alpha_s_sq) / (pi * alpha_s_sq);
% 
% %Filtering
% imgOut = imfilter(img, H, 'replicate');

[r, c, col] = size(img);

[x, y] = meshgrid(1:c, 1:r);
x = x - (c / 2);
y = y - (r / 2);
kernel = exp(-(x.^2 + y.^2) / alpha_s_sq) / (pi * alpha_s_sq);
kernel_f = fft2(kernel);

imgOut = zeros(size(img));

for i=1:col
    imgOut(:,:,i) = fftshift(ifft2(fft2(img(:,:,i)) .* kernel_f));
end

end