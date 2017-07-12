function frameRec = MaiInverseToneMapping(frame, l, v)
%
%
%       frameRec = MaiInverseToneMapping(frame, l, v)
%
%
%       Input:
%           -frame: LDR luminance
%           -l: tone mapping function
%           -v: tone mapping function
%
%       Output:
%           -frameRec: reconstructed HDR frame
%
%     Copyright (C) 2013-2014  Francesco Banterle
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

L = lum(frame);

%inverse tone mapping with (l,v);
Lw = 10.^interp1(v, l, L, 'linear'); 

frameRec = ChangeLuminance(frame, L, Lw);

end
