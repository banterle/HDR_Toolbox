function [imgOut, exposure_value] = BestExposureTMO(img, type)
%
%        imgOut = BestExposureTMO(img)
%
%       
%        Simple TMO, which divides an image by the best exposure
%
%        Input:
%           -img: input HDR image
%           -type: 
%               -'histogram' using histogram sampling
%               -'mean' using mean on luminance
%
%        Output:
%           -imgOut: a tone mapped image
%           -exposure_value: the exposure value set
% 
%     Copyright (C) 2010-15 Francesco Banterle
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

if(~exist('type', 'var'))
   type = 'histogram';
end

check13Color(img);
checkNegative(img);
exposure_value  = 1.0;

switch type
    case 'histogram'
        fstops = ExposureHistogramSampling(img, 8, 0);
        exposure_value = 2^fstops(1);
        
    case 'mean'
        L = lum(img);
        L_mean = mean(L(:));
        if L_mean > 0.0
            exposure_value = 1.0 / (4.0 * L_mean);
        else
            exposure_value = 1.0;
        end
end

imgOut = ClampImg(img * exposure_value, 0.0, 1.0);

end
