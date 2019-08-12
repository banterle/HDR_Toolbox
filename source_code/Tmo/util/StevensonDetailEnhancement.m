function detail_layer_out = StevensonDetailEnhancement(detail_layer, F_L)
%
%       detail_layer_out = StevensonDetailEnhancement(detail_layer, F_L)
%
%       This function adjusts the detail layer for taking into account the
%       Stevenson effect.
%
%       input:
%           -detail_layer: the detail layer of an image
%           -F_L: a luminance dependent factor
%
%       output:
%           -detail_layer_out: processed detail layer
%
%     Copyright (C) 2014-15  Francesco Banterle
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

exponent = (F_L + 0.8).^0.25;

[~, ~, col] = size(detail_layer);

detail_layer_out = zeros(size(detail_layer));

for i=1:col
    detail_layer_out(:,:,i) = detail_layer(:,:,i).^exponent;
end

end