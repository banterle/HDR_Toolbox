function imgOut = pyrBlendHDR(img1, img2, weight)
%
%
%        imgOut = pyrBlendHDR(img1, img2, weight)
%
%
%        Input:
%           -img1: an image to be blended
%           -img2: an image to be blended
%           -weight: the weights for img1
%
%        Output:
%           -imgOut: the final blended image
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

% img1 = img1 ./ (1.0 + img1);
% img2 = img2 ./ (1.0 + img2);

gamma_inv = 1.0 / 2.2;

img1 = img1.^gamma_inv;
img2 = img2.^gamma_inv;

imgOut = pyrBlend(img1, img2, weight);

imgOut = imgOut.^2.2;

%imgOut = imgOut ./ (1.0 - imgOut);

end