function imgOut = PoissonBlending(img1, img2, mask)
%
%
%        imgOut = PoissonBlending(img1, img2, mask)
%
%        Input:
%           -img1:
%           -img2:
%           -mask:
%
%        Output:
%           -imgOut:
%
%     Copyright (C) 2016  Francesco Banterle
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
    I1 = img1 .* mask;
    I2 = img2 .* (1 - mask);

    kernelX = [0 0 0; -1 0 1; 0,  0 0];
    kernelY = [0 1 0;  0 0 0; 0, -1 0];
    G1 = struct('fx', imfilter(I1,kernelX,'same') / 2, 'fy', imfilter(I1, kernelY, 'same') / 2);
    G2 = struct('fx', imfilter(I2,kernelX,'same') / 2, 'fy', imfilter(I2, kernelY, 'same') / 2);

    kernelX = [0 0 0; -1 1 0; 0  0 0];
    kernelY = [0 0 0;  0 1 0; 0 -1 0];    
    dx1 = imfilter(G1.fx, kernelX, 'same');
    dy1 = imfilter(G1.fy, kernelY, 'same');
    dx2 = imfilter(G2.fx, kernelX, 'same');
    dy2 = imfilter(G2.fy, kernelY, 'same');
    
    divG = dx1 + dy1 + dx2 + dy2;

    imgOut = PoissonSolver(divG);
end