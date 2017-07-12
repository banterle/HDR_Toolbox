function index = findNameInList(list, name)
%
%
%        index = findNameInList(list, name)
%
%
%       Input:
%           -list: a list of name; i.e. a result of dir call
%           -name: a string
%
%       Output:
%           -index: the index where name is found in list. It is set to -1
%           if not found.
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

index = -1;
        
for i=1:n
    if(strcmp(name, list(i).name) == 1)
        index = i;
    end
end

end