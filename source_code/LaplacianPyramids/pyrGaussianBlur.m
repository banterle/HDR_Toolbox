function pOut=pyrGaussianBlur(pA,kernelSize)
%
%
%        pOut=pyrMul(pA,kernelSize)
%
%
%        Input:
%           -pA: an image pyramid
%           -kernelSize: kernel size of the Gaussian blur
%
%        Output:
%           -pOut: the result of multiplying pA and pB
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

%multiplying base levels
pOut.base = filterGaussianWindow(pA.base, kernelSize);
pOut.list = pA.list;

%multiplying the detail of each level
for i=1:length(pA.list)
    pOut.list(i).detail = filterGaussianWindow(pA.list(i).detail, kernelSize);
end

end