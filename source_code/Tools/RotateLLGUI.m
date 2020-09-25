function imgOut = RotateLLGUI(img)
%
%        imgOut = RotateLLGUI(img)
%
%        This tool rotates an environment map according to two picking
%        points.
%
%        Input:
%           -img: an environment map encoded as logitude-latitude
%
%        Output:
%           -imgOut: img rotated 
%
%     Copyright (C) 2016 Francesco Banterle
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


if(size(img, 2) > 2048)
   img = imresize(img, [2048, 1024], 'bilinear');
end

[r, c, col] = size(img);

figure(1);
imshow(img.^0.45);
hold on;

r_h = round(r / 2);
line([1, c], [r_h, r_h], 'Color', 'r', 'LineWidth', 4);

[x0, y0] = ginput(1);

plot(x0, y0, 'r+');

[x1, y1] = ginput(1);

plot(x1, y1, 'r+');
hold off;

%theta1 = ( (x1 - c/2) / c ) * pi;
%phi1   = ( (r/2 - y1) / r ) * pi * 0.5;

[theta1, phi1] = getThetaPhi(x1,y1,r,c);
vec1 = PolarVec3(theta1, phi1);

%thetar1 = ( (x0 - c/2) / c ) * pi;
%phir1   = ( (r/2 - y1) / r ) * pi * 0.5;
[thetar1, phir1] = getThetaPhi(x0,y1,r,c);
vecr1 = PolarVec3(thetar1, phir1);

M = getMatrixForVectorRotation(vec1, vecr1);

disp(M)
% disp(vec1);
% disp(vecr1);
% disp((M*vec1')');

D = LL2Direction(r, c);
D_rot = RotateMap(D, M');

[X1, Y1] = Direction2LL(D_rot, r, c);
[X, Y] = meshgrid(0:(c-1), 0:(r-1));
X1 = real(round(X1));
Y1 = real(round(Y1));
imgOut = zeros(size(img));
size(X)
size(X1)
for i=1:col
    imgOut(:,:,i) = interp2(X, Y, img(:,:,i), X1, Y1, 'spline');
end

hold on;
imshow(imgOut.^0.45);
plot([x0, x1], [y0, y1], 'r');
plot(x0, y0, 'go');
plot(x1, y1, 'go');
hold off;

end

function [theta, phi] = getThetaPhi(x,y,r,c)
    phi   =  pi * ((x / c) * 2 - 1) - pi * 0.5;
    theta =  pi * (y / r);
end

function M = getMatrixForVectorRotation(u, v)
    a = cross(u, v);
    len_a = norm(a);
    if(len_a > 0.0)
        a = a / len_a;

        alpha = acos(dot(u, v));
        c = cos(alpha);
        s = sin(alpha);

        ci = 1.0 - c;

        M = [a(1)^2*ci + c, a(1)*a(2)*ci - s * a(3), a(1)*a(3)*ci+s*a(2);...
             a(1)*a(2) * ci + s * a(3), a(2)^2 * ci + c, a(2)*a(3)*ci-s*a(1);...
             a(1)*a(3) * ci - s*a(2), a(1)*a(3)*ci+s*a(1), a(3)^2 * ci + c];    
    else
        M = diag([1.0,1.0,1.0]);
    end
end

function D_rot = RotateMap(D, M)
    D_rot = zeros(size(D));
    D_rot(:,:,1) = D(:,:,1) * M(1,1) + D(:,:,2) * M(1,2) + D(:,:,3) * M(1,3);
    D_rot(:,:,2) = D(:,:,1) * M(2,1) + D(:,:,2) * M(2,2) + D(:,:,3) * M(2,3);
    D_rot(:,:,3) = D(:,:,1) * M(3,1) + D(:,:,2) * M(3,2) + D(:,:,3) * M(3,3);
end
