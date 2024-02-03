function imgTMO_c = ColorCorrectionPouli(imgHDR, imgTMO, bClampTMO)
%
%       imgTMO_c = ColorCorrectionPouli(imgHDR, imgTMO, bClampTMO)
%
%       This function saturates/desaturates colors in an imgTMO
%
%       input:
%         - imgHDR: an HDR image in RGB color space.
%         - imgTMO: a tone mapped version of imgHDR in a linear RGB color space.
%         - bClampTMO: enables normalization for the tone mapped image. By
%         default this is disabled.
%
%       output:
%         - imgTMO_c: imgTMO with color correction in a linear RGB color
%         space.
%
%     Copyright (C) 2013-2017  Francesco Banterle
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

if(~isSameImage(imgHDR, imgTMO))
    error('ERROR: imgHDR and imgTMO have different spatial resolutions.');
end

if(~exist('bClampTMO', 0))
    bClampTMO = 0;
end

check3Color(imgHDR);

checkNegative(imgTMO);
checkNegative(imgHDR);

%normalization step
max_TMO = max(imgTMO(:));
max_HDR = max(imgHDR(:));
imgHDR = imgHDR / max_HDR;

if (bClampTMO && (max_TMO > 1.0))
    max_TMO = 1.0;
end

imgTMO = imgTMO / max_TMO;

%conversion from RGB to XYZ
imgTMO_XYZ = ConvertRGBtoXYZ(imgTMO, 0);
imgHDR_XYZ = ConvertRGBtoXYZ(imgHDR, 0);
%conversion from XYZ to IPT
imgTMO_IPT = ConvertXYZtoIPT(imgTMO_XYZ, 0);
imgHDR_IPT = ConvertXYZtoIPT(imgHDR_XYZ, 0);
%conversion from IPT to ICh
imgTMO_ICh = ConvertIPTtoICh(imgTMO_IPT, 0);
imgHDR_ICh = ConvertIPTtoICh(imgHDR_IPT, 0);

%the main algorithm
I = imgTMO_ICh(:,:,1);

imgTMO_ICh(:,:,1) = imgTMO_ICh(:,:,1) + 1e-5;
imgTMO_ICh(:,:,2) = imgTMO_ICh(:,:,2) + 1e-5;
imgHDR_ICh(:,:,1) = imgHDR_ICh(:,:,1) + 1e-5;
imgHDR_ICh(:,:,2) = imgHDR_ICh(:,:,2) + 1e-5;

C_TMO_prime = imgTMO_ICh(:,:,2) .* imgHDR_ICh(:,:,1) ./ imgTMO_ICh(:,:,1);
s1 = SaturationPouli(imgHDR_ICh(:,:,2), imgHDR_ICh(:,:,1));
s2 = SaturationPouli(C_TMO_prime, imgTMO_ICh(:,:,1));
r = s1 ./ s2; %final scale
imgTMO_ICh(:,:,2) = r .* C_TMO_prime; %final scale
imgTMO_ICh(:,:,3) = imgHDR_ICh(:,:,3); %same hue of HDR

imgTMO_ICh(:,:,1) = I;

%conversion from IPT to XYZ
imgTMO_c_IPT = ConvertIPTtoICh(imgTMO_ICh, 1);
%conversion from IPT to LMS
imgTMO_c_XYZ = ConvertXYZtoIPT(imgTMO_c_IPT, 1);
%conversion from XYZ to RGB
imgTMO_c = RemoveSpecials(ConvertRGBtoXYZ(imgTMO_c_XYZ, 1));

imgTMO_c =  imgTMO_c * max_TMO;
imgTMO_c(imgTMO_c < 0.0) = 0.0;

end
