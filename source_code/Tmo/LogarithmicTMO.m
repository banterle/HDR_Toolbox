function imgOut = LogarithmicTMO(img, log_q, log_k)
%
%        imgOut = LogarithmicTMO(img, log_q, log_k)  
%
%
%       Input:
%           -img: input HDR image
%           -log_q: appearance value (1, +inf)
%           -log_k: appearance value (1, +inf)
%
%       Output
%           -imgOut: tone mapped image
% 
%     Copyright (C) 2006-2010 Francesco Banterle
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

check13Color(img);

checkNegative(img);

if(~exist('log_q', 'var'))
    log_q = 1;
end

if(~exist('log_k', 'var'))
    log_k = 1;
end

%check log_q >= 1
if(log_q < 1)
    log_q = 1;
end

%check log_q >= 1
if(log_k < 1)
    log_k = 1;
end

L = lum(img);

LMax = max(L(:)); %compute the max luminance

%dynamic range reduction
Ld = log10(1 + L * log_q) / log10(1 + LMax * log_k);

%change luminance in img
imgOut = ChangeLuminance(img, L, Ld);

end