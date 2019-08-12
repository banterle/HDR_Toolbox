function [imgOut, lights] = VarianceMinimizationSampling(img, nlights, falloff)
%
%
%        [imgOut, lights] = VarianceMinimizationSampling(img, nlights, falloff)
%
%
%        Input:
%           -img: an environment map in the latitude-longitude mapping
%           -nlights: the number of samples to generate
%           -falloff: a flag. If it is set 1, it means that fall-off will
%                     be taken into account
%
%        Output:
%           -imgOut: an image with sampled points
%           -lights: a list of directional lights
%
%     Copyright (C) 2014  Francesco Banterle
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

if(~exist('nlights', 'var'))
    nlights = -1;
end

if(~exist('falloff', 'var'))
    falloff = 0;
end

global L;
global imgWork;
global nLights;
global lights;

%falloff compensation
if(falloff)
    img = FallOffEnvMap(img);
end

%Global variables initialization
L = lum(img);
imgWork = img;
[r, c] = size(L);

if(nlights < 0)
    nlights = 2.^(round(log2(min([r, c])) + 2));
end

nLights = round(log2(nlights));

lights = [];

VarianceMinimizationSamplingAux(1, c, 1, r, 0);

imgOut = GenerateLightMap(lights, c, r);

end
