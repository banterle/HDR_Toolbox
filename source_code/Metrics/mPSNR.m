function [mpsnr, eMax, eMin] = mPSNR(img_ref, img_dist, eMin, eMax)
%
%
%      [mpsnr, eMax, eMin] = mPSNR(img_ref, img_dist, eMin, eMax)
%
%
%       Input:
%           -img_ref: input reference image
%           -img_dist: input distorted image
%           -eMin: the minimum exposure for computing mPSNR. If not given it is
%           automatically inferred.
%           -eMax: the maximum exposure for computing mPSNR. If not given it is
%           automatically inferred.
%
%       Output:
%           -mpsnr: the multiple-exposure PSNR value. Higher values means
%           better quality.
%           -eMax: the maximum exposure for computing mPSNR
%           -eMin: the minimum exposure for computing mPSNR
% 
%     Copyright (C) 2006-2015  Francesco Banterle
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

if(isSameImage(img_ref, img_dist) == 0)
    error('The two images are different they can not be used or there are more than one channel.');
end

checkNegative(img_ref);
checkNegative(img_dist);

if(~exist('eMin', 'var') || ~exist('eMax', 'var'))
    L1 = lum(img_ref);
    L2 = lum(img_dist);
    
    ind1 = find(L1 > 0);
    ind2 = find(L2 > 0);
    
    cMin = min([min(L1(ind1)), min(L2(ind2))]); 
    cMax = max([max(L1(ind1)), max(L2(ind2))]); 
    
    minFstop = round(log2(cMin));
    maxFstop = round(log2(cMax));
      
    eMin = -maxFstop;
    eMax = -minFstop;
end

if(eMax == eMin)
    eMin = eMin-1;
    eMax = eMax+1;
end

if(eMax < eMin)
    error('It cannot be');
end

invGamma = 1.0 / 2.2; %inverse gamma value

eVec  = [];
eMean = [];

mse_acc = 0;
for i=eMin:eMax
    espo = 2^i;%Exposure
   
    timg_ref = quant8(img_ref, espo, invGamma);
    val = mean(timg_ref(:) / 255.0); %mean value

    if((val > 0.1) && (val < 0.9))
        eMean = [eMean, val];
        eVec  = [eVec,  i];

        timg_dist = quant8(img_dist, espo, invGamma);

        mse_acc = mse_acc + MSE(timg_ref, timg_dist);
    end
end

eMax = max(eVec);
eMin = min(eVec);

if(~isempty(eMax))
    mse = mse_acc / length(eMax);
    mpsnr = 20.0 * log10(255.0 / sqrt(mse));
else
    mpsnr = -1;
end

end

function out = quant8(img, e, g)
    img_eg = (img * e).^g;
    out = ClampImg(round(255 * img_eg), 0.0, 255.0);
end