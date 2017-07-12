%
%      HDR Toolbox demo 4:
%      1) Load "Venice01.png" LDR image
%      2) Apply Huo et al.s Expansion Operator
%      3) Show the expanded image in false color
%      4) Save the image as .pfm
%      5) Save the expand map as .pfm
%
%       Author: Francesco Banterle
%       Copyright 2012-14 (c)
%
%
clear all;

disp('1) Load "Venice01.png" LDR image');
img = double(imread('Venice01.png'))/255.0;
h = figure(1);
set(h,'Name','Input LDR image');
imshow(img);

disp('2) Apply Huo et al. Expansion Operator:');
disp('   - the LDR image is assumed to be encoded with gamma = 2.2');
imgOut = HuoPhysEO(img, 3000.0, 0.86, 2.2);

disp('3) Show the expanded image in false color');
FalseColor(imgOut, 'log', 1, -1, 2, 'Inverse tone mapped LDR image in false color');

disp('4) Save the expanded image into a .exr:');
hdrimwrite(imgOut, 'Venice01_expanded.exr');