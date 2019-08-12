function CreateHDRvFromImage(img, nameOutputDir, r, c, frames)
%
%       CreateHDRvFromImage(img, nameOutputDir, r, c, frames)
%
%       This function creates an HDR video from an input image (simple
%       panning), given two inpunt transition points (user's input by
%       mouse clicking)
%
%        Input:
%           -img: 
%           -nameOutputDir:
%           -r:
%           -c:
%           -frames:
%
%     Copyright (C) 2017  Francesco Banterle
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

if(~exist('nameOutputDir', 'var'))
    nameOutputDir = 'tmp_video';
end

if(~exist('r', 'var') || ~exist('c', 'var'))
    [r1, c1, col1] = size(img);
    
    r = round(r1 / 8);
    c = round(c1 / 8);
end

if(~exist('frames', 'var'))
    frames = 96;
end

figure(1);
imshow(img.^0.45);
hold on;

[xs, ys] = ginput(1);
plot(xs, ys, 'r+');

[xe, ye] = ginput(1);
plot(xe, ye, 'r+');

mkdir(nameOutputDir);

r_h = round(r / 2);
c_h = round(c / 2);

for i=1:frames
    
    t = (i - 1) / (frames - 1);
    xi = xe * t + (1.0 - t) * xs;
    yi = ye * t + (1.0 - t) * ys;
    xi = round(xi);
    yi = round(yi);
        
    frame = img( (yi - r_h):(yi + r_h), ...
                 (xi - c_h):(xi + c_h), ...
                 :);
    
    hdrimwrite(frame, [nameOutputDir, '/frame_', sprintf('%.10d',i), '.exr']);
end

hold off;

end
