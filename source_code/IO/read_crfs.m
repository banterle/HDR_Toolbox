function [I,B] = read_crfs(name)
%
%       [I,B] = read_crfs(name)
%
%       This function reads camera response functions .txt file from:
%               https://www.cs.columbia.edu/CAVE/software/softlib/dorf.php
%
%        Input:
%           -name: the file name of the CRF RAW.
%
%        Output:
%           -I: the irradiance values vector for each CRFs.
%           -B: the brigthness values vector for each CRFs.
%
%     Copyright (C) 2021  Francesco Banterle
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

f = fopen(name, 'r');

I = [];
B = [];
i = 1;
while(feof(f) == 0)
   model = fscanf(f, '%s', 1);
   graph = fscanf(f, '%s', 1);

   disp(model);
   disp(graph);
   disp([model, ' ', graph, ' ', num2str(i)]);
   
   Is = fscanf(f, '%s',2);
   %disp(Is);
   x = fscanf(f, '%f', 1024);
   
   Bs = fscanf(f, '%s', 2);
   %disp(Bs);
   y = fscanf(f, '%f', 1024);
  
   I = [I; x'];
   B = [B; y'];
   i = i + 1;
end
        
fclose(f);

end
