function [imgOut, Lt] = CalibrateHDR(img, bRobust)
%
%       [imgOut, Lt] = CalibrateHDR(img, bRobust)
%
%
%        Input:
%           -img: input HDR image
%           -bRobust: if it sets to 1 robust statistics are used for
%           computing max and min
%
%        Output:
%           -imgOut: automatically calibrated HDR image
%           -Lt: threshold for light sources
%
%     Copyright (C) 2013  Francesco Banterle
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

if(~exist('bRobust', 'var'))
    bRobust = 0;
end

L = lum(img);
L_log10 = log10(L + 1e-5);
Lavg = mean(L_log10(:));
    
if(bRobust)
	Lmin = MaxQuart(L, 0.05);
	Lmax = MaxQuart(L, 0.95);
else
	Lmin = min(L(L > 0.0));
	Lmax = max(L(L > 0.0));
end
    
k = (Lavg - log10(Lmin)) / (log10(Lmax) - log10(Lmin));
f = 1e4 * k / Lmax;
Lt = Lmin + (06. + 0.4 * (1.0 - k)) * (Lmax - Lmin);
    
imgOut = img * f;
end