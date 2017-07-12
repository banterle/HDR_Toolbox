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

figure(1);
imshow(img);
hold on;

[r, c, col] = size(img);

r_h = round(r / 2);
line([1, c], [r_h, r_h], 'Color', 'r', 'LineWidth', 4);

[x0, y0] = ginput(1);

plot(x0, y0, 'r+');

[x1, y1] = ginput(1);

plot(x1, y1, 'r+');

theta1 = ( (x1 - c/2) / c ) * pi;
phi1   = ( (r/2 - y1) / r ) * pi * 0.5;

vec1 = PolarVec3(theta1, phi1);

thetar1 = ( (x0 - c/2) / c ) * pi;
phir1   = ( (r/2 - y1) / r ) * pi * 0.5;

vecr1 = PolarVec3(thetar1, phir1);

sign = -1.0;
if(x0 > x1)
    sign = 1.0;
end

q = getQuaternion(cross(vec1, vecr1), sign * acos(dot(vec1, vecr1)));

M = RotationMatrixFromQuaternion(q);

D = LL2Direction(r, c);

D_rot = RotateMap(D, M);

[X1, Y1] = Direction2LL(D_rot, r, c);
[X, Y] = meshgrid(1:c, 1:r);
X1 = real(round(X1));
Y1 = real(round(Y1));
imgOut = zeros(size(img));

for i=1:col
    imgOut(:,:,i) = interp2(X, Y, img(:,:,i), X1, Y1, 'spline');
end

imshow(imgOut);
    
% [phi, theta, psi] = getEulerFromQuaternion(q);
% 
% phi = rad2grad(phi);
% theta = rad2grad(theta);
% psi = rad2grad(psi);

end


function q = getQuaternion(v, angle)

    angle = angle / 2;

	sinAngle = sin(angle);

    q = zeros(4, 1);

    q(1) = cos(angle);
    q(2) = (sinAngle * cos(v(1)));
    q(3) = (sinAngle * cos(v(2)));
    q(4) = (sinAngle * cos(v(3)));
end

function D_rot = RotateMap(D, M)
    D_rot = zeros(size(D));
    D_rot(:,:,1) = D(:,:,1) * M(1,1) + D(:,:,2) * M(2,1) + D(:,:,3) * M(3,1);
    D_rot(:,:,2) = D(:,:,1) * M(1,2) + D(:,:,2) * M(2,2) + D(:,:,3) * M(3,2);
    D_rot(:,:,3) = D(:,:,1) * M(1,3) + D(:,:,2) * M(2,3) + D(:,:,3) * M(3,3);
end

function M = RotationMatrixFromQuaternion(q)
     qx_sq = q(2) * q(2);
     qy_sq = q(3) * q(3);
     qz_sq = q(4) * q(4);

    M(1,1) = 1.0 - 2.0 * (qz_sq + qy_sq);
    M(1,2) = 2.0 * (q(2) * q(3) - q(1) * q(4));
    M(1,3) = 2.0 * (q(2) * q(4) + q(1) * q(3));

    M(2,1) = 2.0 * (q(2) * q(3) + q(1) * q(4));
    M(2,2) = 1.0 - 2.0 * (qx_sq + qz_sq);
    M(2,3) = 2.0 * (q(3) * q(4) - q(1) * q(2));

    M(3,1) = 2.0 * (q(2) * q(4) - q(1) * q(3));
    M(3,2) = 2.0 * (q(3) * q(4) + q(1) * q(2));
    M(3,3) = 1.0 - 2.0 * (qx_sq + qy_sq);
end
% 
% function g = rad2grad(r)
%     g = (r * 180) / pi;
% end
% 
% 
% function [phi, theta, psi] = getEulerFromQuaternion(q)
% 
% phi = atan2(2 * (q(1) * q(2) + q(3) * q(4)), 1 - 2 * (q(2)^2 + q(3)^2));
% 
% theta = asin(2 * (q(1) * q(3) - q(4) * q(2)));
% 
% psi = atan2(2 * (q(1) * q(4) + q(2) * q(3)), 1 - 2 * (q(3)^2 + q(4)^2)); 
% 
% end

% function M = SkewSymmetricMatrix(v)
% 
% M = zeros(3, 3);
% 
% M(1, 2) = - v(3);
% M(1, 3) =   v(2);
% 
% M(2, 1) =   v(3);
% M(2, 3) = - v(1);
% 
% M(3, 1) = - v(2);
% M(3, 2) =   v(1);
% 
% end