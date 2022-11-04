function g = findBestGammaAsCRF(img0, img1, exposure0, exposure1)
%
%       g = findBestGammaAsCRF(img0, img1, exposure0, exposure1)
%
%       This function computes the best gamma paramters for RGB that approximate
%       the camera response function.
%
%        Input:
%           -img0: an SDR image
%           -img1: an SDR image
%           -exposure0: the shutter speed of img0
%           -exposure1: the shutter speed of img1
%
%        Output:
%           -lin_fun: the inverse CRF
%           -max_lin_fun: maximum value of the inverse CRF
%
%     Copyright (C) 2014-15  Francesco Banterle
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

delta_exposure = exposure1 / exposure0;
mask = ones(size(img0));
mask(img0>0.95) = 0.0;
mask(img1>0.95) = 0.0;
mask(img0<0.05) = 0.0;
mask(img1<0.05) = 0.0;

    function err = residualFunction(p)
        err = 0.0;
        for i=1:3
            gt = p(i);
            img0_lin(:,:,i) = (img0(:,:,i).^gt);
            img0_re(:,:,i) = img0_lin(:,:,i) * delta_exposure;
            img0_re(:,:,i) = img0_re(:,:,i).^(1.0/gt);
        
            delta = abs(img0_re(:,:,i) - img1(:,:,i)) .* mask(:,:,i);
            err = err + mean(delta(:));
        end
    end

    opts = optimset('Display', 'iter', 'TolFun', 1e-12, 'TolX', 1e-12, 'MaxIter', 1000);
    gi = 2.2 * ones(1,3);
    g = fminsearch(@residualFunction, gi, opts);
    for i=1:3
        img0_lin(:,:,i) = (img0(:,:,i).^g(i));
        img0_re(:,:,i) = img0_lin(:,:,i) * delta_exposure;
        img0_re(:,:,i) = img0_re(:,:,i).^(1.0/g(i));
    end    
    
    imshow([img0, img0_re, img1]);
    
end