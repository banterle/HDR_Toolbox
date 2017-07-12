function log_mse = logMSE(img_ref, img_dist)
%
%
%      log_mse = logMSE(img_ref, img_dist)
%
%
%       Input:
%           -img_ref: input source image
%           -img_dist: input target image
%
%       Output:
%           -log_mse: MSE in log10 domain. Lower values means better quality.
% 
%     Copyright (C) 2006-2016  Francesco Banterle
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

[img_ref, img_dist] = checkDomains(img_ref, img_dist);
checkNegative(img_ref);
checkNegative(img_dist);

img_ref = log10(img_ref + 1e-6);
img_dist = log10(img_dist + 1e-6);

delta_sq = (img_ref - img_dist).^2;

log_mse = mean(delta_sq(:));

end