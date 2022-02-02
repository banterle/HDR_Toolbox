function s = SaturationPouli(C, I)
%
%       s = SaturationPouli(C, I)
%
%       This computes the saturation using channel C and I from LCh color
%       space
%
%       input:
%         - C: chroma channel from LCh
%         - I: intensity channel from LCh
%
%       output:
%         - S: saturation channel
%
%     Copyright (C) 2013  Francesco Banterle
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
%     "Color Correction for Tone Reproduction"
% 	  by Tania Pouli1, Alessandro Artusi, Francesco Banterle, 
%     Ahmet Oguz Akyuz, Hans-Peter Seidel and Erik Reinhard
%     in the Twenty-first Color and Imaging Conference (CIC21), Albuquerque, Nov. 2013 
%
%

D = sqrt(C.^2 + I.^2);
s = C ./ D;

end