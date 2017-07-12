function pyr = ZhangDWTScaling(pyr)
%
%
%       pyr = ZhangDWTScaling(pyr)
%
%
%       Input:
%           -pyr: a DWT decomposition
%
%       Output:
%           -pyr: scaled DWT decomposition using CSF for a viewing distance
%           of one meter.
%
%     Copyright (C) 2013-2014  Francesco Banterle
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

if(length(pyr)<5)
    error('This DWT decomposition needs to have at least 5 levels!');
end

%coefficients scaling
LH = [0.561073, 0.807358, 0.869726, 0.781645, 0.655063];
HL = [0.561073, 0.807358, 0.869726, 0.781645, 0.655063];
HH = [0.316456, 0.810127, 1.000000, 0.908227, 0.743671];

for i=1:5
    pyr(i).cH = pyr(i).cH * LH(i);
    pyr(i).cV = pyr(i).cV * HL(i);
    pyr(i).cD = pyr(i).cD * HH(i);
end

end