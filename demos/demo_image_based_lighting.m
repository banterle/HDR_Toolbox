%
%       HDR Toolbox demo 2:
%	   1) Load "CS_Warwick.pfm" HDR image
%      2) Show the Tone mapped HDR image
%	   3) Calculate/Show/Save a Diffuse Map
%	   4) Calculate/Show/Save a Light sources
%
%       Author: Francesco Banterle
%       Copyright February 2011 (c)
%
%

clear all;

disp('1) Load "CS_Warwick.hdr" HDR image');
img = hdrimread('CS_Warwick.hdr');

disp('2) Tone Mapping the HDR image');
imgTMO = ReinhardTMO(img, 0.15, 1e8, 0,8);
disp('3) Apply Color Correction');
imgTMO = ColorCorrection(imgTMO,0.8);
disp('4) Showing the tonemapped images with gamma 2.2');
h = figure(1);
set(h,'Name','Tone mapped (ReinhardTMO) environment map with gamma encoding, 2.2');
GammaTMO(imgTMO, 2.2, 0, 1);

disp('5) Calculate/Show/Save a Diffuse Map');
[imgOut, SH] = DiffuseConvolutionSH(img, 1);
h = figure(2);
set(h,'Name','Diffuse map with gamma encoding, 2.2');
GammaTMO(imgOut * 0.5, 2.2, 0, 1);
hdrimwrite(imgOut,'diffuse_map.hdr');

disp('6) Calculate/Show/Save a Light sources');

%uniform sampling
[imgUS, lightsUS] = UniformSampling(img, 256, 1);
h = figure(3);
set(h,'Name','Median-Cut Algorithm sampling for light sources');
imgOut = GaussianFilter(imgUS * 0.25, 1.0);
imwrite(imgOut, 'ibl_uniform_sampling.png');
GammaTMO(imgOut, 1.0, 0, 1);
ExportLights(lightsUS, 'light_sources_mc');

%median-cut
[imgMC, lightsMC] = MedianCut(img, 256, 1);
h = figure(3);
set(h,'Name','Median-Cut Algorithm sampling for light sources');
imgOut = GaussianFilter(imgMC * 0.25, 1.0);
imwrite(imgOut, 'ibl_median_cut.png');
GammaTMO(imgOut, 1.0, 0, 1);
ExportLights(lightsMC, 'light_sources_us');
