function WriteLDRStack(stack, name, format)
%
%       WriteLDRStack(dir_name, format)
%
%       This function writes an LDR stack into a set of LDR images
%
%        Input:
%           -stack: the stack to be written
%           -name: the folder name where the stack is stored.
%           -format: an LDR format for reading LDR images.
%
%        Output:
%           -exposure: a stack of exposure values from images in dir_name
%
%     Copyright (C) 2019  Francesco Banterle
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

n = size(stack, 4);

for i=1:n
    imwrite(stack(:,:,:,i), [name, '_', num2str(100000 + i), '.', format]);
end

end