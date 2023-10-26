function lstOut = pyrImg3(img, fun, maxLevels)
%
%
%        lstOut = pyrImg3(img, fun, maxLevels)
%
%
%        Input:
%           -img: a three color channels image
%           -fun: a function to apply to each channel
%
%        Output:
%           -lstOut: the result of the function
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

col = size(img, 3);

lstOut = [];

if ~exist('maxLevels', 'var')
    maxLevels = -1;
end

if maxLevels > 0
    for i=1:col
        lstOut = [lstOut, fun(img(:,:,i), maxLevels)];    
    end        
else
    for i=1:col
        lstOut = [lstOut, fun(img(:,:,i))];    
    end    
end

end