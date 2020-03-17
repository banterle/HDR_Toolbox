function value = imDynamicRange(img, bRobust, type)
%
%
%        value = imDynamicRange(img, bRobust, type)
%
%
%        Input:
%           -img: the input image
%           -bRobust: if bRobust > 0 --> robust statistics for min and max 
%                     luminance values. bRboust becomes the percentile!
%           -type: 'Classic', 'Michelson', and 'Weber' 
%
%        Output:
%           -value(1): dynamic range of img
%           -value(2): dynamic range of img in f-stops (if 'Classic')
%           -value(3): dynamic range of img in log10 space space (if
%           'Classic')
%
%     Copyright (C) 2011-20  Francesco Banterle
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

if(~exist('bRobust', 'var'))
    bRobust = 0;
end

if(~exist('type', 'var'))
    type = 'Classic';
end

if(bRobust >= 0.5)
   bRobust = 0.01; 
end

L = lum(img);

if(bRobust > 0.0)
    minL = MaxQuart(L, bRobust);
    maxL = MaxQuart(L, 1 - bRobust);
else
    minL = min(L(:));
    maxL = max(L(:));
end

if(minL < 1e-6)
    warning('minL is less than 1e-6 cd/m^2');
end

if(minL <= 0.0)
    warning('minL is 0.0 is set to the first value greater than zero.');

    minL = min(min(L(L > 0)));
end

switch type
    
    case 'Classic'
        value(1) = maxL / minL;    
        value(2) = log2(value(1));
        value(3) = log10(value(1));      
        
    case 'Michelson'
        value = (maxL - minL) / (maxL + minL);
        
    case 'Weber'
        value = (maxL - minL) / minL;
end

end