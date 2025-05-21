%
%      This HDR Toolbox demo estimates the camera Response function (CRF) of 
%       a stack using different methods: DebevecCRF, MitsunagaNayarCRF, 
%       and RobertsonCRF:
%	   1) Read a stack of LDR images
%	   2) Read exposure values from the EXIF
%	   3) Estimate the CRF using DebevecCRF
%	   4) Estimate the CRF using MitsunagaNayarCRF
%	   5) Estimate the CRF using RobertsonCRF
%
%       Author: Francesco Banterle
%       Copyright 2016 (c)
%

clear all;

x = (0:255) / 255;

name = 'stack';
output_folder = 'demos/out';
name_folder = ['demos/', name];

if ~isfolder(name_folder)
    name_folder = name;
    output_folder = 'output';
end

format = 'jpg';

disp('1) Read a stack of LDR images');
[stack, norm_value] = ReadLDRStack(name_folder, format, 1);

disp('2) Read exposure values from the EXIF');
stack_exposure = ReadLDRStackInfo(name_folder, format);

%
% Debevec
%

disp('3) Estimate the CRF using DebevecCRF');
 [lin_fun_deb, max_lin_fun_deb] = DebevecCRF(stack, stack_exposure);

h = figure(1);
set(h, 'Name', 'Debevec CRF method');
plot(x, lin_fun_deb(:,1), 'r', x, lin_fun_deb(:,2),'g', x, lin_fun_deb(:,3), 'b');

%
% Mitsunaga-Nayar
%

disp('4) Estimate the CRF using MitsunagaNayarCRF');

[lin_fun_mn, pp] = MitsunagaNayarCRF(stack, stack_exposure, -1, 256, 'Grossberg', 0, 100);

h = figure(2);
set(h, 'Name', 'Mitsunaga Nayar CRF method');
plot(x, lin_fun_mn(:,1), 'r', x, lin_fun_mn(:,2),'g', x, lin_fun_mn(:,3), 'b');

%
% Robertson
%


disp('5) Estimate the CRF using RobertsonCRF');
lin_r = RobertsonCRF(stack, stack_exposure);

h = figure(3);
set(h, 'Name', 'The Camera Response Function (CRF)');
plot(x, lin_r(:,1), 'r', x, lin_r(:,2),'g', x, lin_r(:,3), 'b');


