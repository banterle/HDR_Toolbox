function y = TsFerwerda(x)
%
%       y = TsFerwerda(x)
%
%
%       The gamma function used in Ferwerda TMO for Photopic levels
%
%       Input:
%           -x: a value
%
%       Output:
%           -y: application of the gamma function
% 
%     Copyright (C) 2010-15 Francesco Banterle
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

t = log10(x);

if(t <= -3.94)
    y = -2.86;
else
    if(t >= -1.44)
        y = t - 0.395;
    else
        y = (0.405 * t + 1.6)^2.18 - 2.86;
    end
end

y = 10^y;

end
