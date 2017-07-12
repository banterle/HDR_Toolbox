function [val, pdf] = Sampling1DDistribution(distr, u)
%
%
%        distr = Sampling1DDistribution(distr, u)
%
%
%        Input:
%           -distr: 1D distribution
%           -u: a random value in [0,1]
%
%        Output:
%           -val: index in the distribution of a u-value
%           -pdf: PDF of u
%
%     Copyright (C) 2011  Francesco Banterle
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

[p, val] = min(abs(distr.CDF - u));
pdf = distr.PDF(val);
    
end