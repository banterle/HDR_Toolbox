function VarianceMinimizationSamplingAux(xMin,xMax,yMin,yMax,iter)
%
%
%        VarianceMinimizationSamplingAux(xMin,xMax,yMin,yMax,iter)
%       
%
%     Copyright (C) 2014-2015  Francesco Banterle
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
global nLights;
global lights;

lx = xMax-xMin;
ly = yMax-yMin;

if((lx > 2) && (ly > 2) && (iter < nLights))
    %checking a cut on the X-Axis
    v_min = 1e30;
    cut   = -1;
    pivot = -1;

    for i=xMin:(xMax-1)
        tmp_v_r0 = VarianceRegion(L, xMin, i,    yMin, yMax);
        tmp_v_r1 = VarianceRegion(L, i+1,  xMax, yMin, yMax);
        
        v_max = max([tmp_v_r0, tmp_v_r1]);
                
        if(v_max<v_min)
            v_min = v_max;
            cut   = 0;
            pivot = i;            
        end
    end

    %checking a cut on the Y-Axis
    for i=yMin:(yMax-1)
        tmp_v_r0 = VarianceRegion(L, xMin, xMax, yMin, i);
        tmp_v_r1 = VarianceRegion(L, xMin, xMax, i+1,  yMax);
        
        v_max = max([tmp_v_r0, tmp_v_r1]);        
        
        if(v_max<v_min)
            v_min = v_max;
            cut   = 1;
            pivot = i;            
        end
    end
    
    if(pivot>-1)
        if(cut)
            VarianceMinimizationSamplingAux(xMin, xMax, yMin,    pivot, iter+1);
            VarianceMinimizationSamplingAux(xMin, xMax, pivot+1, yMax,  iter+1);
        else            
            VarianceMinimizationSamplingAux(xMin,    pivot, yMin, yMax, iter+1);
            VarianceMinimizationSamplingAux(pivot+1, xMax,  yMin, yMax, iter+1);
        end  
    else
        lights = [lights, CreateLight(xMin,xMax,yMin,yMax,L,imgWork)];
    end
else
    %Generation of the light source
    lights = [lights, CreateLight(xMin,xMax,yMin,yMax,L,imgWork)];
end

end