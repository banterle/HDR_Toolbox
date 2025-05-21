%
%       HDR Toolbox demo build radiance map:
%	   1) Read a stack of LDR images
%	   2) Align the stack
%	   3) Read exposure values from the exif
%	   4) Estimate the Camera Response Function (CRF)
%	   5) Build the radiance map using the stack and stack_exposure
%	   6) Save the radiance map in .hdr format
%	   7) Show the tone mapped version of the radiance map
%
%       Author: Francesco Banterle
%       Copyright 2013-15 (c)
%

clear all;

name = 'stack_alignment';

output_folder = 'demos/output';
name_folder = ['demos/',name];
if ~isfolder(name_folder)
    name_folder = name;
    output_folder = 'output';
else
end

format = 'jpg';

disp('1) Read a stack of LDR images');
[stack, norm_value] = ReadLDRStack(name_folder, format, 1);

disp('2) Align the stack');
stackOut = WardAlignment(stack, 1);

disp('3) Read exposure values from the exif');
stack_exposure = ReadLDRStackInfo(name_folder, format);

disp('4) Estimate the Camera Response Function (CRF)');
[lin_fun, ~] = DebevecCRF(stackOut, stack_exposure, 256, 'Grossberg', 128, 0);    
h = figure(1);
set(h, 'Name', 'The Camera Response Function (CRF)');
plot(0:255, lin_fun(:,1), 'r', 0:255, lin_fun(:,2),'g', 0:255, lin_fun(:,3), 'b');

disp('5) Build the radiance map using the stack and stack_exposure');
[imgHDR, lin_fun] = BuildHDR(stackOut, stack_exposure, 'LUT', lin_fun, 'Deb97', 'log', 1);

disp('6) Save the radiance map in the .hdr format');
hdrimwrite(imgHDR, [output_folder, '/stack_alignment_hdr_ward_alignment.hdr']);

disp('7) Show the tone mapped version of the radiance map');
h = figure(2);
set(h, 'Name', 'Tone mapped built HDR Image from stack_alignment');
imgTMO = GammaTMO(ReinhardTMO(imgHDR), 2.2, 0, 1);
imwrite(imgTMO, [output_folder, '/stack_alignment_hdr_ward_alignment_tmo.png']);

disp('Note that the image needs to be cropped due to alignment');
