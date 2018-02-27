function val = isOctave()
%
%
%        val = isOctave()
%
%
%        Description: it checks if the running environment is MATLAB
%                     or Octave.
%
%        Input:
%
%        Output:
%           -val: a boolean value: 1 if the environment is Octave, otherwise 0.
%
%     Copyright (C) 2015  Francesco Banterle
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

tmp = ver();

val = 0;

if(isfield(tmp, 'Name'))
    try
        val = (strcmp(tmp(1).Name, 'Octave') == 1);
    catch expr
        disp(expr); % Should this be changed to error?
    end
end

end