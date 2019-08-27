function imgOut = KuangTMO(img, type_param, p_param, average_surrond_param)
%
%
%       imgOut = KuangTMO(img, type_param, p_param, average_surrond_param)
%
%       Input:
%           -img: an HDR image in the RGB color space
%           -type_param:
%               'calibrated': values in img are calibrated.
%               'unknown': default value; the maximum point is set to 
%               20,000 cd/m^2 as suggeted in the original paper.
%           -p_param: a value in [0.6, 0.85]
%           -average_surrond_param: 
%               'dark':
%               'average':
%               'dim':
%
%       Output:
%           -imgOut: tone mapped image
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
%     "iCAM06: A refined image appearance model for HDR image rendering"
% 	  by Jiangtao Kuang, Garrett M. Johnson, and Mark D. Fairchild
%     in J. Vis. Commun. Image R. 18 (2007) 406–-414
%

%is it a three color channels image?
check3Color(img);

checkNegative(img);

if(~exist('p_param', 'var'))
    p_param = 0.75;
end

p_param = ClampImg(p_param, 0.6, 0.85);

if(~exist('type_param', 'var'))
    type_param = 'unknown';
end

if(strcmp(type_param, 'unknown'))
    L = lum(img);
    img = (img / max(L(:))) * 2e4;
end

if(~exist('average_surrond_param', 'var'))
    average_surrond_param = 'average';
end

%converting from RGB to XYZ
imgXYZ = ConvertRGBtoXYZ(img, 0);

[r, c, col] = size(img);
minSize = min([r, c]);

%decomposing the image into detail and base layers: Section 2.2 of the
%original paper
sigma_s = minSize * 0.02; %as in the original paper
sigma_r = 0.35; %as in the original paper

[imgBase, imgDetail] = bilateralSeparation(imgXYZ, sigma_s, sigma_r);

%computing Chromatic adaptation: Section the 2.3 of the original paper
img_XYZ_w = filterGaussian(imgXYZ, max([r, c]) / 2, 8);

imgBase_ca = CIECAM02_ChromaticAdaptation(imgBase, img_XYZ_w);

%non-linear tone compression: Section 2.4 of the original paper
M_HPE = [  0.38971 0.68898 -0.07868; ...
          -0.22981 1.18340  0.04641; ...
           0.0     0.0      1.0];
            
imgBase_p = ConvertLinearSpace(imgBase_ca, M_HPE); %Equation 9

Y_W = img_XYZ_w(:,:,2);
L_A = Y_W * 0.2;
F_L = CIECAM02_F_L(L_A); %Equation 13

p = p_param;
imgBase_p_a = zeros(size(img));
for i=1:col
    %Equation 10, 11, 12
    tmp = (F_L .* imgBase_p(:,:,i) ./ Y_W).^p;
    imgBase_p_a(:,:,i) = ((400 * tmp) ./ (27.13 + tmp)) + 0.1;
end

clear('imgBase_p');

%Hunt's model
S = imgBase_ca(:,:,2);
S_w = max(Y_W(:));
S_t = S ./ S_w;

L_LS = 5 * L_A;

B_S = 0.5 ./ (1 + 0.3 *(L_LS .* S_t ).^0.3) + ...
      0.5 ./ (1 + 5 * L_LS); %Equation 19

j = 0.00001 ./ (L_LS + 0.00001); %Equation 18
  
F_LS = 3800 * j.^2 .* L_LS + ... 
       0.2 * (1 - j.^2).^4 .* L_LS.^(1 / 6); %Equation 16

tmp = (F_LS .* S_t).^p;
A_S = 3.05 * B_S .* (400 * tmp ./ (27.13 + tmp) ) + 0.3; %Equation 15

imgRGB_tc = zeros(size(imgBase_p_a));
for i=1:col
    imgRGB_tc(:,:,i) = imgBase_p_a(:,:,i) + A_S; %Equation 20
end

imgRGB_tc_xyz = ConvertLinearSpace(imgRGB_tc, inv(M_HPE));

clear('imgRGB_tc');
clear('imgBase_p_a');

%details' layer enhancement
L_A = imgBase(:,:,2) * 0.2;
F_L = CIECAM02_F_L(L_A);
imgDetail = StevensonDetailEnhancement(imgDetail, F_L); %Equation 24

%image attribute adjustments: Section 2.6
img_wd_XYZ = imgRGB_tc_xyz .* imgDetail;
clear('imgDetail');
clear('imgRGB_tc_xyz');

M_D65_H = [ 0.4002 0.7075 -0.0807;...
           -0.228  1.15    0.0612;...
            0.0    0.0     0.9184];

img_wd_LMS = ConvertLinearSpace(img_wd_XYZ, M_D65_H); %Equation 21

%converting the image from LMS to IPT color space
imgIPT = ConvertLMStoIPT(img_wd_LMS, 0);

%computing colorfullness
C = IPTColorfullness(imgIPT);
scale = (F_L + 1).^0.2 .* (1.29 * C.^2 - 0.27 * C + 0.42) ./ (C.^2 - 0.31 * C + 0.42);

for i=2:col
    %Equation 25, 26
    imgIPT(:,:,i) = imgIPT(:,:,i) .* scale; 
end

imgIPT(:,:,1) = KuangNormalizedGamma(imgIPT(:,:,1), KuangGamma(average_surrond_param));

%converting the image from IPT to RGB
imgOut = ConvertRGBtoXYZ(ConvertXYZtoIPT(imgIPT, 1), 1); 

%clamping values in [0,1] with robust statistics
img_min = MaxQuart(imgOut, 0.01);
img_max = MaxQuart(imgOut, 0.99);
imgOut = ClampImg((imgOut - img_min) / (img_max - img_min), 0.0, 1.0);

warning(['The output image has D65 as whitepoint.', ...
    'This is fine if the image will be displayed using sRGB color space.']);

end
