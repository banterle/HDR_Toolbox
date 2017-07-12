function y = TMQI_normpdf(x, tmqi_mu, tmqi_sigma)
%
%       y = TMQI_normpdf(x, tmqi_mu, tmqi_sigma)
%
%
%        Input:
%           -x: value where to evaluate the normal distribution
%           -tmqi_mu: is the mean of the normal distribution
%           -tmqi_sigma: is the standard deviation of the normal deviation
%
%        Output:
%           -y: evaluation of the normal distribution
%
%     Copyright (C) 2013  Francesco Banterle
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

if(~exist('tmqi_mu','var'))
    tmqi_mu = 0.0;
end

if(~exist('tmqi_sigma','var'))
    tmqi_sigma = 1.0;
end

y = exp(-(x-tmqi_mu).^2/(2*tmqi_sigma^2))/(tmqi_sigma*sqrt(2*pi));

end