function Ft = CIELabFunction(t, inverse)
%
%       Ft = CIELabFunction(t, inverse)
%
%
%        Input:
%           -t: image
%           -inverse: takes as values 0 or 1. If it is set to 1 the
%                     transformation from XYZ to CIE Lab is applied, otherwise
%                     the transformation from CIE Lab to XYZ
%
%        Output:
%           -Ft: application of CIE Lab f or f^{-1} (if inverse = 1) to X
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

if(inverse == 0) %forward function
    Ft = zeros(size(t));
    
    c1 = (6 / 29)^3;
    c2 = ((29 / 6)^2)/3;
    c3 = 4 / 29;
    
    Ft(t >  c1) = t(t >  c1).^(1 / 3);
    Ft(t <= c1) = t(t <= c1) * c2 + c3;
end

if(inverse == 1) %inverse function
    Ft = zeros(size(t));

    c1 = 6 / 29;
    c2 = ((6 / 29)^2) * 3;
    c3 = 4 / 29;
    
    Ft(t >  c1) =  t(t >  c1).^3;
    Ft(t <= c1) = (t(t <= c1) - c3) * c2;   
end

end
