function Lout = TVI_Ashikhmin( L )
%
%
%       Lout = TVI_Ashikhmin( L )
%
%
%       The TVI function used in Ashikhmin 2002 TMO
%
%       Input:
%           -L: luminance channel in calibrated units (cd/m^2)
%
%       Output:
%           -Lout: compressed luminance channel
% 
%     Copyright (C) 2010 Francesco Banterle
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

%allocate memory
Lout = zeros(size(L));

%Case 1
ind = find(L<0.0034);
Lout(ind) = L(ind)/0.0014;

%Case 2
ind = find(L>=0.0034&L<1);
Lout(ind) = 2.4483+log(L(ind)/0.0034)/0.4027;

%Case 3
ind = find(L>=1&L<7.2444);
Lout(ind) = 16.5630+(L(ind)-1)/0.4027;

%Case 4
ind = find(L>=7.2444);
Lout(ind) = 32.0693+log(L(ind)/7.2444)/0.0556;

end

