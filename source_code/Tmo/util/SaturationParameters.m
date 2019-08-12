function [ sigma_cone, sigma_rod ] = SaturationParameters(A_cone, A_rod )
%
%       [ sigma_cone, sigma_rod ] = BleachingParameters( A_cone, A_rod )
%
%       This function computes sigmoid response
%
%       input:
%           -A_cone: adaptation for cones in cd/m^2
%           -A_rod: adaptation for rods in cd/m^2
%
%       output:
%           -sigma_cone: saturation parameter for cones
%           -sigma_rod: saturation parameter for rods
%
%     Copyright (C) 2011-14  Francesco Banterle
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

j = 1.0 / (5e5 * A_rod + 1);
k = 1.0 / (5 * A_cone + 1);

t1 = 19000.0 * j^2;
t2 = 0.2615 * (1 - j^2)^4;
sigma_rod = 2.5874 * A_rod / (t1 * A_rod + t2 * A_rod^(1.0/6.0));

t3 = (1.0 - k^4)^2;
sigma_cone = 12.9223 * A_cone / (k^4 * A_cone + t3 * A_cone^(1.0/3.0) );

end