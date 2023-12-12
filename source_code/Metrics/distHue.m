function mean_hue_diff = distHue(img_dst, img_ref)
%
%       mean_hue_diff = distHue(img_dst, img_ref)
%
%       This function outputs hue differences.
%
%       input:
%         - img_dst: a distorted image.
%         - img_ref: the reference image.
%
%       output:
%         - mean_hue_diff: mean hue difference.
%
%
%     Copyright (C) 2023  Francesco Banterle
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
%     "Color Correction for Tone Reproduction"
% 	  by Tania Pouli1, Alessandro Artusi, Francesco Banterle, 
%     Ahmet Oguz Akyuz, Hans-Peter Seidel and Erik Reinhard
%     in the Twenty-first Color and Imaging Conference (CIC21), Albuquerque, Nov. 2013 
%

if(~isSameImage(img_dst, img_ref))
    error('ERROR: img_dst and img_ref have different spatial resolutions.');
end

check3Color(img_dst);

checkNegative(img_ref);
checkNegative(img_dst);

img_ref = img_ref / max(img_ref(:));
img_dst = img_dst / max(img_dst(:));

%conversion from RGB to XYZ
img_ref_XYZ = ConvertRGBtoXYZ(img_ref, 0);
img_dst_XYZ = ConvertRGBtoXYZ(img_dst, 0);
%conversion from XYZ to IPT
img_ref_IPT = ConvertXYZtoIPT(img_ref_XYZ, 0);
img_dst_IPT = ConvertXYZtoIPT(img_dst_XYZ, 0);
%conversion from IPT to ICh
img_ref_ICh = ConvertIPTtoICh(img_ref_IPT, 0);
img_dst_ICh = ConvertIPTtoICh(img_dst_IPT, 0);

deltaH = abs(img_dst_ICh(:,:,3) - img_ref_ICh(:,:,3));
%deltaC = abs(img_dst_ICh(:,:,2) - img_ref_ICh(:,:,2));
%deltaI = abs(img_dst_ICh(:,:,1) - img_ref_ICh(:,:,1));
%mean_C_diff = mean(deltaC(:));
%mean_I_diff = mean(deltaI(:));

mean_hue_diff = mean(deltaH(:));

end
