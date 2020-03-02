function listOfNeighbors = findNeighbors(i,r,c,tot,imgBin)
%
%
%        listOfNeighbors = findNeighbors(i,r,c,tot,imgBin)
%
%
%       Input:
%           -i:
%           -r:
%           -c:
%           -tot:
%           -imgBin: 
%
%       Output:
%           -listOfNeighbors:
% 
%     Copyright (C) 2013  Francesco Banterle
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

%Neighbors
mX = [-1, 0, 1, -1, 1, -1,  0,  1];
mY = [ 1, 1, 1,  0, 0, -1, -1, -1];

listOfNeighbors = [];

[h, w] = size(imgBin);

for k=1:tot
    for counter=1:8
        cX = c(k) + mX(counter);
        cY = r(k) + mY(counter);

        if((cY > h) || (cY < 1) || (cX > w) || (cX < 1))
            n1 = i;
        else
            n1 = imgBin(cY, cX);
        end
        
        if(n1 ~= i) %insert in the list of neighbors
            queryLV = find(listOfNeighbors == n1);
            if(min(size(queryLV)) == 0)
                listOfNeighbors = [listOfNeighbors, n1];
            end
        end
    end
end

end