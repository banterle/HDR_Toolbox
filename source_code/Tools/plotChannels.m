function plotChannels(imgIn, imgOut)
%
%
%        plotChannels(imgIn, imgOut)
%
%        This function plots colors channels
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

[r_i, c_i, col_i] = size(imgIn);
[r_o, c_o, col_o] = size(imgOut);

if(col_o ~= col_i)
    error('different images!');
end

hold on;
figure(1);

for i=1:col_i
    tmpX = imgIn(:,:,i);
    tmpX = imresize(tmpX, [16, 16], 'bilinear');
    tmpX = tmpX(:);
    
    tmpY = imgOut(:,:,i);
    tmpY = imresize(tmpY, [16, 16], 'bilinear');
    tmpY = tmpY(:);
    
    [tmpX, ind] = sort(tmpX(:), 'ascend');
    windowSize = 16;
    tmpY = tmpY(ind);
    tmpY = filter( (1/windowSize)*ones(1,windowSize), 1, tmpY);
    
    plot(tmpX, tmpY);
end

end