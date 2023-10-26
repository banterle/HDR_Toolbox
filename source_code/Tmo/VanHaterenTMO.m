function imgOut = VanHaterenTMO(img, pupil_area, bWarning)
%
%
%        imgOut = VanHaterenTMO(img, pupil_area, bWarning)
%
%
%        Input:
%           -img: input HDR image
%           -pupil_area:
%
%        Output:
%           -imgOut: tone mapped image
%
%     This is the stable version of the Van Hateren 2006 algorithm, this is
%     not suitable for HDR videos.
% 
%     Copyright (C) 2010-17  Francesco Banterle
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
%     The paper describing this technique is:
%     "Encoding of High Dynamic Range Video with a Model of Human Cones"
% 	  by J. Hans Van Hateren
%     in ACM Transaction on Graphics 2006
%

if ~exist('bWarning', 'var')
    bWarning = 1;
end

check13Color(img);

checkNegative(img);

if(~exist('pupil_area', 'var'))
    pupil_area = -1.0;
end

if(pupil_area <= 0.0)
    pupil_area = 10; %fixed pupil area 10 mm^2
end

k_beta = 1.6e-4; % td/ms
a_C = 9e-2;
C_beta = 2.8e-3; % 1/ms

%Calculate Ios,max
polIosMax = [a_C, 1, 0, 0, 0, -1 / C_beta];
maxIos = max(real(roots(polIosMax)));

%Luminance channel
Lori = lum(img);

%conversion from cd/m^2 to trolands (tr)
L = Lori * pupil_area;

%Range reduction
tmpI = - 1 ./ (C_beta + k_beta * L);
[r, c] = size(L);
n = r * c;
Ios = zeros(size(tmpI));
base = [a_C, 1, 0, 0, 0];

for i = 1:n
    tmp = [base, tmpI(i)];
    Ios(i) = max(real(roots(tmp)));
end

Ld = ClampImg(1 - Ios / maxIos, 0, 1);

%Changing luminance
imgOut = ChangeLuminance(img, Lori, Ld);

if bWarning
    warning('The image does not require gamma correction.');
end

end