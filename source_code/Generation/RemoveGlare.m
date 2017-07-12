function [imgOut, imgGlare, PSF] = RemoveGlare( img )
%
%       [imgOut, imgGlare, PSF] = RemoveGlare( img )
%
%       This function estimates the PSF of a camera from a single HDR image
%       and it removes veiling glare
%
%        Input:
%           -img: an HDR image
%
%        Output:
%           -imgOut: the input HDR image, img, with reduced glare
%           -imgGlare: the removed glare
%           -PSF: the estimated point spread function
%
%     Copyright (C) 2014  Francesco Banterle
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
%

%estimating the PSF
[PSF, C, hot_pixels_pos] = EstimatePSF( img );

[r, c, ~] = size(img);
Icr = imresize(img, [round(r * 256 / c), 256], 'bilinear');

%computing the glare image
imgGlare = ComputeGlareImage(Icr, PSF, hot_pixels_pos, C);

%upsampling the glare image
imgGlare = imresize(imgGlare, [size(img, 1), size(img, 2)], 'bilinear');

%removing glare
imgOut = (img - imgGlare);

end

