function imgOut = FerwerdaTMO(img, Ld_Max, L_da, L_wa)
%
%       imgOut = FerwerdaTMO(img, Ld_Max, L_da, L_wa)
%
%
%        Input:
%           -img: input HDR image
%           -Ld_Max: maximum luminance of the display in cd/m^2
%           -L_da: adaptation luminance in cd/m^2
%           -L_wa: world adaptation luminance in cd/m^2
%
%        Output:
%           -imgOut: tone mapped image with values in [0,1]
% 
%     Copyright (C) 2010-15 Francesco Banterle
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

check13Color(img);

checkNegative(img);

if(~exist('Ld_Max', 'var'))
    Ld_Max = 100; %assuming 100 cd/m^2 output display
end

if(~exist('L_da', 'var'))
    L_da = Ld_Max / 2; %as in the original paper
end

if(~exist('L_wa', 'var'))
    L_wa = max(max(lum(img))) / 2; %as in the original paper
    disp('Note: setting L_wa to default it may create dark images.');
end

%compute Luminance
L = lum(img);

%compute the scaling factors
mC = TpFerwerda(L_da) / TpFerwerda(L_wa);%cones
mR = TsFerwerda(L_da) / TsFerwerda(L_wa);%rods
k = WalravenValeton_k(L_wa);

%scale the HDR image
col = size(img,3);
imgOut = zeros(size(img));

switch col
    case 3
        vec = [1.05, 0.97, 1.27];
    otherwise
        vec = ones(col, 1);        
end

for i=1:col
    imgOut(:,:,i) = (mC * img(:,:,i) + vec(i) * mR * k * L);
end

imgOut = ClampImg(imgOut / Ld_Max, 0.0, 1.0);

end

