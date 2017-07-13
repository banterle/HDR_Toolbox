%
%       HDR Toolbox demo build radiance map:
%	   1) Read a stack of LDR images
%	   2) Read exposure values from the EXIF
%	   3) Estimate the Camera Response Function (CRF)
%      4) Align image using VLFeat''s SIFT
%	   5) Build the radiance map using the stack and stack_exposure
%	   6) Save the radiance map in .hdr format
%	   7) Show the tone mapped version of the radiance map
%
%       Author: Francesco Banterle
%       Copyright 2013-15 (c)
%

clear all;

name_folder = 'stack_alignment';
format = 'jpg';

disp('1) Read a stack of LDR images');
[stack, norm_value] = ReadLDRStack(name_folder, format, 1);

disp('2) Read exposure values from the EXIF');
stack_exposure = ReadLDRStackInfo(name_folder, format);

disp('3) Align the stack using VLFeat''s SIFT');
stackOut = SiftAlignment(stack, 1);

disp('4) Estimage the CRF');
[lin_fun, ~] = DebevecCRF(stackOut, stack_exposure);  
h = figure(1);
set(h, 'Name', 'The Camera Response Function (CRF)');
plot(0:255, lin_fun(:,1), 'r', 0:255, lin_fun(:,2),'g', 0:255, lin_fun(:,3), 'b');

disp('5) Build the radiance map using the stack and stack_exposure');
imgHDR = BuildHDR(stackOut, stack_exposure, 'LUT', lin_fun, 'Deb97', 'log');

disp('6) Save the radiance map in the .hdr format');
hdrimwrite(imgHDR, 'output/stack_alignment_hdr_sift_alignment.hdr');

disp('7) Show the tone mapped version of the radiance map');
h = figure(2);
set(h, 'Name', 'Tone mapped version of the built HDR image');
imgTMO = GammaTMO(ReinhardTMO(imgHDR), 2.2, 0, 1);
imwrite(imgTMO, 'output/stack_alignment_hdr_sift_alignment_tmo.png');

disp('Note that the image needs to be cropped due to alignment');
