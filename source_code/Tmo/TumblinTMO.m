function imgOut = TumblinTMO(img, L_da, Ld_Max, C_Max, L_wa)
%
%        imgOut = TumblinTMO(img, L_da, Ld_Max, C_Max, L_wa)
%
%
%        Input:
%           -img: an HDR image
%           -L_da: adaptation display luminance in [10,30] cd/m^2
%           -Ld_Max: maximum display luminance in [80, 180] cd/m^2
%           -C_Max: maximum LDR monitor contrast typically between 30 to 100
%
%        Output:
%           -imgOut: a tone mapped image in [0,1]
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
%     "Two Methods for Display of High Contrast Images"
% 	  by JACK TUMBLIN, JESSICA K. HODGINS, and BRIAN K. GUENTER
%     in ACM Transactions on Graphics, Vol. 18, No. 1, January 1999, Pages 56?94.
%

%is it a three color channels image?
check13Color(img);

checkNegative(img);

%check parameters
if(~exist('L_da', 'var'))
    L_da = 20;
end

if(~exist('Ld_Max', 'var'))
    Ld_Max = 100;
end

if(~exist('C_Max', 'var'))
    C_Max = 100;
end

if(~exist('L_wa', 'var'))
    L_wa = logMean(lum(img)); %luminance world adaptation 
end

%compute luminance channel
L = lum(img);

%range compression
gamma_w = StevensCSF(L_wa);
gamma_d = StevensCSF(L_da);
gamma_wd = gamma_w / (1.855 + 0.4 * log(L_da));
m = C_Max.^((gamma_wd - 1) / 2.0);
Ld = L_da * m .* ((L ./ L_wa).^(gamma_w / gamma_d));
Ld = Ld / Ld_Max;

%change luminance
imgOut = ChangeLuminance(img, L, Ld);

end