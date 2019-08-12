function stack = AkyuzLDRStackDenoise(stack, stack_exposure, lin_type, lin_fun)
%
%       stack = AkyuzLDRStackDenoise(stack, exposure_stack)
%
%        Input:
%           -stack: a sequence of LDR images with values in [0,1].
%           -stack_exposure: a sequence of exposure values associated to
%                            images in the stack
%           -lin_type: the linearization function:
%                      - 'linear': images are already linear
%                      - 'gamma2.2': gamma function 2.2 is used for
%                                    linearisation;
%                      - 'sRGB': images are encoded using sRGB
%                      - 'tabledDeb97': a tabled RGB function is used for
%                                       linearisation passed as input in
%                                       lin_fun using Debevec and Malik
%                                       method
%           -lin_fun: extra parameters for linearization, see lin_type
%
%        Output:
%           -stack: a denoised version of stack in linear space.
%
%     Copyright (C) 2015  Francesco Banterle
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

[r, c, col, n] = size(stack);

target = round(n / 3);

for i=1:n
        
    imgOut    = zeros(r, c, col, 'single');
    totWeight = zeros(r, c, col, 'single');

    for j=0:(target - 1)
        
        if((i + j) <= n)            
            tmpStack = stack(:,:,:,i + j);

            if(isa(tmpStack, 'single'))
                tmpStack = ClampImg(tmpStack, 0.0, 1.0);
            end

            if(isa(tmpStack, 'double'))
                tmpStack = ClampImg(single(tmpStack), 0.0, 1.0);
            end

            if(isa(tmpStack, 'uint8'))
                tmpStack = single(tmpStack) / 255.0;
            end

            if(isa(stack, 'uint16'))
                stack = single(tmpStack) / 65535.0;
            end

            if(j > 0)
                weight = AkyuzTau(tmpStack);
            else
                weight = ones(r, c, col, 'single');
            end
            
            switch lin_type
                case 'gamma2.2'
                    tmpStack = tmpStack.^2.2;

                case 'sRGB'
                    tmpStack = ConvertRGBtosRGB(tmpStack, 1);

                case 'tabledDeb97'
                    tmpStack = tabledFunction(tmpStack, lin_fun);            
                otherwise
            end
          
            %Calculation of the weight function   
            t = stack_exposure(i + j);
            
            weight = weight * t;

            if(t > 0.0)
                imgOut    = imgOut + (weight .* tmpStack) / t;
                totWeight = totWeight + weight;
            end
        end        
    end
    
    totWeight(totWeight <= 0.0) = 1.0;
    imgOut = imgOut ./ totWeight;
    stack(:,:,:,i) = ClampImg(imgOut * stack_exposure(i), 0.0, 1.0);
    
end

end