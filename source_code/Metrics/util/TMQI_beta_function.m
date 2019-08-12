function y = TMQI_beta_function(A, B)
%
%       B = TMQI_beta_function(A, B)
%
%
%        Input:
%           -A: 
%           -B: 
%
%        Output:
%           -y: result
%
%     Copyright (C) 2013  Francesco Banterle
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

x = 0:0.0001:1.0;
y = (x.^(A-1)).*(1.0-x).^(B-1);
y = mean(y);

end