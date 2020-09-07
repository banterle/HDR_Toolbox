%
%       HDR Toolbox demo Fusion:
%	   1) Load "Bottles_Small.pfm" HDR image
%	   2) Apply different levels of distortions (i.e., gassian blur) 
%	   3) Evaluate quality using different metrics
%
%       Author: Francesco Banterle
%       Copyright 2018 (c)
%

clear all;

disp('1) Load the image Bottles_Small.pfm using hdrimread');
img = hdrimread('demos/Bottles_Small.hdr');

disp('2) Apply different levels of distortions (i.e., gassian blur)');
img_dist = {};

for i=1:8
    img_dist{i} = filterGaussian(img, 0.25 * i);
end

disp('3) Show the image after fusion, note that there is no need of gamma correction!');

psnr_classic = [];
psnr_log = [];
psnr_pu = [];
mpsnr = [];
rmse_classic = [];
rmse_log = [];
rmse_pu = [];

for i=1:8
    disp(['Distortion level: ', num2str(i)]);
    %PSNR:
    %classic PSNR
    psnr_classic(i) = PSNR(img, img_dist{i}, 'lin');
    
    %PSNR in log domain
    psnr_log(i) = PSNR(img, img_dist{i}, 'log');
    
    %PSNR in PU domain
    psnr_pu(i) = PSNR(img, img_dist{i}, 'pu');
    
    disp(['PSNR: ', num2str(psnr_classic(i)), ...
          ' PSNR (log): ', num2str(psnr_log(i)), ...
          ' PSNR (PU): ', num2str(psnr_pu(i))]);
      
   %mPSNR
   mpsnr(i) = mPSNR(img, img_dist{i});
   disp(['mPSNR: ', num2str(mpsnr(i))]);
   
   %RMSE
   %classic RMSE
   rmse_classic(i) = RMSE(img, img_dist{i}, 'lin');
    
   %RMSE in log domain
   rmse_log(i) = RMSE(img, img_dist{i}, 'log');
    
   %RMSE in PU domain
   rmse_pu(i) = RMSE(img, img_dist{i}, 'pu');
   
    disp(['RMSE: ', num2str(rmse_classic(i)), ...
          ' RMSE (log): ', num2str(rmse_log(i)), ...
          ' RMSE (PU): ', num2str(rmse_pu(i))]);   
end

h = figure(1);
set(h, 'Name', 'Classic PSNR');
plot(1:8, psnr_classic);

h = figure(2);
set(h, 'Name', 'Log PSNR');
plot(1:8, psnr_log);

h = figure(3);
set(h, 'Name', 'PU PSNR');
plot(1:8, psnr_pu);

h = figure(4);
set(h, 'Name', 'mPSNR');
plot(1:8, mpsnr);

h = figure(5);
set(h, 'Name', 'Classic RMSE');
plot(1:8, rmse_classic);

h = figure(6);
set(h, 'Name', 'Log RMSE');
plot(1:8, rmse_log);

h = figure(7);
set(h, 'Name', 'PU RMSE');
plot(1:8, rmse_pu);

