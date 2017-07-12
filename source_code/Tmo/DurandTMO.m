function imgOut = DurandTMO(img, target_contrast)
%
%       imgOut = DurandTMO(img, target_contrast)  
%
%
%        Input:
%           -img: input HDR image
%           -target_contrast: how to reduce the dynamic range
%
%        Output:
%           -imgOut: tone mapped image
% 
%     Copyright (C) 2010-15  Francesco Banterle
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
%     "Fast Bilateral Filtering for the Display of High-Dynamic-Range Images"
% 	  by Fredo Durand and Julie Dorsey
%     in Proceedings of SIGGRAPH 2002
%

%is it a three color channels image?
check13Color(img);

checkNegative(img);

%default parameters
if(~exist('target_contrast', 'var'))
    target_contrast = 5; %as in the original paper
end

%compute luminance channel
L = lum(img);

%separate detail and base
[Lbase, Ldetail] = BilateralSeparation(L);

log_base = log10(Lbase);
max_log_base = max(log_base(:));
log_detail = log10(Ldetail);
c_factor = log10(target_contrast) / (max_log_base - min(log_base(:)));
log_absolute = c_factor * max_log_base;

log_Ld = log_base * c_factor + log_detail  - log_absolute;
Ld = 10.^(log_Ld); 

%change luminance
imgOut = ChangeLuminance(img, L, Ld);

end
