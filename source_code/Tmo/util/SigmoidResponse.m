function R = SigmoidResponse(img, sr_n, sr_sigma, sr_B)
%
%       R = SigmoidResponse(img, sr_n, sr_sigma, sr_B)
%
%       This function computes sigmoid response
%
%       input:
%           -img: an image
%           -sr_n: power 
%           -sr_sigma: saturation parameter
%           -sr_B:
%
%       output:
%           -R: is the response
%
%     Copyright (C) 2011-14  Francesco Banterle
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

if(~exist('sr_n','var'))
    sr_n = 0.73;
end

if(~exist('sr_sigma','var'))
    sr_sigma = 1.0;
end

if(~exist('sr_B','var'))
    sr_B = 1.0;
end

img_n = img.^sr_n;
R = img_n ./ (img_n + sr_sigma.^sr_n);
R = R * sr_B;

end