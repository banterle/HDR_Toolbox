function imgOut = WardHistAdjTMO(img, nBin, LdMin, LdMax, bPlotHistogram)
%
%        imgOut = WardHistAdjTMO(img, nBin, LdMin, LdMax, bPlotHistogram)
%
%
%        Input:
%           -img: input HDR image
%           -nBin: number of bins for calculating the histogram (1,+Inf)
%           -LdMin: minimum luminance value of the dispLay
%           -LdMax: maximum luminance value of the dispLay
%           -bPlotHistogram:
%
%        Output:
%           -imgOut: tone mapped image
% 
%     Copyright (C) 2010-16  Francesco Banterle
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
%     "A Visibility Matching Tone Reproduction Operator for High Dynamic Range Scenes"
% 	  by Gregory Ward Larson, Holly Rushmeier, Christine Piatko
%     in IEEE Transactions on Visualization and Computer Graphics 1997
%

%is it a gray/three color channels image?
check13Color(img);

checkNegative(img);

if(~exist('nBin', 'var'))
    nBin = 100;
end

if(nBin < 1)
    nBin = 100;
end

if(~exist('LdMin', 'var'))
    LdMin = 1; %cd/m^2
end

if(LdMin <= 0.0)
    LdMin = 1;
end

if(~exist('LdMax', 'var'))
    LdMax = 100; %cd/m^2
end

if(LdMax <= 0.0)
    LdMax = 100;
end

if(LdMax < LdMin)
    tmp = LdMin;
    LdMin = LdMax;
    LdMax = tmp;
end

if(~exist('bPlotHistogram', 'var'))
    bPlotHistogram = 0;
end

%compute luminance channel
L = lum(img);

%downsample according to fovea...
L2 = WardDownsampling(L + 1e-6);

%compute stastistics
LMin = min(L2(:));
LMax = max(L2(:));

Llog  = log(L2);

LlMin = log(LMin);
LlMax = log(LMax);

LldMin = log(LdMin);
LldMax = log(LdMax);

%compute the histogram H 
H = zeros(nBin, 1);
delta = (LlMax - LlMin) / nBin;

for i=1:nBin
    indx = find(Llog > (delta * (i - 1) + LlMin) & Llog <= (delta * i + LlMin));
    H(i) = numel(indx);
end

%apply the histogram ceiling
maxH = max(H);
x_vis = LlMin:((LlMax - LlMin) / (nBin -1)):LlMax;

if(bPlotHistogram)
    bar(x_vis, H/maxH);
    hold on;
end

H = histogram_ceiling(H, delta / (LldMax - LldMin));

if(bPlotHistogram)
    bar(x_vis, H/maxH);
    hold off;
end

%compute P(x) 
P = cumsum(H);
P = P / max(P);

%calculate tone mapped luminance
L(L > LMax) = LMax;
x = (LlMin:((LlMax - LlMin) / (nBin - 1)):LlMax)';
P_L = interp1(x , P , real(log(L)), 'linear');
Ld  = exp(LldMin + (LldMax - LldMin) * P_L);
%normalize in [0,1]
Ld  = (Ld - LdMin) / (LdMax - LdMin); 

%change luminance
imgOut = ChangeLuminance(img, L, Ld);
end
