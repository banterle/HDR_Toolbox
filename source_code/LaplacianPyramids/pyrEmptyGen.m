function p = pyrEmptyGen(r, c)
%
%
%        p = pyrEmptyGen(r, c)
%
%
%        Input:
%           -r: number of rows of the empty image
%           -c: number of columns of the empty image
%
%        Output:
%           -p: the empty pyramid
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

empty = zeros(r, c);

p = pyrLapGen(empty);

end