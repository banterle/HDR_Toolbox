function ConvHDRtoStack(fmtIn, fmtOut, bSampling, ldr_gamma)
%
%        ConvHDRtoStack(fmtIn, fmtOut, bSampling, ldr_gamma)
%
%        
%        For example:
%           ConvLDRtoLDR('hdr', 'jpg', 2.2);
%
%        This lines tonemaps all the .hdr files in the folder using the 
%        Reinhard et al.'s operator and it saves them as .jpg files using
%        gamma 2.2
%
%        Input:
%           -fmtIn: an input string represeting the LDR format of the images
%           to be converted. This can be: 'hdr', 'pfm'
%           -fmtOut: an input string represeting the LDR format of
%           converted images. This can be: 'jpeg', 'jpg', 'png', etc.
%           -bSampling: using or not histogram sampling
%           -ldr_gamma: the encoding gamma for the LDR images. The default
%           value is 2.2
%
%        Output:
%           -ret: a boolean value, true or 1 if the method succeeds
%
%     Copyright (C) 2012-15  Francesco Banterle
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

if(~exist('bSampling', 'var'))
    bSampling = 0;
end

if(~exist('ldr_gamma', 'var'))
    ldr_gamma = 2.2;
end

lst = dir(['*.', fmtIn]);

for i=1:length(lst)
    disp(lst(i).name);
    
    tmp_name = lst(i).name;    
    img = hdrimread(tmp_name);
    L = lum(img);    
    L = imresize(L, 0.5, 'bilinear');
    
    if(bSampling)
        fstops = ExposureHistogramSampling(L, 8, 2);
    else
        minL = round(log2(min(L(:))));
        maxL = round(log2(max(L(:))));
        fstops = -maxL:-minL; 
    end
    
    for j=1:length(fstops)   
        disp(fstops(j));
        img_exp_j = GammaTMO(img, ldr_gamma, fstops(j));
        
        bSkip = 0;
        if(~bSampling)
            tImg1 = ClampImg(round(255 * img_exp_j) / 255, 0, 1);
            val = mean(tImg1(:)); %mean value

            if((val < 0.1) || (val > 0.9))
                bSkip = 1;
            end
   
        end
            
        if(~bSkip)
            tmp_name_we = RemoveExt(tmp_name);
            tmp_name_out = [tmp_name_we, '_fstop_', num2str(j), '.', fmtOut];
            imwrite(img_exp_j, tmp_name_out);
        end
    end       
end

end