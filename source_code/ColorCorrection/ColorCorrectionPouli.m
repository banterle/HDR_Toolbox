function imgTMO_c = ColorCorrectionPouli(imgHDR, imgTMO)
%
%       imgTMO_c = ColorCorrection(imgHDR, imgTMO)
%
%       This function saturates/desaturates colors in an imgTMO
%
%       input:
%         - imgHDR: an HDR image in RGB color space.
%         - imgTMO: a tone mapped version of imgHDR in a linear RGB color space.
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

check3Color(imgHDR);

%normalization step
max_TMO = max(imgTMO(:));
max_HDR = max(imgHDR(:));
imgHDR = imgHDR / max_HDR;
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
C_TMO_prime = imgTMO_ICh(:,:,2) .* imgHDR_ICh(:,:,1) ./ imgTMO_ICh(:,:,1);
r1 = SaturationPouli(imgHDR_ICh(:,:,2), imgHDR_ICh(:,:,1));
r2 = SaturationPouli(C_TMO_prime, imgTMO_ICh(:,:,1));
r = r1 ./ r2; %final scale
imgTMO_ICh(:,:,2) = r .* C_TMO_prime; %final scale
imgTMO_ICh(:,:,3) = imgHDR_ICh(:,:,3); %same hue of HDR

%conversion from IPT to XYZ
imgTMO_c_IPT = ConvertIPTtoICh(imgTMO_ICh, 1);
%conversion from IPT to XYZ
imgTMO_c_XYZ = ConvertXYZtoIPT(imgTMO_c_IPT, 1);
%conversion from XYZ to RGB
imgTMO_c = ConvertRGBtoXYZ(imgTMO_c_XYZ, 1);

end
