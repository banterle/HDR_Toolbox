function tau = AkyuzTau(img)
%
%       tau = AkyuzTau(img)
%
%        Input:
%           -img: an LDR image with values in [0,1].
%
%        Output:
%           -tau: Akyuz and Reinhard's Tau function for stack denoising.
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

t1 = 200 /255;
t2 = 250 /255;
t3 =  50/ 255; 

tau = ones(size(img));

tau(img >= t2) = 0;        
h  = 1 - (t2 - img) / t3;
tmp2 = 1 - 3 * h.^2 + 2 * h.^3;      
tau(img >= t1 & img <= t2) = tmp2(img >= t1 & img <= t2);

end