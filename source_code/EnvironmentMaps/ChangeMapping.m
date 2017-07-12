function imgOut = ChangeMapping(img, mappingIn, mappingOut)
%
%        imgOut = ChangeMapping(img, mappingIn, mappingOut)
%
%
%        Input:
%           -img: an environment map encoded with mapping1
%           -mappingIn: the mapping representation of img. mapping1 is a
%                      string which takes the following values:
%                      - 'Angular'
%                      - 'LongitudeLatitude' or 'LL'
%                      - 'CubeMap'
%           -mappingOut: the desired output mapping for imgOut. This mapping
%           is a string and takes the same values of mapping1. Note that
%           the 'Spherical' is not supported yet.
%
%        Output:
%           -imgOut: img in the mapping2 format
%
%     Copyright (C) 2011-17  Francesco Banterle
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

if(strcmpi(mappingIn, 'LL') == 1)
    mappingIn = 'LongitudeLatitude';
end

if(strcmpi(mappingOut, 'LL') == 1)
    mappingOut = 'LongitudeLatitude';
end

%first step: generate directions
[r, c, col] = size(img);

if(strcmpi(mappingIn, mappingOut) == 0)
    maxCoord = max([r, c]) / 2;
    switch mappingOut
        case 'LongitudeLatitude'        
            D = LL2Direction(maxCoord, maxCoord * 2);    
        case 'Angular'
            D = Angular2Direction(maxCoord, maxCoord);
        case 'CubeMap'
            D = CubeMap2Direction(maxCoord * 4, maxCoord * 3);
        otherwise
            error([mappingOut, ' is not valid.']);
    end

    %second step: values' interpolation
    switch mappingIn
        case 'LongitudeLatitude'
            [X1,Y1] = Direction2LL(D, r, c);
        case 'Angular'
            [X1,Y1] = Direction2Angular(D, r, c);           
        case 'CubeMap'
            [X1,Y1] = Direction2CubeMap(D, r, c);
        otherwise
            error([mappingIn, ' is not valid.']);
    end
     X1 = real(round(X1));
     Y1 = real(round(Y1));
     
     X1(X1 < 1) = 1;
     Y1(Y1 < 1) = 1;

    %interpolation
    [X, Y] = meshgrid(1:c, 1:r);
    imgOut = [];    
    for i=1:col
        imgOut(:,:,i) = interp2(X, Y, img(:,:,i), X1, Y1, '*cubic');
    end

    [rM, cM, ~] = size(imgOut);
    switch mappingOut
        case 'CubeMap'
            imgOut = imgOut .* CrossMask(rM, cM);

        case 'Angular'
            imgOut = imgOut .* AngularMask(rM, cM);

        case 'Spherical'
            imgOut = imgOut .* AngularMask(rM, cM);
    end    
    imgOut = RemoveSpecials(imgOut);
    imgOut(imgOut < 0.0) = 0.0;
else %if it is the same mapping no work to be done
    imgOut = img;
end

end