function imgBlur = filterGaussianFFT(img, sigma)
%
%
%       imgBlur = filterGaussianFFT(img, sigma)
%
%
%       Input:
%           -img: the input image
%           -sigma: the value of the Gaussian filter
%
%       Output:
%           -imgBlur: a filtered image
%
%
%     Copyright (C) 2016 Francesco Banterle
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

[r, c, col] = size(img);

[x, y] = meshgrid(1:c, 1:r);
kernel = exp(-((x - c / 2).^2 +  (y - r / 2).^2) / (2 * sigma^2));
kernel = kernel / sum(kernel(:));
kernel_f = fft2(kernel);

imgBlur = zeros(size(img));

for i=1:col
    imgBlur(:,:,i) = fftshift(ifft2(fft2(img(:,:,i)) .* kernel_f));
end

end

