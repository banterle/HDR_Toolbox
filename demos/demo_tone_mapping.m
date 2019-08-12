%
%       HDR Toolbox demo 1:
%	   1) Load "Bottles_Small.pfm" HDR image
%	   2) Show the image in linear mode
%	   3) Show the image in gamma mode
%	   4) Tone map and show the image using Reinhard's TMO 
%	   5) Show and Apply Color Correction to the tone mapped image
%	   6) Save the tone mapped image as PNG
%
%       Author: Francesco Banterle
%       Copyright February 2011 (c)
%
%
clear all;

disp('1) Load the image Bottles_Small.pfm using hdrimread');
img = hdrimread('Bottles_Small.hdr');

disp('2) Show the image Bottles_Small.pfm in linear mode using imshow');
h = figure(1);
set(h,'Name','HDR visualization in Linear mode at F-stop 0');
GammaTMO(img, 1.0, 0, 1);

disp('3) Show the image Bottles_Small.hdr applying gamma');
h = figure(2);
set(h,'Name','HDR visualization with gamma correction, 2.2, at F-stop 0');
imgOut = GammaTMO(img, 2.2, 0, 1);
imwrite(imgOut, 'output/Bottles_Small_TMO_Gamma.png');

disp('4) Show the image Bottles_Small.hdr applying Reinhard''s Tmo');
h = figure(3);
set(h,'Name','Tone mapped image using ReinhardTMO');
imgTMO = ReinhardTMO(img);
imgOut = GammaTMO(imgTMO, 2.2, 0, 1);
imwrite(imgOut, 'output/Bottles_Small_TMO_Reinhard.png');

disp('5) Show and Apply Color Correction to the tone mapped image');
h = figure(4);
set(h,'Name','Tone mapped image (ReinhardTMO) with color correction');
imgTMO = ColorCorrection(imgTMO,0.5);
imgOut = GammaTMO(imgTMO, 2.2, 0, 1);

disp('6) Save the tone mapped image as a PNG.');
imwrite(imgOut, 'output/Bottles_Small_TMO_Reinhard_CC.png');