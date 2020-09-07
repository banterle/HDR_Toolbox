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
img = ldrimread('demos/Venice01.png');

h = figure(1);
set(h,'Name','Input LDR image');
imshow(img);

disp('2) Apply Expansion Operators:');
disp('   - the LDR image is assumed to be encoded with gamma = 2.2');
gammaRemoval = 2.2;

imgAEO = AkyuzEO(img, 5000.0, 1.0, gammaRemoval);
imgHEO = HuoEO(img, 1.6, 1e-5, gammaRemoval);
imgHPEO = HuoPhysEO(img, 5000.0, 0.86, gammaRemoval);
imgKOEO = KovaleskiOliveiraEO(img, 'image', 150, 25/255, 0.1, 5000, gammaRemoval);
imgKEO = KuoEO(img, 5000, gammaRemoval);
imgLEO = LandisEO(img, 2.2, 0.5,  5000, gammaRemoval);
[imgMEO, bWarning] = MasiaEO(img, 5000, 1, 1, gammaRemoval);

disp('3) Show the expanded image in false color');
FalseColor(imgAEO, 'log', 1, -1, 2, 'Expanded image using AkyuzEO');
FalseColor(imgHEO, 'log', 1, -1, 3, 'Expanded image using HuoEO');
FalseColor(imgHPEO, 'log', 1, -1, 4, 'Expanded image using HuoPhysEO');
FalseColor(imgKOEO, 'log', 1, -1, 5, 'Expanded image using KovaleskiOliveiraEO');
FalseColor(imgKEO, 'log', 1, -1, 6, 'Expanded image using KuoEO');
FalseColor(imgLEO, 'log', 1, -1, 7, 'Expanded image using LandisEO');
FalseColor(imgMEO, 'log', 1, -1, 8, 'Expanded image using imgMEO');

disp('4) Save the expanded images into .exr files:');
hdrimwrite(imgAEO, 'demos/output/Venice01_aeo.exr');
hdrimwrite(imgHEO, 'demos/output/Venice01_heo.exr');
hdrimwrite(imgHPEO, 'demos/output/Venice01_hpeo.exr');
hdrimwrite(imgKOEO, 'demos/output/Venice01_koeo.exr');
hdrimwrite(imgKEO, 'demos/output/Venice01_keo.exr');
hdrimwrite(imgLEO, 'demos/output/Venice01_leo.exr');
hdrimwrite(imgMEO, 'demos/output/Venice01_meo.exr');