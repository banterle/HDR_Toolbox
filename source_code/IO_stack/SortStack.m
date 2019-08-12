function [stack, stack_exposure ] = SortStack( stack, stack_exposure, sorting_type )
%
%       [lin_fun, pp] = MitsunagaNayarCRF(stack, stack_exposure, N, nSamples, sampling_strategy)
%
%       This function computes camera response function using Mitsunaga and
%       Nayar method.
%
%        Input:
%           -stack: a stack of LDR images. If the stack is a single or
%           double values are assumed to be in [0,1]
%           -stack_exposure: an array containg the exposure time of each
%           image. Time is expressed in second (s)
%           -sorting_type: 'ascend' or 'descend'
%
%        Output:
%           -stack: sorted stack 
%           -stack_exposure: sorted stack_exposure
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

if(~exist(sorting_type, 'var'))
    sorting_type =  'ascend';
end

[stack_exposure_sorted, ind] = sort(stack_exposure, sorting_type);

if(sum(abs(stack_exposure_sorted - stack_exposure)) > 0.0)
    stack_sorted = zeros(size(stack));
    for i=1:length(stack_exposure)
        stack_sorted(:,:,:,i) = stack(:,:,:,ind(i)); 
    end
    
    stack = stack_sorted;
    stack_exposure = stack_exposure_sorted;
        
    clear('stack_sorted');
    clear('stack_exposure_sorted');
end

end

