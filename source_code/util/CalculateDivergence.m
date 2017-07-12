function [divI, I_dx, I_dy] = CalculateDivergence(I_gx, I_gy)
%
%
%       [divI, I_dx, I_dy] = CalculateDivergence(I_gx, I_gy)
%
%       Input:
%           -I_gx: an input image
%           -I_gx
%
%       Output:
%           -I_dx:
%           -I_dy: 
%           -divI: 
%
%     Copyright (C) 2011-15  Francesco Banterle
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

if(~exist('I_gx', 'var') || ~exist('I_gy', 'var'))
    error('Gradients are needed to compute divergence');
end

kernelX = [0,0,0; -1,1,0;  0, 0,0];
kernelY = [0,0,0;  0,1,0;  0,-1,0];

I_dx = imfilter(I_gx, kernelX, 'same');
I_dy = imfilter(I_gy, kernelY, 'same');

divI = RemoveSpecials(I_dx + I_dy);

end