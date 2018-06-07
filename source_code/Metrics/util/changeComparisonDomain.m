function [data_out, bNeg] = changeComparisonDomain(data_in, comparison_domain)
%
%
%      [data_out, bNeg] = changeComparisonDomain(data, comparison_domain)
%
%
%       Input:
%           -data: input reference image
%           -comparison_domain:
%
%       Output:
%           -data_out: 
%           -bNeg:
%
% 
%     Copyright (C) 2018  Francesco Banterle
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
data_out = 1.0;
bNeg = 1;

switch comparison_domain
    case 'lin'
        data_out = data_in;
        bNeg = 1;
        
    case 'log'
        data_in(data_in < 1e-5) = 1e-5;
        data_out  = log(data_in);
        bNeg = 0;
        
    case 'log2'
        data_in(data_in < 1e-5) = 1e-5;
        data_out  = log2(data_in);
        bNeg = 0; 
        
    case 'log10'
        data_in(data_in < 1e-5) = 1e-5;
        data_out  = log10(data_in);
        bNeg = 0;         
        
    case 'pu'
        L_data = lum(data_in);
        data_out = pu2_encode(L_data);
        bNeg = 0;

    otherwise
        data_out = data_in;
        bNeg = 1;        
end

end