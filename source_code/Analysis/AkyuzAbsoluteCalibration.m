function imgOut = AkyuzAbsoluteCalibration(img)
%
%       imgOut = AkyuzAbsoluteCalibration(img)
%
%
%        Input:
%           -img: a HDR image
%
%        Output:
%           -imgOut: a calibrated version of img using heuristics.
%
%     Copyright (C) 2017  Francesco Banterle
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

L = lum(img);
[key, ~] = imKey(img, 0.05);
f = 10^4 * key / MaxQuart(L, 0.95);
imgOut = img * f;

end