function imgOut = blendPoisson(img1, img2, mask)
%
%
%        imgOut = blendPoisson(img1, img2, mask)
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

if(~isSameImage(img1, img2) || ~isSimilarImage(img1, weight))
   error('pyrBlend: input images are different!'); 
end

imgOut = zeros(size(img1));

for i=1:size(img1, 3)
    I1 = img1(:,:,i) .* mask;
    I2 = img2(:,:,i) .* (1 - mask);

    G1 = computeGradients(I1);
    G2 = computeGradients(I2);

    [div_I1, ~, ~] = computeDivergence(G1.fx, G1.fy);
    [div_I2, ~, ~] = computeDivergence(G2.fx, G2.fy);

    imgOut(:,:,i) = PoissonSolver(div_I1 + div_I2);
end

end