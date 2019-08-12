function ret = checkVideoResolution(r, c)
%
%       ret = checkVideoResolution(r, c)
%
%
%        Input:
%           -r: number of rows of an image
%           -c: number of columns of an image
%
%        Output:
%           -ret: true if it is a listed resolution, false otherwise
%
%     Copyright (C) 2014  Francesco Banterle
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

resolutions = [ 176, 144;...
                160, 128;...
                320, 240;...
                352, 240;...
                352, 288;...
                640,  480;...
                720,  480;...
                704,  576;...
                720,  576;...
                1280,  72;...
                1920, 1080];

n =  size(resolutions,1);

ret = 0;

for i=1:n
    if( (resolutions(i, 1) == c) && (resolutions(i, 2) == r) )
        ret = 1;
        break;
    end
end

end
