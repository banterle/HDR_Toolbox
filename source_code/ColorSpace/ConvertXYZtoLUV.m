function imgOut = ConvertXYZtoLUV(img, inverse, conv_whitePoint)
%
%       imgOut = ConvertXYZtoLUV(img, inverse, conv_whitePoint)
%
%
%        Input:
%           -img: image to convert from XYZ to Luv or from Luv to XYZ
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from XYZ to Luv is applied, otherwise
%                     the transformation from Luv to XYZ
%           -conv_whitePoint: the white point in XYZ coordiantes
%
%        Output:
%           -imgOut: converted image in Luv if inverse = 0, otherwise XYZ
%
%     Copyright (C) 2013  Francesco Banterle
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

check3Color(img);
[r,c,col] = size(img);
imgOut = zeros(r,c,col);

if(~exist('conv_whitePoint', 'var'))
    conv_whitePoint = [1,1,1];
end

coeff = [1, 15, 3];

n_norm = conv_whitePoint * (coeff');

U_n_prime = 4 * conv_whitePoint(1) / n_norm;
V_n_prime = 9 * conv_whitePoint(2) / n_norm;

if(inverse == 0)%forward transform
    c1 = (6/29)^3;
    c2 = (29/3)^3;  
   
    %L channel
    Y_scaled = img(:,:,2)/conv_whitePoint(2);
    L_star = zeros(size(Y_scaled));
    L_star(Y_scaled <= c1) = Y_scaled(Y_scaled <= c1) * c2;
    L_star(Y_scaled> c1) = 116 * Y_scaled(Y_scaled> c1).^(1/3) - 16;
    
    imgOut(:,:,1) = L_star;

    norm = img(:,:,1) + 15 * img(:,:,2) + 3 * img(:,:,3);
    
    %U channel
    U_prime = 4 * img(:,:,1) ./ norm;
    imgOut(:,:,2) = 13 * L_star .* (U_prime - U_n_prime);
    
    %V channel
    V_prime = 9 * img(:,:,2) ./ norm;
    imgOut(:,:,3) = 13 * L_star .* (V_prime - V_n_prime);   
end

if(inverse == 1)%inverse transform
    c1 = (3/29)^3;
    
    U_prime = img(:,:,2) ./ (13 * img(:,:,1)) + U_n_prime;
    V_prime = img(:,:,3) ./ (13 * img(:,:,1)) + V_n_prime;
    
    L_star = img(:,:,1);
    Y = zeros(size(L_star));
    Y(L_star<=8) = L_star(L_star<=8)*c1;
    Y(L_star> 8) = ((L_star(L_star> 8)+16)/116).^3;
    imgOut(:,:,2) = Y*conv_whitePoint(1);
    
    imgOut(:,:,1) = imgOut(:,:,2).*((9*U_prime)./(4.0*V_prime));
    imgOut(:,:,3) = imgOut(:,:,2).*((12-3*U_prime-20*V_prime)./(4*V_prime));    
end

imgOut = RemoveSpecials(imgOut);

end
