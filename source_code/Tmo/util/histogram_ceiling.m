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
trimmings = tolerance + 1;
bFlag = 1;
n = length(H);

trimmed_vec = [];

while((trimmings > tolerance) && bFlag)
    trimmings = 0;
    T = sum(H);
    if(T < tolerance)
        bFlag = 0;
    else
        ceiling = T * k;
        bTrimmed = 0;
        for i=1:n
            if(H(i) > ceiling)
                trimmings = trimmings + H(i) - ceiling;
                H(i) = ceiling;
                bTrimmed = 1;
            end
        end
        trimmed_vec = [trimmed_vec, bTrimmed];
    end
    
    if(length(trimmed_vec) >= 2)
        b1 = (trimmed_vec(end) == 0);
        b2 = (trimmed_vec(end - 1) == 0);
        if(b1 & b2)
            bFlag = 0;
        end
    end
 
end

end
