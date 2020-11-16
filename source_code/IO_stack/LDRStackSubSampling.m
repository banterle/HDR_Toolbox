function stack_samples = LDRStackSubSampling(stack, stack_exposure, nSamples, sampling_strategy, outliers_percentage )
%
%       stack_samples = LDRStackSubSampling(stack, stack_exposure, nSamples, sampling_strategy, outliers_percentage )
%
%       This function subsamples a stack
%
%        Input:
%           -stack: a stack of LDR images. If the stack is a single or
%           double values are assumed to be in [0,1]
%           -nSamples: number of samples for computing the CRF
%           -sampling_strategy: how to select samples:
%               -'Grossberg': picking samples according to Grossberg and
%               Nayar algorithm (CDF based)
%               -'RandomSpatial': picking random samples in the image
%               -'RegularSpatial': picking regular samples in the image
%               -outliers_percentage:
%
%        Output:
%           -stack_samples: sub-sampled stack
%
%     Copyright (C) 2016  Francesco Banterle
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

if(~exist('outliers_percentage', 'var'))
    outliers_percentage = 0;    
end

if(isempty(stack))
    error('LDRStackSubSampling: a stack cannot be empty!');
end

if(~exist('nSamples', 'var'))
    nSamples = 256;
end

if(~exist('sampling_strategy', 'var'))
    sampling_strategy = 'Grossberg';
end

[~, sort_index] = sort(stack_exposure, 'descend');
sort_index = sort_index';

%stack sub-sampling
switch sampling_strategy
    case 'Grossberg'
        stack_hist = ComputeLDRStackHistogram(stack);
        stack_samples = GrossbergSampling(stack_hist, nSamples);
        
    case 'RandomSpatial'
        stack_samples = SpatialSampling(stack, sort_index, nSamples, sampling_strategy);
        stack_samples = round(stack_samples * 255);

    case 'RegularSpatial'
        stack_samples = SpatialSampling(stack, sort_index, nSamples, sampling_strategy);
        stack_samples = round(stack_samples * 255);
        
    otherwise
        error('LDRStackSubSampling: A sampling strategy neeeds to be specified.');
end

if(outliers_percentage > 0.0)
    t_min = outliers_percentage;
    t_max = 1.0 - t_min;
    stack_samples(stack_samples < (t_min * 255.0) | stack_samples > (t_max * 255)) = -1.0;
end

end
