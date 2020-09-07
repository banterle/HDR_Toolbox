%
%       HDR Toolbox demo Fusion:
%	   1) Load "Bottles_Small.pfm" HDR image
%	   2) Apply Fusion TMO
%	   3) Show the image without gamma encoding, because it is working in
%	   gamma space
%	   4) Save the tone mapped image as PNG
%
%       Author: Francesco Banterle
%       Copyright 2012-16 (c)
%

clear all;

disp('1) Load the image Bottles_Small.pfm using hdrimread');
img = hdrimread('demos/Bottles_Small.hdr');

disp('2) Apply Fusion Operator by Mertens et al.');
imgTMO = MertensTMO(img);

disp('3) Show the image after fusion, note that there is no need of gamma correction!');
h = figure(1);
set(h,'Name','Exposure fusion by Mertens et al.');
GammaTMO(imgTMO, 1.0, 0.5, 1);

disp('4) Save the tone mapped image as a PNG.');
imwrite(imgTMO, 'demos/output/Bottles_Small_TMO_fusion.png');
