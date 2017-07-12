function imgOut = tabledFunction(img, table)
%
%
%        img = tabledFunction(img, table)
%
%
%        Input:
%           -img: an LDR image with values in [0,2^nBit - 1]
%           -table: three functions for remapping image pixels values
%
%        Output:
%           -img: an LDR image with remapped values
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

col = size(img, 3);

total_values = size(table, 1);
delta = 1.0 / (total_values - 1);
x = 0 : delta : 1;
imgOut = zeros(size(img));

for i=1:col
    imgOut(:,:,i) = interp1(x, table(:, i), img(:,:,i), 'nearest', 'extrap');
end

end

%     work = zeros(size(img(:,:,i)));
%     
%     values = unique(img(:,:,i));
%     n = length(values);
%     
%     for j=1:n
%         k = values(j);    
%         work(img(:,:,i) == k) = table(k, i);
%     end
%     
%     img(:,:,i) = work;