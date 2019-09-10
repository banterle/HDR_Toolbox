function imgOut = ColorCorrection(img, cc_s)
%
%       imgOut = ColorCorrection(img, cc_s)
%
%       This function saturates/desaturates colors in img.
%
%       input:
%         - img: an image.
%	      - cc_s: the saturation correction's factor in (0,1].
%                       If correction > 1 saturation is increased,
%                       otherwise the image is desaturated. This parameter
%                       can be a gray scale image.
%
%       output:
%         - imgOut: corrected values.
%
%     Copyright (C) 2011-16  Francesco Banterle
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
%     "Quantization Techniques for Visualization of High Dynamic Range Pictures"
% 	  by Christophe Schlick
%     in Photorealistic Rendering Techniques, 1995
%

if(~exist('cc_s', 'var'))
    cc_s = 0.5;
end

if(cc_s < 0.0)
    cc_s = 0.5;
end

L = lum(img);
imgOut = zeros(size(img));

for i=1:size(img, 3)
    imgOut(:,:,i) = ((img(:,:,i) ./ L).^cc_s) .* L;
end

imgOut = RemoveSpecials(imgOut);

end