function frameHDR = ZhangHDRvDecFrame(frameLUV, table_y)
%
%
%       frameHDR = ZhangHDRvDecFrame(frameLUV, table_y)
%
%
%       Input:
%           -frameLUV: logLUV representation at 8-bit
%           -y: encoding look-up table
%
%       Output:
%           -frameHDR: the reconstructed HDR frame
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
%     The paper describing this technique is:
%     "HVS BASED HIGH DYNAMIC RANGE VIDEO COMPRESSION WITH OPTIMAL BIT-DEPTH TRANSFORMATION"
% 	  by Yang Zhang, Erik Reinhard, David Bull
%     in Proceedings of 2011 IEEE 18th International Conference on Image Processing
%
%


%Reconstruction of HDR luminance
frameLUV = double(frameLUV);

L = round(frameLUV(:,:,1));

[r,c] = size(L);
n = r * c;

%applying look-up table
for i=1:n   
    L(i) = table_y(round(L(i))+1);    
end

frameLUV(:,:,1) = L;

frameHDR = LogLuv2float(frameLUV);

end