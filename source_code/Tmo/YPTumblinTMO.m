function [imgOut, L_wa] = YPTumblinTMO(img, L_da, Ld_Max, C_Max, maxLayers)
%
%        [imgOut, L_wa] = YPTumblinTMO(img, L_da, Ld_Max, C_Max, maxLayers)
%
%
%        Input:
%           -img: an HDR image
%           -L_da: adaptation display luminance in [10,30] cd/m^2
%           -Ld_Max: maximum display luminance in [80, 180] cd/m^2
%           -C_Max: maximum LDR monitor contrast typically between 30 to 100
%           -maxLayers: the number of layers in [16,96]
%
%        Output:
%           -imgOut: a tone mapped image in [0,1]
%           -L_wa: luminance adaptation
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

%check parameters
if(~exist('maxLayers', 'var'))
    maxLayers = 32;
end

if(~exist('L_da', 'var'))
    L_da = 20;
end

if(~exist('Ld_Max', 'var'))
    Ld_Max = 100;
end

if(~exist('C_Max', 'var'))
    C_Max = 100;
end

L_wa = YeePattanaikLuminanceAdaptation(img, maxLayers);

imgOut = TumblinTMO(img, L_da, Ld_Max, C_Max, L_wa);

end