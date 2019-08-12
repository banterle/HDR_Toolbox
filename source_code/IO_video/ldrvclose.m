function ldrv = ldrvclose(ldrv)
%
%        ldrv = ldrvclose(ldrv)
%
%
%        Input:
%           -ldrv: a ldr video structure
%
%        Output:
%           -ldrv: a ldr video structure
%
%        This function closes a video stream (ldrv) for reading frames
%
%     Copyright (C) 2013-2017  Francesco Banterle
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

if(ldrv.streamOpen == 1)

    if(strfind(ldrv.type, 'TYPE_LDR_VIDEO'))
        close(ldrv.stream);
    end    
    ldrv.streamOpen = 0;
end

end