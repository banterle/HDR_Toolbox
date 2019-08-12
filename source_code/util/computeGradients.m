function I_g = computeGradients(I)
%
%
%       I_g = computeGradients(I)
%
%       Input:
%           -I: an input image
%
%       Output:
%           -I_g: gradients of I
%
%     Copyright (C) 2011-18  Francesco Banterle
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

kernelX = [0, 0, 0; -1, 0, 1; 0,  0, 0];
kernelY = [0, 1, 0;  0, 0, 0; 0, -1, 0];

I_gx = imfilter(I, kernelX, 'same') / 2;
I_gy = imfilter(I, kernelY, 'same') / 2;

I_g = struct('fx', I_gx, 'fy', I_gy);

end