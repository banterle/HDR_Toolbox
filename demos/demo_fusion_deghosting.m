%
%       HDR Toolbox demo Deghosting+Fusion:
%       Author: Francesco Banterle
%       Copyright 2012-2017 (c)
%
%

clear all;
disp('0) Reading an LDR stack');

folder = 'demos/stack_ghost';

if ~isfolder(folder)
   folder = 'stack_ghost';
   output_folder = 'output';
else
    output_folder = 'demos/output';
end

[stack, norm_value] = ReadLDRStack(folder, 'jpg', 1);

%Pence and Kautz
disp('1) Applying fusion + deghosting operator by Pece and Kautz to images in a stack folder');
img_merged = PeceKautzMerge(stack, [], 1, 3, 17, 0.5);

disp('2) Showing the image after fusion, note that there is no need of gamma correction!');
h = figure(1);
set(h, 'Name', 'Pece and Kautz exposure fusion with deghosting (no need of gamma encoding)');
GammaTMO(img_merged, 1.0, 0, 1);

disp('3) Saving the tone mapped image as a PNG.');
imwrite(img_merged, [output_folder, '/TMO_fusion_pece_kautz.png']);

%Mertens et al.
disp('4) Comparison with the Mertens et al. fusion operator');
img_merged = MertensTMO([], stack);

disp('5) Showing the image after fusion, note that there is no need of gamma correction!');
h = figure(2);
set(h, 'Name', 'Mertens et al. exposure fusion without deghosting (no need of gamma encoding)');
GammaTMO(img_merged, 1.0, 0, 1);

disp('6) Saving the tone mapped image as a PNG.');
imwrite(img_merged, [output_folder, '/TMO_fusion_mertens.png']);
