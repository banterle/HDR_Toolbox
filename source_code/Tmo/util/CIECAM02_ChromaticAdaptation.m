function imgOut = CIECAM02_ChromaticAdaptation(imgXYZ, img_white_XYZ)
%
%
%       imgOut = CIECAM02_ChromaticAdaptation(imgXYZ, img_white_XYZ)
%
%       Input:
%           -imgXYZ: an image in the XYZ color space.
%           -img_white_XYZ: is imgXYZ white point image in the XYZ color space.
%
%       Output:
%           -imgOut: is imgXYZ in the XYZ color space with chromatic
%           adaption.
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
%     "The CIECAM02 color appearance model"
% 	  by Nathan Moroney , Mark D. Fairchild , Robert W. G. Hunt ,
%     Changjun Li , M. Ronnier Luo , Todd Newman
%     in IS&T/SID 10 th Color Imaging Conference
%

M_CAT02 = [ 0.7328 0.4296 -0.1624;...
           -0.7036 1.6975  0.0061;...
            0.003  0.0136  0.9834];
        
if(exist('img_white_XYZ', 'var'))
    img_RGB_w = ConvertLinearSpace(img_white_XYZ, M_CAT02);
    L_A = 0.2 * img_white_XYZ(:,:,2); %adaptation luminance
else
    img_RGB_w = ones(1,1,3);
    L_A = 1.0;
end

imgRGB = ConvertLinearSpace(imgXYZ, M_CAT02);       

D = CIECAM02_DegreeAdaptation(L_A);

wp_D65_XYZ = [96.047, 100, 108.883]; %D65 white point in XYZ
wp_D65_RGB = ConvertLinearSpace(reshape(wp_D65_XYZ, 1, 1, 3), M_CAT02);

imgRGB_c = zeros(size(imgRGB));

for i=1:size(imgXYZ, 3)
    imgRGB_c(:,:,i) = imgRGB(:,:,i) .* (wp_D65_RGB(i) .* D ./ img_RGB_w(:,:,i) + (1.0 - D));
end

imgOut = ConvertLinearSpace(imgRGB_c, inv(M_CAT02));
  
end
