function y = StevensCSF(x)
%
%        y = StevensCSF(x)
%
%
%       This function computes Stevens? contrasts sensitivity
%
%       Input:
%           -x: a value in cd/m^2
%
%       Output:
%           -y: the CSF application
% 
%     Copyright (C) 2016 Francesco Banterle
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

y = zeros(size(x));
y(x <= 100) = 1.855 + 0.4 * log10(x(x <= 100) + 2.3 * 1e-5);
y(x > 100) = 2.655;

end


