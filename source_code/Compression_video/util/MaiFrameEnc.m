function [frameOut, l, v] = MaiFrameEnc(frame)
%
%
%       [frameOut, l, v] = MaiFrameEnc(frame)
%
%
%       Input:
%           -frame: input HDR frame
%
%       Output:
%           -frameOut: tone mapped frame
%           -y: encoding look-up table
%           -l: tone mapping function
%           -v: tone mapping function
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

%computing the tone mapping function
mai_delta = 0.1;
[l, s, v]= MaiToneMappingFunction(L, mai_delta);

%tone mapping with (l,v);
Ld = interp1(l, v, log10(L + 1e-6), 'linear'); 

frameOut = ChangeLuminance(frame, L, Ld);

end