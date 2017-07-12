function [s, s_map] = TMQI_LocalStructuralFidelity(L_hdr, L_ldr, window, sf)
%
%       [s, s_map] = TMQI_LocalStructuralFidelity(L_hdr, L_ldr, window, sf)
%
%
%        Input:
%           -L_hdr: an HDR image
%           -L_ldr: an LDR image
%           -window
%
%        Output:
%           -s: the structural fidelity value
%           -s_map: the local structural fidelity
%
%
%     Copyright (C) 2012 Hojatollah Yeganeh and Zhou Wang
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

C1 = 0.01;
C2 = 10;
window = window/sum(sum(window));
%----------------------------------------------------
img1 = double(L_hdr);
img2 = double(L_ldr);
mu1   = filter2(window, img1, 'same');
mu2   = filter2(window, img2, 'same');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = filter2(window, img1.*img1, 'same') - mu1_sq;
sigma2_sq = filter2(window, img2.*img2, 'same') - mu2_sq;
sigma1 = sqrt(max(0, sigma1_sq));
sigma2 = sqrt(max(0, sigma2_sq));
sigma12 = filter2(window, img1.*img2, 'same') - mu1_mu2;
%-------------------------------------------------------
% Mannos CSF Function
%f=8;
CSF = 100.*2.6*(0.0192+0.114*sf)*exp(-(0.114*sf)^1.1);
%-----------------------
u_hdr= 128/(1.4*CSF); 
sig_hdr=u_hdr/3;
sigma1p = normcdf(sigma1,u_hdr,sig_hdr);
%---------------------------------------------------------
u_ldr = u_hdr;
sig_ldr = u_ldr/3;
sigma2p = normcdf(sigma2,u_ldr,sig_ldr);
%sigma2p(sigma2< (u_ldr - 2*sig_ldr)) = 0;
%sigma2p(sigma2> (u_ldr + 2*sig_ldr)) = 1;
%----------------------------------------------------
s_map = (((2*sigma1p.*sigma2p)+C1)./((sigma1p.*sigma1p)+(sigma2p.*sigma2p)+C1)).*((sigma12+C2)./(sigma1.*sigma2 + C2));
s = mean2(s_map);
end
