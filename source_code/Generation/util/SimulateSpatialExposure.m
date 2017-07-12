function imgOut = SimulateSpatialExposure(img, fstops)
%
%       imgOut = SimulateSpatialExposure(img, fstops)
%
%
%        Input:
%           -img: an HDR image
%
%        Output:
%           -imgOut:
%
%     Copyright (C) 2016  Francesco Banterle
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
%

exposure_times = 2.^fstops;

if(length(exposure_times) > 4)
    exposure_times = exposure_times(1:4);
else
    if(length(exposure_times) < 4)
        error('Missing required exposures!');
    end
end

imgOut = zeros(size(img));
imgOut(1:2:end,1:2:end,:) = exposure_times(1) * img(1:2:end, 1:2:end, :);
imgOut(1:2:end,2:2:end,:) = exposure_times(2) * img(1:2:end, 2:2:end, :);
imgOut(2:2:end,1:2:end,:) = exposure_times(3) * img(2:2:end, 1:2:end, :);
imgOut(2:2:end,2:2:end,:) = exposure_times(4) * img(2:2:end, 2:2:end, :);

imgOut = ClampImg(imgOut.^(1.0/2.2), 0.0, 1.0);

end

