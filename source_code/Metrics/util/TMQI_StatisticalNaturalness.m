function N = TMQI_StatisticalNaturalness(L_ldr)
%
%       N = TMQI_StatisticalNaturalness(L_ldr)
%
%
%        Input:
%           -L_ldr: an LDR image
%
%        Output:
%           -N: naturalness value
%
%     Copyright (C) 2012  Hojatollah Yeganeh and Zhou Wang
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

u = mean2(L_ldr);
fun = @(x) std(x(:)) * ones(size(x));

if(~exist('blkproc'))
    I1 = blockproc(L_ldr,[11 11], fun);
else
    I1 = blkproc(L_ldr,[11 11], fun);
end

sig = (mean2(I1));

%------------------ Contrast ----------
phat(1) = 4.4;
phat(2) = 10.1;
beta_mode = (phat(1) - 1)/(phat(1) + phat(2) - 2);

if(exist('betapdf')==2)
    C_0 = betapdf(beta_mode, phat(1),phat(2));
    C   = betapdf(sig./64.29,phat(1),phat(2));
else
    C_0 = TMQI_betapdf(beta_mode, phat(1),phat(2));
    C   = TMQI_betapdf(sig./64.29,phat(1),phat(2));
end
pc  = C./C_0;

%----------------  Brightness ---------
muhat    = 115.94;
sigmahat = 27.99;

if(exist('normpdf')==2)
    B   = normpdf(u,muhat,sigmahat);
    B_0 = normpdf(muhat,muhat,sigmahat);
else
    B   = TMQI_normpdf(u,muhat,sigmahat);
    B_0 = TMQI_normpdf(muhat,muhat,sigmahat);
end
pb  = B./B_0;

%-------------------------------
N = pb*pc;

end

%
%   MATLAB normpdf if the Stattistics Toolbox is missing
%
