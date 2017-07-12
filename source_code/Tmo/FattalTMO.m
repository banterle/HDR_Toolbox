
function [imgOut, Ld_p, minVal, maxVal] = FattalTMO(img, fBeta, cc_s, bNormalization)
%
%       [imgOut, Ld, minVal, maxVal] = FattalTMO(img, fBeta, cc_s, bNormalization)
%
%
%       Input:
%           -img: HDR image
%           -fBeta: 
%           -cc_s:
%           -bNormalization: a flag for applying normalization
%            at the end with robust statistics
%
%       Output:
%           -imgOut: tone mapped image
%           -maxVal: 
% 
%     Copyright (C) 2010-2017 Francesco Banterle
%  
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%     The paper describing this technique is:
%     "Gradient domain high dynamic range compression"
% 	  by Raanan Fattal, Dani lIschinski, Michael Werman
%     in SIGGRAPH 2002
%

%is it a three color channels image?
check13Color(img);

checkNegative(img);

if(~exist('fBeta', 'var'))
    fBeta = 0.95;
end

if(~exist('cc_s', 'var'))
    cc_s = 0.6;
end

if(~exist('bNormalization', 'var'))
    bNormalization = 1;
end

%Luminance channel
Lori = lum(img);

L = log(Lori + 1e-6);

%set boundaries
L(1,:) = L(2,:);
L(end,:) = L(end-1,:);
L(:,1) = L(:,2);
L(:,end) = L(:,end-1);

%compute Gaussian Pyramid + Gradient
[r,c]   = size(L);
numPyr  = round(log2(min([r, c]))) - log2(32);
kernelX = [0, 0, 0; -1, 0, 1; 0,  0, 0];
kernelY = [0, 1, 0;  0, 0, 0; 0, -1, 0];

kernel = [1, 4, 6, 4, 1]' * [1, 4, 6, 4, 1];
kernel = kernel / sum(kernel(:));

%Generation of the pyramid
L_tmp = L;
G = [];
for i=0:numPyr
    Fx = imfilter(L_tmp, kernelX, 'same') / (2^(i + 1));
    Fy = imfilter(L_tmp, kernelY, 'same') / (2^(i + 1));
    G = [G, struct('fx', Fx, 'fy', Fy)];
    L_tmp = imresize(imfilter(L_tmp, kernel, 'same'), 0.5, 'bilinear');    
end

%Generation of the Attenuation mask
G2 = sqrt(G(1).fx.^2 + G(1).fy.^2);
fAlpha = 0.005 * mean(G2(:));
Phi_kp1 = FattalPhi(G(numPyr + 1).fx, G(numPyr + 1).fy, fAlpha, fBeta);

for k=numPyr:-1:1
    [r, c] = size(G(k).fx);
    Phi_k = FattalPhi(G(k).fx, G(k).fy, fAlpha, fBeta);
    Phi_kp1 = imresize(Phi_kp1, [r, c], 'bilinear') .* Phi_k;
end

%Calculating the divergence with backward differences
G = struct('fx', G(1).fx .* Phi_kp1, 'fy', G(1).fy .* Phi_kp1);
kernelX = [0, 0, 0; -1, 1, 0; 0,  0, 0];
kernelY = [0, 0, 0;  0, 1, 0; 0, -1, 0];
dx = imfilter(G(1).fx, kernelX);%, 'same');
dy = imfilter(G(1).fy, kernelY);%, 'same');
divG = dx + dy;

%Solving Poisson equation
Ld_p = PoissonSolver(divG);
Ld = exp(Ld_p);

if(bNormalization)
    maxVal = max(Ld(:));
    minVal = min(Ld(:));
    Ld = ClampImg((Ld - minVal) / ( maxVal - minVal), 0, 1);
else
   maxVal = 1;
   minVal = 0;
end

%Changing luminance
imgOut = ChangeLuminance(img, Lori, Ld);

imgOut = ColorCorrection(imgOut, cc_s);

end
