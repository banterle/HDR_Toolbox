function imgOut = FattalPhi(gradX, gradY, fAlpha, fBeta)
%
%       imgOut = FattalPhi(gradX, gradY, fAlpha)
%
%
%       Input:
%           -gradX:
%           -gradY:
%           -fAlpha:
%           -fBeta:
%
%       Output:
%           -imgOut: tone mapped image
%           -La: Adaptation luminance
% 
%     Copyright (C) 2010 Francesco Banterle
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

grad_mag = sqrt(gradX.^2 + gradY.^2);

t = (grad_mag.^(fBeta - 1.0)) * (fAlpha.^(1.0 - fBeta));

indx = find(t == inf);

if(~isempty(indx))
    imgOut = RemoveSpecials(t);
    imgOut(indx) = mean(imgOut(:));
else
    imgOut = t;
end

end