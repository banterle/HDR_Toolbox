function ExportLights(lights, name)
%
%
%        ExportLights(lights, name)
%
%
%        Input:
%           -lights: lightsources
%           -name: file's name
%
%
%     Copyright (C) 2011  Francesco Banterle
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

n = length(lights);

fid = fopen([name, '.txt'], 'w');

%The number of lightsources
fprintf(fid,'Num: %d\n', n);
fprintf(fid, '\n');

for i=1:n        
    %Save the direction
    dir = PolarVec3((0.5 - lights(i).y) * pi, lights(i).x * pi * 2);    
    fprintf(fid,'Dir: %g %g %g\n', dir(1), dir(2), dir(3));
    %Save the color
    fprintf(fid,'Col: %g %g %g\n', lights(i).col(1), lights(i).col(2), lights(i).col(3));
    fprintf(fid,'\n');
end

fclose(fid);

end