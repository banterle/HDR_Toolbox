function ret = MaxQuart(matrix, percentile)
%
%
%       ret = MaxQuart(matrix, percentile)
%
%
%       Input:
%           -matrix: a matrix
%           -percentile: a value in the range [0,1]
%
%       Output:
%           -ret: the percentile of the input matrix
%
%     Copyright (C) 2011-2015  Francesco Banterle
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

if(percentile > 1.0)
    percentile = 1.0;
end

if(percentile < 0.0)
    percentile = 0.0;
end

[n, m] = size(matrix);

matrix = sort(reshape(matrix, n * m, 1));
index = round(n * m * percentile);
index = max([index 1]);
ret = matrix(index);

end
