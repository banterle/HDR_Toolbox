function imgOut = ChangeLuminance(img, Lold, Lnew)
%
%       imgOut = ChangeLuminance(img, Lold, Lnew)
%
%
%       Input:
%           -img: input image
%           -Lold: old luminance
%           -Lnew: new luminance
%
%       Output
%           -imgOut: output image with Lnew luminance
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

%Removing the old luminance
col = size(img, 3);
col_new = size(Lnew, 3);

imgOut = zeros(size(img));

switch col_new
    case 1
        for i=1:col
            imgOut(:,:,i) = (img(:,:,i) .* Lnew) ./ Lold;
        end
        
    case 3
        if(col == col_new)%same color channels
            for i=1:col
                imgOut(:,:,i) = (img(:,:,i) .* Lnew(:,:,i)) ./ Lold;
            end    
        else
            Lnew = lum(Lnew);
            for i=1:col
                imgOut(:,:,i) = (img(:,:,i) .* Lnew) ./ Lold;
            end             
        end
        
    otherwise
        Lnew = lum(Lnew);

        for i=1:col
            imgOut(:,:,i) = (img(:,:,i) .* Lnew) ./ Lold;
        end            
end

imgOut = RemoveSpecials(imgOut);

end