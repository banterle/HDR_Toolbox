function img=RGBE2float(imgRGBE)
%
%       imgRGBE=RGBE2float(img)
%
%
%        Input:
%           -img: a HDR image encoded using the RGBE format
%
%        Output:
%           -imgRGBE: the HDR image in RGB single float format
%
%     Copyright (C) 2011  Francesco Banterle
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

[m,n,c] = size(imgRGBE);

if(c~=4)
    error('imgRGBE needs to have four color channel.');
end

img = zeros(m,n,3);

E = double(imgRGBE(:,:,4) - 128 - 8);
f = 2.^E;
f(imgRGBE(:,:,4)==0)=0;

for i=1:3
    %note that this + 0.5 is for being compliant with Greg Ward code
    img(:,:,i) = double(imgRGBE(:,:,i) + 0.5) .* f;
end

end
