function [out, exposure_value] = estimateExposureAtGivenSaturationLevel(img, percentage)
%
%       [out, exposure_value] = estimateExposureAtGivenSaturationLevel(img, percentage)
%
%       This function estimates a homography matrix from p1 to p2.
%
%        Input:
%           -img: an input HDR image.
%           -percentage: the percentage of over-exposed pixel.
%
%        Output:
%           -out: img at 'exposure_level' with gamma correction 2.2 and
%           values in [0,1].
%           -exposure_level: exposure level to have a given 'percentage' of
%           over-exposed pixels.
%
%     Copyright (C) 2026  Francesco Banterle
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

if (percentage > 1)
    percentage = percentage / 100;
end

if (percentage < 0)
    percentage = 0;
end

if (percentage > 1.0)
    percentage = 1;
end

[~, exposure_value_start] = BestExposureTMO(img);

opts = optimset('TolFun', 1e-8, 'TolX', 1e-8, 'MaxIter', 300, 'MaxFunEvals', 3000);

    function err = residual(exposure_value_res)
        img_out = round(255 * ClampImg((img * exposure_value_res).^(1.0/2.2), 0.0, 1.0)) / 255;      

        percentage_res = length(find(img_out >= 0.99)) / numel(img);

        err = abs(percentage_res - percentage);

        if exposure_value_res < 0.0
            err = 1e6;
        end
    end

exposure_value = fminsearch(@residual, [exposure_value_start], opts);

out = round(ClampImg((img * exposure_value).^(1.0/2.2), 0.0, 1.0) * 255)/255;

percent = length(find(out >= 0.99)) / numel(img);
disp([exposure_value_start, exposure_value, percent]);

end