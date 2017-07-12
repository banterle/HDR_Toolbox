%
%       HDR Toolbox demo Deghosting+Fusion:
%       Author: Francesco Banterle
%       Copyright 2012-2016 (c)
%
%

clear all;

%Pence and Kautz
disp('1) Applying fusion + deghosting operator by Pece and Kautz to images in a stack folder');
img_merged = PeceKautzMerge([], 'stack_ghost', 'jpg', [], 1, 3, 17, 0.5);

disp('2) Showing the image after fusion, note that there is no need of gamma correction!');
h = figure(1);
set(h, 'Name', 'Pece and Kautz exposure fusion with deghosting (no need of gamma encoding)');
GammaTMO(img_merged, 1.0, 0, 1);

disp('3) Saving the tone mapped image as a PNG.');
imwrite(img_merged, 'hong_kong_pece_kautz.png');

%Mertens et al.
disp('4) Comparison with the Mertens et al. fusion operator');
img_merged = MertensTMO([], 'stack_ghost', 'jpg', []);

disp('5) Showing the image after fusion, note that there is no need of gamma correction!');
h = figure(2);
set(h, 'Name', 'Mertens et al. exposure fusion without deghosting (no need of gamma encoding)');
GammaTMO(img_merged, 1.0, 0, 1);

disp('6) Saving the tone mapped image as a PNG.');
imwrite(img_merged, 'hong_kong_mertens.png');
