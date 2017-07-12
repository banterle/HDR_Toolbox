function [frameOut, y] = ZhangFrameEnc(frame, n_bits)
%
%
%       [frameOut, y] = ZhangFrameEnc(frame, n_bits)
%
%
%       Input:
%           -frame: input HDR frame
%           -n_bits: number of bits for quantization
%
%       Output:
%           -frameOut: frame to be
%           -y: encoding look-up table
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

if(~exist('n_bits','var'))
    n_bits = 8;
end

frameOut = float2LogLuv(frame, 16);
L = round(frameOut(:,:,1));

[y, ~, ~] = ZhangQuantization(L, n_bits);

[r,c] = size(L);
n = r * c;

%apply a look-up table
for i=1:n
    delta = abs(y - L(i));
    [~, index] = min(delta(:));
    L(i) = index;    
end

%compute DWT2 transform
filterType = 'db3';
pyr  = dwt2Decomposition(L,  filterType, 5);

%filter the pyramid
pyr = ZhangDWTScaling(pyr);

%reconstruct 
L_denoised = round(dwt2Reconstruction(pyr, filterType));

frameOut(:,:,1) = L_denoised;

end