function MedianCutAux(xMin, xMax, yMin, yMax, iter)
%
%
%        MedianCutAux(xMin, xMax, yMin, yMax, iter)
%       
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

global L;
global imgWork;
global lights;

lx = xMax - xMin;
ly = yMax - yMin;

if((lx > 2) && (ly > 2) && (iter > 0))
    tot = sum(sum(L(yMin:yMax, xMin:xMax)));
    pivot = -1;
  
    if(lx > ly)
        %cut on the X-axis
        for i=xMin:(xMax - 1)
            c = sum(sum(L(yMin:yMax, xMin:i)));
            if(c >= (tot - c))
                pivot = i;
                break;
            end
        end

        if(pivot == -1)
            pivot = xMax-1;
        end
        
        MedianCutAux(xMin,    pivot, yMin, yMax, iter-1);
        MedianCutAux(pivot+1, xMax,  yMin, yMax, iter-1);
    else
        %cut on the Y-axis
        for i=yMin:(yMax - 1)
            c = sum(sum(L(yMin:i, xMin:xMax)));
            if(c >= (tot - c))
                pivot = i;
                break;
            end
        end
        
        if(pivot == -1)
            pivot = yMax-1;
        end
        
        MedianCutAux(xMin, xMax, yMin,    pivot, iter-1);
        MedianCutAux(xMin, xMax, pivot+1, yMax,  iter-1);
    end
else
    %Generation of the light source
    lights = [lights, CreateLight(xMin, xMax, yMin, yMax, L, imgWork)];
end

end
