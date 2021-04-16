function ldrv = ldrvopen(ldrv)
%
%        ldrv = ldrvopen(ldrv)
%
%
%        Input:
%           -ldrv: a LDR video structure.
%
%        Output:
%           -ldrv: an LDR video structure.
%
%        This function opens the video stream for reading frames
%
%     Copyright (C) 2013-21  Francesco Banterle
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

if(ldrv.streamOpen == 0)        
    ldrv.streamOpen = 1;
end

end
