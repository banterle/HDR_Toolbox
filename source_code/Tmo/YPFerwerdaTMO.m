function [imgOut, L_wa] = YPFerwerdaTMO(img, Ld_Max, L_da, maxLayers)
%
%       imgOut = YPFerwerdaTMO(img, Ld_Max, L_da, maxLayers)
%
%
%        Input:
%           -img: input HDR image
%           -Ld_Max: maximum luminance of the display in cd/m^2
%           -L_da: adaptation luminance in cd/m^2
%           -L_wa: world adaptation luminance in cd/m^2
%           -maxLayers: the number of layers in [16,96]
%
%        Output:
%           -imgOut: tone mapped image with values in [0,1]
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
%     This is the FerwerdaTMO with Yee and Pattanaik Luminance Adaptation;
%     see the file tmo/util/YeePattanaikLuminanceAdaptation.m
%

%check parameters
if(~exist('Ld_Max', 'var'))
    Ld_Max = 100; %assuming 100 cd/m^2 output display
end

if(~exist('L_da', 'var'))
    L_da = Ld_Max / 2; %as in the original paper
end

if(~exist('maxLayers', 'var'))
    maxLayers = 32;
end

L_wa = YeePattanaikLuminanceAdaptation(img, maxLayers);

imgOut = FerwerdaTMO(img, Ld_Max, L_da, L_wa);

end

