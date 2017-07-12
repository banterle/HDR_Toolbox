function [lin_fun, max_lin_fun] = DebevecCRF(stack, stack_exposure, nSamples, sampling_strategy, smoothing_term, bNormalize)
%
%       [lin_fun, max_lin_fun] = DebevecCRF(stack, stack_exposure, nSamples, sampling_strategy, smoothing_term, bNormalize)
%
%       This function computes camera response function using Debevec and
%       Malik method.
%
%        Input:
%           -stack: a stack of LDR images. If the stack is a single or
%           double values are assumed to be in [0,1].
%           -stack_exposure: an array containg the exposure time of each
%           image. Time is expressed in second (s)
%           -nSamples: number of samples for computing the CRF
%           -sampling_strategy: how to select samples:
%               -'Grossberg': picking samples according to Grossberg and
%               Nayar algorithm (CDF based)
%               -'RandomSpatial': picking random samples in the image
%               -'RegularSpatial': picking regular samples in the image
%           -smoothing_term: a smoothing term for solving the linear
%           system
%           -bNormalize: a boolean value for normalizing the inverse CRF
%
%        Output:
%           -lin_fun: the inverse CRF
%           -max_lin_fun: maximum value of the inverse CRF
%
%     Copyright (C) 2014-15  Francesco Banterle
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
    nSamples = 256;
end

if(nSamples < 1)
    nSamples = 256;
end

if(~exist('sampling_strategy', 'var'))
    sampling_strategy = 'Grossberg';
end

if(isempty(stack))
    error('DebevecCRF: a stack cannot be empty!');
end

if(isempty(stack_exposure))
    error('DebevecCRF: a stack_exposure cannot be empty!');
end

if(~exist('smoothing_term', 'var'))
    smoothing_term = 20;
end

if(~exist('bNormalize', 'var'))
    bNormalize = 1;
end

if(size(stack, 4) ~= length(stack_exposure))
    error('stack and stack_exposure have different number of exposures');
end

if(isa(stack, 'uint8'))
    stack = single(stack) / 255.0;
end

if(isa(stack, 'uint16'))
    stack = single(stack) / 65535.0;
end

col = size(stack, 3);

%Weight function
W = WeightFunction(0:(1 / 255):1, 'Deb97');

%stack sub-sampling
stack_samples = LDRStackSubSampling(stack, stack_exposure, nSamples, sampling_strategy);

%recovering the CRF
lin_fun = zeros(256, col);
log_stack_exposure = log(stack_exposure);

max_lin_fun = zeros(1, col);

for i=1:col
    g = gsolve(stack_samples(:,:,i), log_stack_exposure, smoothing_term, W);
    g = exp(g);
    
    lin_fun(:,i) = g;
end

%color correction
gray = zeros(1,3);
for i=1:col
    gray(i) = lin_fun(128, i);
end

scale = FindChromaticyScale([0.5, 0.5, 0.5], gray);

for i=1:col
    lin_fun(:,i) = scale(i) * lin_fun(:,i);
    max_lin_fun(i) = max(g);
end

if(bNormalize)
    max_val = max(max_lin_fun(:));
    
    for i=1:col
        lin_fun(:,i) = lin_fun(:,i) / max_val;
    end        
end

end
