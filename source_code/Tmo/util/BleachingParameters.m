function [ B_cone, B_rod ] = BleachingParameters( A_cone, A_rod )
%
%       [ B_cone, B_rod ] = BleachingParameters( A_cone, A_rod )
%
%       This function computes sigmoid response
%
%       input:
%           -A_cone: adaptation for cones in cd/m^2
%           -A_rod: adaptation for rods in cd/m^2
%
%       output:
%           -B_cone: bleaching parameter for cones
%           -B_rod: bleaching parameter for rods
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

B_cone = 2 * 1e6 / (2*1e6 + A_cone);
B_rod = 0.04 / (0.04 + A_rod);

end
