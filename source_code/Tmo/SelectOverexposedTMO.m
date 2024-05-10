function [imgOut, exposure_value] = SelectOverexposedTMO(img, percent)
%
%        [imgOut, exposure_value] = SelectOverexposedTMO(img, percent)
%
%       
%        A simple TMO that generates an SDR image with a given percentage
%        of overexposed pixels.
%
%        Input:
%           -img: input HDR image
%           -percent: percentage of overexposed pixels.
%
%        Output:
%           -imgOut: a single exposure with the selected percentage of
%           overexposed pixels. 
%
%
% 
%     Copyright (C) 2022 Francesco Banterle
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

if ~exist('percent', 'var')
    percent = 0.1;
end

gamma_inv = 1.0 / 2.2;

    function err = residual(c)    
        
        if c > 0.0
            tmp = ClampImg((img * c).^gamma_inv, 0.0, 1.0); 
            L = lum(tmp);
            tmp_percent = length(find(L >= 0.95)) / numel(L);
        
            err = abs(tmp_percent - percent);
        else
            err = 1e9;
        end
    end

exposure_start = 1.0;
opts = optimset('Display','iter','TolFun', 1e-9, 'TolX', 1e-9, 'MaxIter', 200, 'MaxFunEvals', 2000);

exposure_value = fminsearch(@residual, exposure_start, opts);

imgOut = ClampImg(img * exposure_value, 0.0, 1.0);

end
