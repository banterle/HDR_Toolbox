function [imgOut, samples] = ImportanceSampling(img, falloff, nSamples)
%
%
%        [imgOut,samples]=ImportanceSampling(img, falloff, nSamples)
%
%
%        Input:
%           -img: an environment map in the latitude-longitude mapping
%           -nSamples: the number of samples to generate
%           -falloff: a flag. If it is set 1, it means that fall-off will
%                     be taken into account
%
%        Output:
%           -imgOut: an image with sampled points (only where they are
%           placed)
%           -samples: a list of the sampled points of img
%
%     Copyright (C) 2011-13  Francesco Banterle
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

if(~exist('nSamples', 'var'))
    nSamples = 1024;
end

if(~exist('falloff', 'var'))
    falloff = 0;
end

%falloff compensation
if(falloff)
    img = FallOffEnvMap(img);
end

%Luminance channel
L = lum(img);
[r, c] = size(L);

%Creation of 1D distributions for sampling
cDistr = [];
values = zeros(c,1);
for i=1:c
    %1D Distribution
    tmpDistr = Create1DDistribution(L(:, i));
    cDistr = [cDistr, tmpDistr];
    values(i) = tmpDistr.maxCDF;
end
rDistr = Create1DDistribution(values);

samples = [];
imgOut = zeros(size(L));
pi22 = 2 * pi^2;
for i=1:nSamples
    %sampling rDistr
    [x, pdf1] = Sampling1DDistribution(rDistr, rand());
    %sampling cDistr
    [y, pdf2] = Sampling1DDistribution(cDistr(x), rand());
    %direction
    angles = pi * [2 * x / c, y / r];
    vec = PolarVec3(angles(2), angles(1));
    pdf = (pdf1 * pdf2) / (pi22 * abs(sin(angles(1))));
    %creating a sample
    sample = struct('dir', vec, 'x', x / c, 'y', y / r, 'col', img(y,x,:), 'pdf', pdf);
    samples = [samples, sample];    
    imgOut(y, x) = imgOut(y, x) + 1;
end

end