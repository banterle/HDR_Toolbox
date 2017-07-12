function pOut = pyrAdd(pA, pB)
%
%
%        pOut = pyrAdd(pA, pB)
%
%
%        Input:
%           -pA: an image pyramid
%           -pB: an image pyramid
%
%        Output:
%           -pOut: the result of adding pA and pB
%
%     Copyright (C) 2011  Francesco Banterle
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

%checking lenght of the pyramids
nA = length(pA.list);
nB = length(pA.list);

if(nA ~= nB)
    error('pyrAdd error: pA and pB are different size pyramids.');
end

%adding base levels
pOut.base = pA.base + pB.base;
pOut.list = pA.list;

%adding the detail of each level
for i=1:nA
    pOut.list(i).detail = pA.list(i).detail + pB.list(i).detail;
end

end