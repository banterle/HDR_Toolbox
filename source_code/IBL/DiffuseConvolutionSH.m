function [imgOut,SH] = DiffuseConvolutionSH(img, falloff)
%
%
%        [imgOut,SH]=DiffuseConvolutionSH(img,falloff)
%
%
%        Input:
%           -img: an environment map in the latitude-longitude mapping
%           -falloff: a flag. If it is set 1, it means that fall-off will
%                     be taken into account
%
%        Output:
%           -imgOut: a diffuse convolved version of img
%           -SH: a [3,9] vector where spherical harmonics for img are
%           encoded
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

if(~exist('falloff', 'var'))
    falloff = 0;
end

%falloff compensation
if(falloff)
    img = FallOffEnvMap(img);
end

[r,c,col]=size(img);

SH = zeros(col, 9);

%projection constants
y00 = 0.282095;
y1x = 0.488603;
y2x = 1.092548;
y20 = 0.315392;
y22 = 0.546274;

%generation of directions

[X,Y] = meshgrid(1:c, 1:r);
phi   = pi * 2 * (X / c);
theta = pi * (Y / r);
sinTheta = sin(theta);

Dx = cos(phi) .* sinTheta;
Dy = cos(theta);
Dz = sin(phi) .* sinTheta;

for i=1:col
    img(:,:,i) = img(:,:,i) .* sinTheta;
end

%Environment projection on SH
for i=1:col
    %SH 0 
    SH(i,1) = mean(mean(img(:,:,i) .* y00));
    %SH 1 -1 y
    SH(i,2) = mean(mean(img(:,:,i) .* Dy * y1x));
    %SH 1  0 z
    SH(i,3) = mean(mean(img(:,:,i) .* Dz * y1x));
    %SH 1  1 x
    SH(i,4) = mean(mean(img(:,:,i) .* Dx * y1x));
    %SH 2 -2 xy
    SH(i,5) = mean(mean(img(:,:,i) .* Dx .* Dy * y2x));
    %SH 2 -1 yz
    SH(i,6) = mean(mean(img(:,:,i) .* Dy .* Dz * y2x));
    %SH 2  1 xz
    SH(i,7) = mean(mean(img(:,:,i) .* Dx .* Dz * y2x));
    %SH 2  0 3z^2-1 
    SH(i,8) = mean(mean(img(:,:,i) .* (3 * (Dz.^2) - 1) * y20));
    %SH 2  2 x^2-y^2
    SH(i,9) = mean(mean(img(:,:,i) .* (Dx.^2 - Dy.^2) * y22));    
end

%scaling
SH = SH * pi * pi * 2;

%convolution
imgOut = EvaluationSH(SH, Dx, Dy, Dz);

end