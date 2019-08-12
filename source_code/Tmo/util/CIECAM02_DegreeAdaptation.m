function D = CIECAM02_DegreeAdaptation(L_A, F)
%
%
%       F_L = CIECAM02_F_L(L_A, F)
%
%       Input:
%           -L_A: is the luminance of the adapting field in cd/m^2.
%           -F: the surround factor; 1 in an average surround.
%
%       Output:
%           -D: is the D factor or degree of adaptation.
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
%     The paper describing this technique is:
%     "The CIECAM02 color appearance model"
% 	  by Nathan Moroney , Mark D. Fairchild , Robert W. G. Hunt ,
%     Changjun Li , M. Ronnier Luo , Todd Newman
%     in IS&T/SID 10 th Color Imaging Conference
%

if(~exist('F', 'var'))
    F = 1;
end

D = F * (1.0 - (exp(-(L_A + 42) / 92) / 3.6)); 

end
