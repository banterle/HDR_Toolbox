function imgOut = ApplyCRF(img, lin_type, lin_fun)
%
%
%        img = ApplyCRF(img, table)
%
%
%        Input:
%           -img: an LDR image with values in [0,1]
%           -table: three functions for remapping image pixels values
%
%        Output:
%           -imgOut: an LDR image with with values in [0interp1(x, table(:, i), img(:,:,i), 'nearest', 'extrap');,2^nBit - 1]
%
%     Copyright (C) 2011-15  Francesco Banterle
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

if(~exist('lin_type', 'var'))
    lin_type = 'gamma';
    lin_fun = 2.2;    
end

if(~exist('lin_fun', 'var') & (strcmp(lin_type, 'sRGB') ~= 1) )
    error('ApplyCRF does not have enough data');
end

if(strcmp(lin_type, 'poly') == 1)
    col = size(lin_fun, 2);
    x = (0:255) / 255;
    
    lin_fun_tmp = zeros(256, col);
    
    for c=1:col
       y = polyval(lin_fun(:,c), x);       
       lin_fun_tmp(:,c) = interp1(y, x, x, 'linear', 'extrap');
    end
    lin_fun = lin_fun_tmp;
    lin_type = 'LUT';
end
            
switch lin_type
    case 'gamma'
        inv_gamma = 1.0 / lin_fun;
        imgOut = img.^inv_gamma;

    case 'sRGB'
        imgOut = ConvertRGBtosRGB(img, 0);

    case 'LUT'
         imgOut = tabledFunction(img, lin_fun);
        
    otherwise
        imgOut = img;
end

end