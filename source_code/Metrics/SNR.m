function snr = SNR(img_ref, img_dist)
%
%
%      snr = SNR(img_ref, img_dist)
%
%
%       Input:
%           -img_ref: reference image
%           -img_dist: distoreted image
%
%       Output:
%           -snr: classic SNR for images in dB. Higher values means better quality.
% 
%     Copyright (C) 2014-16  Francesco Banterle
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

img_noise_sq = (img_ref - img_dist).^2;
img_ref_sq = img_ref.^2;

P_signal = mean(img_ref_sq(:));
P_noise = mean(img_noise_sq(:));

if(P_noise > 0.0)
    snr = 10 * log10(P_signal / P_noise);
else
    disp('SNR: the images are the same!');
    snr = 1000.0;
end

end