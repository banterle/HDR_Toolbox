function check = checkMonotonicity(sort_index, values)
%
%       val = checkMonotonicity(sort_index, values)
%
%
%        Input:
%           -sort_index:
%           -values:
%
%        Output:
%           -check:
%
%     Copyright (C) 2016  Francesco Banterle
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

check = 0;
n = length(sort_index) - 1;
col = size(values, 2);

for j=1:col
    values(:,j) = values(sort_index, j);
end

for j=1:col
    val = 1;
    for i=1:n
        if(values(i,j) < values(i + 1,j))
            val = 0;
            break;
        end    
    end
    
    check = check + val;
end

end