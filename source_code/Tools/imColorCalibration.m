function [img1Out, color_matrix] = imColorCalibration(img1, img2)
%
%     [img2Out, color_matrix] = imColorCalibration(img1, img2)
%
%     This functions crops an HDR image.
%
%     Input:
%       -img1: a target input image
%       -img2: a source input image
%
%     Output:
%       -img1Out: an output image
%       -color_matrix:
%
%
%     Copyright (C) 2018 Francesco Banterle
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

img1Out = [];
color_matrix = eye(3);

patchSize = 3;
    
img = [img1 img2];
img = imresize(img, 0.25, 'bilinear');

hf = figure(4001);
imshow(img);
hold on;

button = 0;
color1 = [];
color2 = [];

i = 1;
while(button ~= 3)
    [x, y, button] = ginput(1);
    x = round(x);
    y = round(y);

    tmp_color = mean(mean(img( (y - patchSize):(y + patchSize), (x - patchSize):(x + patchSize), :)));

    tmp_color = reshape(tmp_color, 1, 3);
    
    if(button ~= 3)
        if(mod(i, 2) == 1)
            disp('i');
            color1 = [color1; tmp_color];
            plot(x, y, 'g+');
        else
            color2 = [color2; tmp_color];
            plot(x, y, 'ro');
        end
    end
    
    i = i + 1;
end
close(hf);

[n, colors] = size(color1);
A = [];
b = [];
for i=1:n
    tmp_A = [color1(i, 1), color1(i, 2), color1(i, 3), 0, 0, 0, 0, 0, 0];
    A = [A; tmp_A];
    b = [b; color2(i, 1)];
    
    tmp_A = [0, 0, 0, color1(i, 1), color1(i, 2), color1(i, 3), 0, 0, 0];
    A = [A; tmp_A];
    b = [b; color2(i, 2)];
    
    tmp_A = [0, 0, 0, 0, 0, 0, color1(i, 1), color1(i, 2), color1(i, 3)];
    A = [A; tmp_A];
    b = [b; color2(i, 2)];        
end

color_matrix = linsolve(A, b);

color_matrix = reshape(color_matrix, 3, 3)';

img1Out = img1;

for i=1:3
    img1Out(:,:,i) = color_matrix(i, 1) * img1(:,:,1) + ...
                     color_matrix(i, 2) * img1(:,:,2) + ...
                     color_matrix(i, 3) * img1(:,:,3);
end

end
