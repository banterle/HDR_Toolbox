function [Base, Detail] = bilateralSeparation(img, sigma_s, sigma_r)
%
%
%       [Base, Detail] = bilateralSeparation(img, sigma_s, sigma_r)
%
%
%       Input:
%           -img: input image
%           -sigma_r: range sigma
%           -sigma_s: spatial sigmatmp
%
%       Output:
%           -Base: the low frequency image
%           -Detail: the high frequency image
%
%     Copyright (C) 2011-15  Francesco Banterle
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

%Base Layer
img_log = log10(img + 1e-6);

imgFil = zeros(size(img));

try
    for i=1:col
        tmp = img_log(:,:,i);
        imgFil(:,:,i) = bilateralFilter(tmp, [], min(tmp(:)), max(tmp(:)), sigma_s, sigma_r);
    end
catch exception
    disp(['BilateralSeparation:', exception]);
end

Base = 10.^(imgFil) - 1e-6;

%Removing 0
Base(Base <= 0) = 0;

%Detail Layer
Detail = RemoveSpecials(img ./ Base);

end