%
%       HDR Toolbox demo 5:
%	   1) Load "Bottles_Small.hdr" HDR image
%      2) Activate the Interactive HDR Visualization tool
%      3) Write a .png file with the latest clicked exposure using
%      InteractiveHDRVis
%
%       Author: Francesco Banterle
%       Copyright June 2012 (c)
%
%
clear all;

disp('1) Load "Bottles_Small.hdr" HDR image');
img = hdrimread('demos/Bottles_Small.hdr');

disp('2) Activate the Interactive HDR Visualization tool');
[img_cur_exp, exposure] = AExposureGUI(img);

disp('3)  Write a .png file with the latest clicked exposure using InteractiveHDRVis');
imwrite(GammaTMO(img_cur_exp, 2.2, 0.0, 0), 'demos/output/Venice01_int_vis.png');
