function QP_Ratio = LeeKimQuality(QP_LDR)
%
%
%       QP_Ratio = LeeKimQuality(QP_LDR)
%
%
%       Input:
%           -QP_LDR: quality of the LDR (tone mapped) stream
%       
%       Output:
%           -QP_Ratio: quality of the residuals stream
%
%     Copyright (C) 2013-14  Francesco Banterle
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
%     "RATE-DISTORTION OPTIMIZED COMPRESSION OF HIGH DYNAMIC RANGE VIDEOS"
% 	  by Chul Lee and Chang-Su Kim
%     in 16th European Signal Processing Conference (EUSIPCO 2008),
%     Lausanne, Switzerland, August 25-29, 2008, copyright by EURASIP
%
%

if(QP_LDR<1.0)
    %quality value is assumed to be in [0,1] so it is scaled in [0,100]
    QP_LDR = round(QP_LDR * 100);
end

QP_Ratio = 0.77 * QP_LDR + 13.42; %Equation 6 of the original paper

if(QP_Ratio > 100)
    QP_Ratio = 100;
end

end