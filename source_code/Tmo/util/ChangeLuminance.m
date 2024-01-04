function imgOut = ChangeLuminance(img, Lold, Lnew, bEpsilon)
%
%       imgOut = ChangeLuminance(img, Lold, Lnew, bEpsilon)
%
%
%       Input:
%           -img: input image
%           -Lold: old luminance
%           -Lnew: new luminance
%           -bEpsilon: a boolean value to avoid division by zero, 
%                      this add e=1e-6 to Lold
%
%       Output
%           -imgOut: output image with Lnew luminance
% 
%     Copyright (C) 2013-2023  Francesco Banterle
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

if ~exist('bEpsilon', 'var')
    bEpsilon = 0;
end

if bEpsilon
    Lold = Lold + 1e-6;
end

switch col_new
    case 1
        if (col == col_new)
            imgOut = Lnew;
        else
            for i=1:col
                imgOut(:,:,i) = (img(:,:,i) .* Lnew) ./ Lold;
            end
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