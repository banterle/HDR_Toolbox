function [dyn, dynClassicLog, dynClassic] = DynamicRange(img)
%
%
%        [dyn, dynClassicLog, dynClassic] = DynamicRange(img)
%
%
%        Input:
%           -img: the input image
%
%        Output:
%           -dyn: dynamic range in base 10 Logarithm space with roboust
%           maximum and minimum values of the image
%           -dynClassicLog: dynamic range in base 10 Logarithm space with
%           maximum and minimum values of the image
%           -dynClassic: dynamic range with maximum and minimum values
%           of the image
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

L = lum(img);

dyn = log10(MaxQuart(L,0.999) / MaxQuart(L, 0.001));

dynClassic = max(L(:)) / min(L(:));

dynClassicLog = log10(dynClassic);

end