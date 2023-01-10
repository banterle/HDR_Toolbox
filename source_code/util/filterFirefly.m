function imgOut = filterFirefly(img, maxIter)
%
%
%       imgOut = filterFirefly(img, maxIter)
%
%
%       Input:
%           -img: the input image with Inf/NaN values
%           -maxIter: the maximum number of iterations
%
%       Output:
%           -imgOut: a filtered image without Inf/NaN values
%
%
%     Copyright (C) 2022 Francesco Banterle
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

if ~exist('maxIter', 'var')
   maxIter = 16; 
end

imgOut = img;
bFlag = ~isempty(find(isnan(imgOut) | isinf(imgOut)));
col = size(img, 3);

counter = 0;

while bFlag
    disp('Fireflies detected');    
    for i=1:col
        imgOut_i = imgOut(:,:,i);
        [y, x] = find(isnan(imgOut_i) | isinf(imgOut_i));
    
        if ~isempty(y)
            imgOut_i_flt = medfilt2(imgOut_i, [3, 3]);
            
            for j=1:length(y)
                imgOut_i(y(j), x(j)) = imgOut_i_flt(y(j), x(j));
            end
            
        end
        imgOut(:,:,i) = imgOut_i;
    end
    
    counter = counter + 1;
    
    if counter > maxIter
        bFlag = 0;
    else
        bFlag = ~isempty(find(isnan(imgOut) | isinf(imgOut)));
    end    
end

bFlag = ~isempty(find(isnan(imgOut) | isinf(imgOut)));
if bFlag
    warning('filterFirefly: exceeded maximum iterations and specials are still present');
    imgOut = RemoveSpecials(imgOut);
end

end