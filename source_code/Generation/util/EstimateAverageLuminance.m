function [value, value_inv] = EstimateAverageLuminance(exposure_time, aperture_value, iso_value, K_value)
%
%       [value, value_inv] = EstimateAverageLuminance(exposure_time, aperture_value, iso_value, K_value)
%
%       This function estimates the average scene luminance given camera
%       parameters.
%
%        Input:
%           -exposure_time: time in seconds [s]. 
%           -aperture_value:
%           -iso_value:
%           -K_value:
%           -value_inv:
%
%        Output:
%           -value: this value is the estimated luminance in the scene.
%
%     Copyright (C) 2015  Francesco Banterle
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

if(~exist('K_value', 'var'))
   K_value = 12.5;
end

if(~exist('aperture_value', 'var'))
   aperture_value = 1.0;
end

if(~exist('iso_value', 'var'))
   iso_value = 1.0;
end

K_value = ClampImg(K_value, 10.6, 13.4);

value = (K_value * aperture_value^2) / (iso_value * exposure_time);

value_inv = (iso_value * exposure_time) / (K_value * aperture_value^2);

end