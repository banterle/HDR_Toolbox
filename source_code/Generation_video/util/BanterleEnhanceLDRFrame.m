function frameOut = BanterleEnhanceLDRFrame(img1, img2, img_back_hdr, blendMode)
%
%
%        frameOut = BanterleEnhanceLDRFrame(img1, img2, img_back_hdr, blendMode)
%
%
%        Input:
%           -img1:
%           -img2:
%           -img_back_hdr:
%           -blendMode:
%        Output:
%           -frameOut:
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

    if(~exist('blendMode', 'var'))
        blendMode = 'linear';
    end
    
    [r, c, col] = size(img1);
    threshold1 = 0.7;
    
    debug = 0;

    %Luminance
    L1 = min(img1, [], 3);
    L2 = min(img2, [], 3);
 
    %base mask
    mask = zeros(size(L1));
    mask(L1 > threshold1) = 1;
    
    if(debug)
        imwrite(mask, 'mask_thr.png');
    end
    
    %extended mask
    diff = abs(L2 - L1);
    diff = imresize(diff, 0.125, 'bilinear');
    diff = GaussianFilter(diff, 2.0);
    diff = imresize(diff, [r, c],'bilinear');

    mask(diff > 0.1) = 0;

    if(debug)  
        imwrite(mask, 'mask_extended.png');
    end
    
    H = strel('disk', 4);  
    
    iterations = 2;
    for i=1:iterations
        mask = imerode(mask, H);
    end
    
    for i=1:iterations
        mask = imdilate(mask, H);
    end
    
    mask = bilateralFilter(mask, L1, 0, 1.0, 64.0, 0.05);
    
    %Avoid inversion      
    mask = GaussianFilter(mask, 2.0);   
        
    ref2 = imresize(img_back_hdr, 0.125, 'bilinear');
    ref2 = GaussianFilter(ref2, 4.0);
    ref2 = imresize(ref2, [r, c], 'bilinear');    
    
    if(debug)
        imwrite(mask, 'mask_extended_flt.png');    
    end
    
    frameOut = zeros(size(img_back_hdr));
                
    for j=1:col
        refG = img_back_hdr(:,:,j) .* mask + (1 - mask) .* ref2(:,:,j);
        tmp1 = log2(refG + 1);
        tmp2 = log2(img1(:,:,j) + 1);      

        switch blendMode
            case 'poisson'
                tmp3 = 2.^PoissonBlending(tmp1, tmp2, mask);
                
            case 'linear'
                tmp3 = 2.^(tmp1 .* mask + (1 - mask) .* tmp2) - 1;
        end
        
        tmp3(tmp3 < 0) = 0;
        frameOut(:,:,j) = tmp3;
    end
    
    frameOut = RemoveSpecials(frameOut);
    
end