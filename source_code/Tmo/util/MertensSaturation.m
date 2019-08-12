function Ws = MertensSaturation(img)
%
%
%        Ws = MertensSaturation(img)
%
% 
%     Copyright (C) 2010 Francesco Banterle
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

[r,c,col] = size(img);

if(col==1)
    Ws = ones(r, c);
else
    mu = zeros(r,c);
    for i=1:col
        mu = mu + img(:,:,i);
    end
    mu = mu/col;

    sumC = zeros(r,c);
    for i=1:col
        sumC = sumC + (img(:,:,i)-mu).^2;
    end

    Ws = sqrt( sumC/col );
end

end
