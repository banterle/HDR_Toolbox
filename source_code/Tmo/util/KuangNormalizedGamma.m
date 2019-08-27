function imgOut = KuangNormalizedGamma(img, gamma_value)
%
%
%       img = KuangNormalizedGamma(img, gamma_value)
%
%
%       Image is clamped if its values are over [a,b]
%
%       Input:
%           -img: the input img to be clamped.
%           -gamma_value: a gamma value to be applied to img.
%           
%       Output:
%           -imgOut: an image with normalized gamma encoding.
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

if(~exist('gamma_value', 'var'))
    gamma_value = 1.0;
end

max_img = max(img(:));

imgOut = ((img / max_img).^gamma_value) * max_img;

end
