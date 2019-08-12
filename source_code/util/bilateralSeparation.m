function [Base, Detail] = bilateralSeparation(img, sigma_s, sigma_r, bilateral_domain, bilateral_type)
%
%
%       [Base, Detail] = bilateralSeparation(img, sigma_s, sigma_r, bilateral_domain, bilateral_type)
%
%
%       Input:
%           -img: input image
%           -sigma_r: range sigma
%           -sigma_s: spatial sigmatmp
%           -bilateral_domain: domain of the values' computations
%               'linear'
%               'sigmoid'
%               'log_2'
%               'log_e'
%               'log_10'
%               
%           -bilateral_type: 
%               'full': slow but accurate
%               'approx_bil_grid': fast approximation
%               'approx_importance': fast approximation
%
%       Output:
%           -Base: the low frequency image
%           -Detail: the high frequency image
%
%     Copyright (C) 2011-18  Francesco Banterle
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

[r, c , col] = size(img);

%default parameters
if(~exist('sigma_s', 'var'))
    sigma_s = max([r, c]) * 0.02;
end

if(~exist('sigma_r', 'var'))
    sigma_r = 0.4;
end

if(~exist('bilateral_type', 'var'))
   bilateral_type = 'approx_importance'; 
end

if(~exist('bilateral_domain', 'var'))
   bilateral_domain = 'log_10'; 
end
    
%Base Layer
eps = 0.0;

switch bilateral_domain
    case 'sigmoid'
        img_log = img ./ (img + 1);
    case 'log2'
        eps = 1e-6;
        img_log = log2(img + eps);
    case 'loge'
        eps = 1e-6;
        img_log = log(img + eps);
    case 'log10'
        eps = 1e-6;
        img_log = log10(img + eps);
    otherwise
        img_log = img;
end

imgFil = zeros(size(img));

try
    switch bilateral_type
        case 'approx_bil_grid'
            for i=1:col
                tmp = img_log(:,:,i);
                imgFil(:,:,i) = bilateralFilter(tmp, [], min(tmp(:)), max(tmp(:)), sigma_s, sigma_r);
            end
            
        case 'approx_importance'
            imgFil = bilateralFilterS(img_log, [], sigma_s, sigma_r);    
            
        otherwise
            imgFil = bilateralFilterFull(img_log, [], sigma_s, sigma_r);
    end
catch exception
    disp(['BilateralSeparation:', exception.message]);
end

switch bilateral_domain
    case 'sigmoid'
        Base = imgFil ./ (1 - imgFil);
        Base(imgFil <= 0.0) = 0.0;
    case 'log2'
        Base = 2.^(imgFil) - eps;
    case 'loge'
        Base = exp(imgFil) - eps;
    case 'log10'
        Base = 10.^(imgFil) - eps;
    otherwise
        Base = imgFil;
end


%compute the detail Layer
Detail = img;
Detail(Base > 0.0) = RemoveSpecials(img(Base > 0.0) ./ Base(Base > 0.0));

Base(Base < 0.0) = 0.0;

end
