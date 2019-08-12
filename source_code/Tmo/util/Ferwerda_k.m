function k = Ferwerda_k(Lwa)
%
%       k = Ferwerda_k(Lwa)
%
%
%        Input:
%           -Lwa: world adaptation luminance in cd/m^2
%
%        Output:
%           -k: k value
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
%     The paper describing this technique is:
%     "A Model of Visual Adaptation for Realistic Image Synthesis"
% 	  by James A. Ferwerda, Sumanta N. Pattanaik, Peter Shirley, Donald P. Greenberg
%     in Proceedings of SIGGRAPH 1996
%

k = (1 - (Lwa / 2 - 0.01) / (10 - 0.01)).^2;

k = ClampImg(k, 0.0, 1.0);

end