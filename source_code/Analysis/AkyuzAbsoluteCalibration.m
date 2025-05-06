function [imgOut, f] = AkyuzAbsoluteCalibration(img)
%
%       [imgOut, f] = AkyuzAbsoluteCalibration(img)
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
percentile = 0.001;

[key, ~] = imKey(img, percentile);

max_L = MaxQuart(L, 1 - percentile);

if (max_L > 0.0) && (key > 0.0)
    f = 10^4 * key / max_L;
else
    f = 1.0;
end

imgOut = img * f;

end