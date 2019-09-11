function [stack, stack_exposure] = CreateLDRStackFromHDR( img, fstops_distance, sampling_mode, lin_type, lin_fun)
%
%
%       stack = CreateLDRStackFromHDR( img )
%       
%
%        Input:
%           -img: input HDR image
%           -fstops_distance: delta f-stop for generating exposures
%           -sampling_mode: how to samples the image:
%                  - if sampling_mode = 'uniform', exposures are sampled
%                    in an uniform way
%                  - if sampling_mode = 'histogram', exposures are sampled using
%                    the histogram using a greedy approach
%                  - if sampling_mode = 'selected', we assume that fstops_distance
%                  is an array with the f-stops selected
%
%           -lin_type: the linearization function:
%                      - 'linear': images are already linear
%                      - 'gamma': gamma function is used for linearization;
%                      - 'sRGB': images are encoded using sRGB
%                      - 'LUT': the lineraziation function is a look-up
%                               table defined stored as an array in the 
%                               lin_fun 
%                      - 'poly': the lineraziation function is a polynomial
%                               stored in lin_fun
%
%           -lin_fun: it is the camera response function data of the camera 
%           that took the pictures in the stack. Depending on lin_type:
%                   - 'gamma': this is a single value; i.e. the gamma
%                   value.
%                   - 'sRGB': this value is empty or can be omitted
%                   - 'linear': this value can be empty or can be omitted
%                   - 'LUT': this value has to be a $n \times col$ array 
%                   - 'poly': this values has to be a $n \times col$ array
%                   that encodes a polynomial 
%
%        Output:
%           -stack: a stack of LDR images
%           -stack_exposure: exposure values of the stack (stored as time
%           in seconds)
% 
%     Copyright (C) 2016 Francesco Banterle
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

if(~exist('fstops_distance', 'var'))
    fstops_distance = 1;
end

if(~exist('sampling_mode', 'var'))
    sampling_mode = 'histogram';
end

%is the linearization type of the images defined?
if(~exist('lin_type', 'var'))
    lin_type = 'gamma';
end

%do we have the inverse camera response function?
if(~exist('lin_fun', 'var'))
    lin_fun = 2.2;
end

%luminance channel
L = lum(img);

switch(sampling_mode)
    case 'histogram'
        img_tmp = img;
        stack_exposure = 2.^ExposureHistogramSampling(img_tmp, 8, 1);
        
    case 'uniform'
        minL = min(L(L > 0));
        maxL = max(L(L > 0));
                
        if(minL == maxL)
            error('CreateLDRStackFromHDR: all pixels have the same luminance value');
        end
        
        if(maxL <= (256 * minL))
            warning('CreateLDRStackFromHDR: There is no need of sampling; i.e., 8-bit dynamic range.');                        
        end

        delta = 1e-6;
        minExposure = floor(log2(maxL + delta) + 1);
        maxExposure = ceil( log2(minL + delta) + 1);
        
        tMin = -(minExposure);
        tMax = -(maxExposure + 8);
        
        if(tMax < tMin)
            tMin = -minExposure;
            tMax = -maxExposure;            
        end
        
        stack_exposure = 2.^(tMin:fstops_distance:tMax);
        
    case 'selected'
        stack_exposure = 2.^fstops_distance;
        
    otherwise
        error('ERROR: wrong mode for sampling the HDR image');
end

%calculate exposures
n = length(stack_exposure);

min_val = 1 / 256;

for i=1:n
    img_e = img * stack_exposure(i);
    expo = ClampImg(ApplyCRF(img_e, lin_type, lin_fun), 0, 1);
    
    if(min(expo(:)) <= (1.0 - min_val) & max(expo(:)) >= min_val)
        stack(:,:,:,i) = expo;
    end
end

end

