function scale = FindChromaticyScale(M, I)
%
%       scale = FindChromaticyScale(M, I)
%
%
%        Input:
%
%
%        Output:
%
%
%     Copyright (C) 2016 Francesco Banterle
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

l_m = length(M);
l_I = length(I);

if((l_m ~= l_I) || isempty(M) || isempty(I))
    error('FindChromaticyScale: input colors have different color channels.');
end


    function err = residualFunction(p)
        
        I_c = I .* p;

        I_c_n = I_c / norm(I_c);
        M_n = M / norm(M);

        err = sum((I_c_n - M_n).^2);
    end

    opts = optimset('Display', 'none', 'TolFun', 1e-12, 'TolX', 1e-12);
    scale = fminsearch(@residualFunction, ones(1, l_m), opts);



end
