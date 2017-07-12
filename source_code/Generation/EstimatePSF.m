function [PSF, C, hot_pixels_pos] = EstimatePSF( img )
%
%       [PSF, C] = EstimatePSF( img )
%
%       This function estimates the point spread function (PSF) of a camera
%       from a single HDR image.
%
%        Input:
%           -img: an HDR image
%
%        Output:
%           -PSF: the estimated point spread function as a kernel
%           -C: the estimated point spread function as polynomial
%           -hot_pixels_pos: hot pixels' coordinates
%
%     Copyright (C) 2014  Francesco Banterle
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
%

[r, c, ~] = size(img);

Icr = imresize(img, [round(r * 256 / c), 256], 'bilinear');

Igr = lum(Icr); 

min_values = Igr(Igr > 0.0);

if(isempty(min_values))
    error('PSF cannot be estimated');
end

thr = min([1000.0 * min(min_values), MaxQuart(Igr, 0.1)]);

%getting hot pixels' positions
[y_h, x_h] = find(Igr > thr);

%getting dark pixels' positions
[y_d, x_d] = find(Igr <= thr);

m = length(y_h);
n = length(y_d);
A = zeros(n, 4);

tot = sum(Igr(Igr > thr));

for i=1:length(y_d)
   A(i, 1) = tot;
   
   for j=1:m
       r2 = (x_h(j) - x_d(i)).^2 + (y_h(j) - y_d(i)).^2;
       r  = sqrt(r2);
       
       if(r >= 3) 
           P_j = Igr(y_h(j), x_h(j));

           A(i, 2) = A(i, 2) + P_j / r;
           A(i, 3) = A(i, 3) + P_j / r2;
           A(i, 4) = A(i, 4) + P_j / (r2 * r);
       end
   end
end

b = Igr(Igr <= thr);

C = A\b;

[x, y] = meshgrid(1:33, 1:33);
x = x - 16;
y = y - 16;
r = max(sqrt(x.^2 + y.^2), 2);
PSF = C(1) + C(2)./r + C(3)./(r.^2) + C(4)./(r.^3);

hot_pixels_pos = [x_h'; y_h'];

end