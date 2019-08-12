function S = SigmoidColorResponse(L, sr_n, sr_sigma, sr_B)
%
%       S = SigmoidColorResponse(L, sr_n, sr_sigma, sr_B)
%
%       This function computes sigmoid response
%
%       input:
%           -L: a luminance image
%           -sr_n: power 
%           -sr_sigma:
%           -sr_B:
%
%       output:
%           -S: color correction for taking into account sigmoid
%           compression
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

if(~exist('sr_n', 'var'))
    sr_n = 0.73;
end

if(~exist('sr_sigma', 'var'))
    sr_sigma = 1.0;
end

if(~exist('sr_B', 'var'))
    sr_B = 1.0;
end

L_n = L.^sr_n;
sigma_n = sr_sigma.^sr_n;

S = L_n ./ ((L_n + sigma_n).^2); 
S = S * (sr_n * sr_B * sigma_n);

end