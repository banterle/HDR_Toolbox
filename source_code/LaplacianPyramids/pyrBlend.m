function imgOut = pyrBlend(img1, img2, weight)
%
%
%        imgOut = pyrBlend(img1, img2, weight)
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

col = size(img1, 3);

p1 = pyrImg3(img1, @pyrLapGen);
p2 = pyrImg3(img2, @pyrLapGen);

g1 = pyrGaussGen(weight);
g2 = pyrGaussGen(1 - weight);

imgOut = zeros(size(img1));

for i=1:col
    tpg1 = pyrLst2OP(p1(i), g1,  @pyrMul);
    tpg2 = pyrLst2OP(p2(i), g2,  @pyrMul);
    tf   = pyrLst2OP(tpg1, tpg2, @pyrAdd);
    
    imgOut(:,:,i) = pyrVal(tf);
end

end