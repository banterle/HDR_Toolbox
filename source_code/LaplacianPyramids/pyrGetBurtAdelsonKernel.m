function mtx = pyrGetBurtAdelsonKernel(burt_a)
%
%
%        mtx = pyrGetBurtAdelsonKernel(burt_a)
%
%
%        Input:
%           -burt_a: kernel a value
%
%        Output:
%           -mtx: the output kernel
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

if(~exist('burt_a', 'var'))
    burt_a = 0.4;
end

burt_c = 1/4 - burt_a/2;
kernel_1D = [burt_c, 1/4, burt_a, 1/4, burt_c];

% 2-D separable kernel
mtx = kernel_1D' * kernel_1D;

end