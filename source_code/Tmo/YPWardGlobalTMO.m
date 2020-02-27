function [imgOut, L_wa] = YPWardGlobalTMO(img, Ld_max, maxLayers)
%
%       [imgOut, L_wa] = YPWardGlobalTMO(img, Ld_max, maxLayers)
%
%
%       Input:
%           -img: input HDR image
%           -Ld_max: maximum monitor LDR luminance in cd/m^2
%           -L_wa: world adpatation luminance in cd/m^2
%
%       Output
%           -imgOut: tone mapped image
%           -L_wa: luminance adaptation
% 
%     Copyright (C) 2020 Francesco Banterle
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
%     This is the TumblinTMO with Yee and Pattanaik Luminance Adaptation;
%     see the file tmo/util/YeePattanaikLuminanceAdaptation.m
%

if(~exist('Ld_max', 'var'))
    Ld_max = 100;
end

if(~exist('maxLayers', 'var'))
    Ld_max = 32;
end

if(Ld_max <= 0.0)
    Ld_max = 100;
end

L_wa = YeePattanaikLuminanceAdaptation(img, maxLayers);

[imgOut, ~] = WardGlobalTMO(img, Ld_max, L_wa);

end