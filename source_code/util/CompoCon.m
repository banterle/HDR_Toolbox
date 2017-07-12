function imgLabel = CompoCon(img,type)
%
%
%       imgLabel = CompoCon(img,type)
%
%
%        Input:
%           -img: an integer grayscale image
%           -type: 4, 8: the connetion type
%
%        Output:
%           -imgLabel: labeled image
%
%     Copyright (C) 2011-2016  Francesco Banterle
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

imgLabel = zeros(size(img));

lstVal = unique(img);
n = length(lstVal);
totLabels = 0;
for i=1:n
    indx = find(img == lstVal(i));   
    if(~isempty(indx)) %binary image
        imgTmp = zeros(size(img));
        imgTmp(indx) = 1;
        imgTmp2 = bwlabel(logical(imgTmp), type);
        
        imgLabel= imgLabel + (imgTmp2 + totLabels);
        totLabels = totLabels+max(imgTmp2(:)) + 1;
    end    
end
end

