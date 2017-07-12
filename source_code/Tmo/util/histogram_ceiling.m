function H = histogram_ceiling(H, k)
%
%
%        H = histogram_ceiling(H, k)
%
%       This function trims an histogram
%
%        Input:
%           -H: input histogram
%           -k: 
%
%        Output:
%           -H: output histogram
% 
%     Copyright (C) 2010-15 Francesco Banterle
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

tolerance = sum(H) * 0.025;
trimmings = 0;
val = 1;
n = length(H);

while((trimmings <= tolerance) & val)
    trimmings = 0;
    T = sum(H);
    
    if(T < tolerance)
        val = 0;
    else
        ceiling = T * k;
        for i=1:n
            if(H(i) > ceiling)
                trimmings = trimmings + H(i) - ceiling;
                H(i) = ceiling;
            end
        end
    end
end

end