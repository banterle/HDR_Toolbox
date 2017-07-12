function [imgOut, lin_fun] = BuildHDR(stack, stack_exposure, lin_type, lin_fun, weight_type, merge_type, bMeanWeight)
%
%       [imgOut, lin_fun] = BuildHDR(stack, stack_exposure, lin_type, lin_fun, weight_type, merge_type, bMeanWeight)
%
%       This function builds an HDR image from a stack of LDR images.
%
%        Input:
%           -stack: an input stack of LDR images. This has to be set if we
%           the stack is already in memory and we do not want to load it
%           from the disk using the tuple (dir_name, format).
%           If the stack is a single or dobule, values are assumed to be in
%           the range [0,1].
%
%           -stack_exposure: an array containg the exposure time of each
%           image. Time is expressed in second (s).
%
%           -lin_type: the linearization function:
%                      - 'linear': images are already linear
%                      - 'gamma': a gamma function is used for linearization;
%                      - 'sRGB': images are encoded using sRGB
%                      - 'LUT': the lineraziation function is a look-up
%                               table defined stored as an array in the 
%                               lin_fun 
%                      - 'poly': the lineraziation function is a polynomial
%                               stored in lin_fun 
%
%           -lin_fun: it is the inverse camera response function of the camera that
%           took the pictures in the stack. If it is empty, [], and 
%           type is 'LUT' it will be estimated using Debevec and Malik's
%           method.
%
%           -weight_type:
%               - 'all':   weight is set to 1
%               - 'hat':   hat function 1-(2x-1)^12
%               - 'Deb97': Debevec and Malik 97 weight function
%               - 'Robertson': a Gaussian function as weight function.
%                          This function produces good results when some 
%                          under-exposed or over-exposed images are present
%                          in the stack.
%
%           -merge_type:
%               - 'linear': it merges different LDR images in the linear
%               domain.
%               - 'log': it merges different LDR images in the natural
%               logarithmic domain.
%               - 'w_time_sq': it merges different LDR images in the
%               linear; the weight is scaled by the square of the exposure
%               time.
%               
%
%           -bMeanWeight: if it is set to 1, it will compute a single
%           weight for each exposure (not a weight for each color channel)
%           for assembling all images.
%           Note that this option typicallt improves numerical stability,
%           but it can introduce bias in the final colors. This option is
%           set to 0 by default.
%
%        Output:
%           -imgOut: the final HDR image.
%           -lin_fun: the camera response function.
%
%        Example:
%           This example line shows how to load a stack from disk:
%
%               stack = ReadLDRStack('stack_alignment', 'jpg');               
%               
%               stack_exposure = ReadLDRExif('stack_alignment', 'jpg');
%               
%               BuildHDR(stack, stack_exposure,'tabledDeb97',[],'Deb97');
%
%
%     Copyright (C) 2011-16  Francesco Banterle
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

%merge type, if it is not set the default is 'log'
if(~exist('merge_type', 'var'))
    merge_type = 'log';
end

if(~exist('bMeanWeight', 'var'))
    bMeanWeight = 0;
end

%is a weight function defined?
if(~exist('weight_type', 'var'))
    weight_type = 'all';
end

%is the linearization type of the images defined?
if(~exist('lin_type', 'var'))
    lin_type = 'gamma';
end

%do we have the inverse camera response function?
if(~exist('lin_fun', 'var'))
    lin_fun = [];
end

%stack exposure checks
if(isempty(stack) || isempty(stack_exposure))
    error('The stack is set empty!');
end

stack_exposure_check = unique(stack_exposure);

if(length(stack_exposure) ~= length(stack_exposure_check))
    error('The stack contains images with the same exposure value. Please remove these duplicated images!');
end

if(min(stack_exposure(:)) <= 0.0)
    error('The stack contains images with negative or zero exposure value. Please remove this images!');
end

%merging
[r, c, col, n] = size(stack);

imgOut    = zeros(r, c, col, 'single');
totWeight = zeros(r, c, col, 'single');

scale = 1.0;

if(isa(stack, 'uint8'))
    scale = 255.0;
end

if(isa(stack, 'uint16'))
    scale = 65535.0;
end

%is the inverse camera function ok? Do we need to recompute it?
if((strcmp(lin_type, 'LUT') == 1) && isempty(lin_fun))
    [lin_fun, ~] = DebevecCRF(single(stack) / scale, stack_exposure);        
end

if(strcmp(lin_type, 'gamma') == 1)
    if(isempty(lin_fun))
        lin_fun = 2.2;
    else
        if(lin_fun <= 0.0)
            lin_fun = 2.2;
        end
    end
end

%this value is added for numerical stability
delta_value = 1.0 / 65536.0;

%for each LDR image...
for i=1:n
    tmpStack = ClampImg(single(stack(:,:,:,i)) / scale, 0.0, 1.0);
    
    %computing the weight function    
    weight  = WeightFunction(tmpStack, weight_type, bMeanWeight);

    %linearization of the image
    tmpStack = RemoveCRF(tmpStack, lin_type, lin_fun);
      
    %sum things up...
    dt_i = stack_exposure(i);    
              
    switch merge_type
        case 'linear'
            imgOut = imgOut + (weight .* tmpStack) / dt_i;
            totWeight = totWeight + weight;

        case 'log'
            imgOut = imgOut + weight .* (log(tmpStack + delta_value) - log(dt_i));
            totWeight = totWeight + weight;                

        case 'w_time_sq'
            imgOut = imgOut + (weight .* tmpStack) * dt_i;
            totWeight = totWeight + weight * dt_i * dt_i;
    end
end

imgOut = (imgOut ./ totWeight);

if(strcmp(merge_type, 'log') == 1)
    imgOut = exp(imgOut);
end

%checking for saturated pixels
saturation = 1e-4;

if(~isempty(totWeight <= saturation))
    [~, i_sat] = min(stack_exposure);
    [~, i_noisy] = max(stack_exposure);

    i_med = round(length(stack_exposure) / 2);
    med = ClampImg(single(stack(:,:,:,i_med)) / scale, 0.0, 1.0);
    
    tmpStack = ClampImg(single(stack(:,:,:,i_sat)) / scale, 0.0, 1.0);
    img_sat = RemoveCRF(tmpStack, lin_type, lin_fun);
    img_sat = img_sat / stack_exposure(i_sat);
       
    mask = zeros(size(totWeight));
    mask(totWeight <= saturation & med > 0.5) = 1;
    mask = max(mask, [], 3);
    
    if(max(mask(:)) > 0.5)
        disp('WARNING: the stack has saturated pixels!');
        if(exist('debug_mode', 'var'))
            imwrite(mask, 'mask_sat.bmp');
        end

        for i=1:col
            io_i = imgOut(:,:,i);
            is_i = img_sat(:,:,i);
            io_i(mask == 1) = is_i(mask == 1);
            imgOut(:,:,i) = io_i;
        end
    end
    
    tmpStack = ClampImg(single(stack(:,:,:,i_noisy)) / scale, 0.0, 1.0);
    img_noisy = RemoveCRF(tmpStack, lin_type, lin_fun);
    img_noisy = img_noisy / stack_exposure(i_noisy); 
    
    mask = zeros(size(totWeight));
    mask(totWeight <= saturation & med < 0.5) = 1;
    mask = max(mask, [], 3);
    
    if(max(mask(:)) > 0.5)
        disp('WARNING: the stack has noisy dark pixels!');        
        if(exist('debug_mode', 'var'))
            imwrite(mask, 'mask_noisy.bmp');
        end

        for i=1:col
            io_i = imgOut(:,:,i);
            in_i = img_noisy(:,:,i);
            io_i(mask == 1) = in_i(mask == 1);
            imgOut(:,:,i) = io_i;
        end
    end
end

%forcing to double type for allowing this image to be used in some MATLAB functions
imgOut = double(imgOut);

end