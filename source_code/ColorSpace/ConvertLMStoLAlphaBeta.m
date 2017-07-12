function imgOut = ConvertLMStoLAlphaBeta(img, inverse)
%
%       imgOut = ConvertLMStoLAlphaBeta(img, inverse)
%
%
%        Input:
%           -img: image to convert from LMS to l-alpha-beta or from l-alpha-beta to LMS.
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from LMS to l-alpha-beta is applied,
%                     otherwise the transformation from l-alpha-beta to LMS.
%
%        Output:
%           -imgOut: converted image in LMS or l-alpha-beta
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

if(inverse == 1)
    mtx1 = diag([sqrt(3)/3, sqrt(6)/6, sqrt(2)/2]);
    mtx2 = [1 1 1; 1 1 -2; 1 -1 0];
    mtx  = mtx1 * mtx2;
    
    imgOut = 10.^(ConvertLinearSpace(img, mtx) - 0.001);
    
else

if(inverse == 0)
    mtx1 = [1 1 1; 1 1 -1; 1 -2 0];
    mtx2 = diag([1/sqrt(3), 1/sqrt(6), 1/sqrt(2)]);
    mtx  = mtx1 * mtx2;
    imgOut = ConvertLinearSpace(log10(img + 0.001), mtx);
end
            
end