function imgOut = AshikhminTMO(img, LdMax, pLocal)
%
%
%      imgOut = AshikhminTMO(img, LdMax, pLocal)
%
%
%       Input:
%           -img: input HDR image
%           -LdMax: maximum output luminance of the LDR display
%           -pLocal: boolean value. If it is true a local version is used
%                   otherwise a global version.
%
%       Output:
%           -imgOut: output tone mapped image in linear domain
% 
%     Copyright (C) 2010-2016  Francesco Banterle
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
%     "A Tone Mapping Algorithm for High Contrast Images"
% 	  by Michael Ashikhmin
%     in EGSR 2002
%

%is it a three color channels image?
check13Color(img);
checkNegative(img);

if(~exist('pLocal', 'var'))
    pLocal=1;
end

if(~exist('LdMax', 'var'))
    LdMax = 100;
end

%Luminance channel
L = lum(img);

%Local calculation?
if(pLocal)
    [L, Ldetail] = AshikhminFiltering(L);
end

%Roboust maximum and minimum
maxL = MaxQuart(L, 0.9995);
minL = MaxQuart(L, 0.0005);

%Range compression
maxL_TVI = TVI_Ashikhmin(maxL);
minL_TVI = TVI_Ashikhmin(minL);

Ld = (LdMax / 100)*(TVI_Ashikhmin(L) - minL_TVI) / (maxL_TVI - minL_TVI);

%Local Recombination
if(pLocal)
    Ld = Ld .* Ldetail;
end

%Changing luminance
imgOut = ChangeLuminance(img, lum(img), Ld);
end