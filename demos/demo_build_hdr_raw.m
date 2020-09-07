%
%      This HDR Toolbox demo creates an HDR radiance map:
%	   1) Read a stack of RAW images
%	   2) Read exposure values from the EXIF
%	   4) Build the radiance map using the stack and stack_exposure
%	   5) Save the radiance map in .hdr format
%	   6) Show the tone mapped version of the radiance map
%
%       Author: Francesco Banterle
%       Copyright 2015 (c)
%

clear all;

disp('Note: this demo does not have RAW files due to room limits in the repository');
disp('please add a folder with RAW files in the variable ''name_folder''.');
name_folder = ''; %Insert your raw stack folder
format = ''; %Insert your raw image format

disp('1) Read a stack of LDR images');
% negative number for saturation -> will be computed from the stack.
% With raw images this usually leads to artefacts in the highlights,
% so it is recommended to check the correct white level from image metadata
stack = ReadRAWStack(name_folder, format, -1);

disp('2) Read exposure values from the exif');
stack_exposure = ReadRAWStackInfo(name_folder, format);

disp('4) Build the radiance map using the stack and stack_exposure');
% Raw images are inherently linear, no need for CRF
imgHDR = BuildHDR(stack, stack_exposure, 'linear', [], 'Deb97', 'log');

disp('5) Save the radiance map in the .hdr format');
hdrimwrite(imgHDR, 'demos/output/stack_hdr_image_raw.exr');

disp('6) Show the tone mapped version of the radiance map with gamma encoding');
h = figure(2);
set(h, 'Name', 'Tone mapped version of the built HDR image');
imgTMO = GammaTMO(ReinhardTMO(imgHDR, 0.18), 2.2, 0, 1);
imwrite(imgTMO, 'demos/output/stack_hdr_image_tmo.png');
