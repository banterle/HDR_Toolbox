function imgBlur = filterGaussianWindow(img, window, scaling_factor)
%
%
%       imgBlur = filterGaussianWindow(img, window)
%
%
%       Input:
%           -img: the input image
%           -window: the size in pixel of the filter; size = 5 * sigma
%           -scaling_factor: a scaling factor for speeding things up
%
%       Output:
%           -imgBlur: a filtered image
%
%     Copyright (C) 2011-15  Francesco Banterle
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

if(~exist('scaling_factor', 'var'))
    scaling_factor = 1;
end

if(scaling_factor > 1)  
    window_scaled = window / scaling_factor;
    H = fspecial('gaussian', max([round(window_scaled), 3]), GKSigma(window_scaled));    
    [r, c, ~] = size(img);

    tmp_img = imresize(img, 1.0 / scaling_factor, 'bilinear');
    imgBlur = imfilter(tmp_img, H, 'replicate');
    imgBlur = imresize(imgBlur, [r, c], 'bilinear');
else
    H = fspecial('gaussian', max([round(window), 3]), GKSigma(window));
    imgBlur = imfilter(img, H, 'replicate');
end

end
