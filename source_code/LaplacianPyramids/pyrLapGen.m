function p = pyrLapGen(img, maxLevels)
%
%
%        p = pyrLapGen(img, maxLevels)
%
%
%        Input:
%           -img: an image
%
%        Output:
%           -p: a Laplacian pyramid of img
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

if ~exist('maxLevels', 'var')
    maxLevels = -1;
end

[r, c, ~] = size(img);

levels_log2 = floor(log2(min(r, c)));

if maxLevels < 0 
    levels = levels_log2;
else
    levels = min([levels_log2, maxLevels]);
end

list = [];

for i=1:levels
    %calculate detail and base layers
    [tL0, tB0] = pyrLapGenAux(img);
    img = tL0;
    
    %store detail layer
    ts   = struct('detail', tB0);
    list = [list, ts];  
end

%store base layer
p = struct('list', list, 'base', tL0);

end