function imgOut = normalizedImage(img)
%
%       imgOut = normalizedImage(img)
%
%
%       input:
%         - img: an image
%
%       output:
%         - imgOut: img with "normalized" local statistics
%
%     Copyright (C) 2015  Francesco Banterle
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
%     "Video Matching"
% 	  by Peter Sand and Seth Teller, MIT Computer Science and Aritficial
% 	  Intelligence Laboratory, Technical Report, November 11 2004.
%

C_threshold = 30.0 / 255.0;

C = zeros(size(img));

window_size = 24;
window_size_sq = window_size * window_size;

for i=1:size(img,3)
    img_max = ordfilt2(img(:,:,i), 1, true(window_size));
    img_min = ordfilt2(img(:,:,i), window_size_sq, true(window_size));    
    C(:,:,i) = img_max - img_min;
end

C(C < C_threshold) = C_threshold;

img_mean = imfilter(img, ones(window_size, window_size) / window_size_sq, 'replicate');

imgOut = RemoveSpecials(0.5 + (img - img_mean) ./ C);

end