function p = pyrGaussGen(img)
%
%
%        p = pyrGaussGen(img)
%
%
%        Input:
%           -img: an image
%
%        Output:
%           -p: a Gaussian pyramid of img
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

[r, c, ~] = size(img);
levels = floor(log2(min(r, c)));
list = [];
for i=1:levels
    %Detail layer
    ts   = struct('detail', img);
    list = [list, ts];  

    %Next level
    img = pyrGaussGenAux(img);
end

%Base layer
p = struct('list', list, 'base', img);

end