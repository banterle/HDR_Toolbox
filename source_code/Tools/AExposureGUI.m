function [img_cur_exp, exposure] = AExposureGUI(img, gamma_diplay)
%
%        [img_cur_exp, exposure] = AExposureGUI(img, gamma_diplay)
%
%        This function allows to explore the dynamic range in an image,
%        img. This is achieved by clicking with the left mouse button into
%        the image to change its exposure. The program ends when the user
%        presses the key ENTER or right mouse button.
%
%        Input:
%           -img: an HDR image
%           -gamma_diplay: display gamma value
%
%        Output:
%           -img_cur_exp: the input image with the last selected exposure
%           -exposure: the last click exposure
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

if(~exist('gamma_diplay', 'var'))
    gamma_diplay = 2.2;
end

L = lum(img);

bFlag = 1;

invGamma = 1.0 / gamma_diplay;
exposure = 0.25 / (mean(L(:)) + 1e-6);
kernelSize = 7;

img_cur_exp = (img * exposure);

while(bFlag)
    imshow(img_cur_exp.^invGamma);
    [x, y, button] = ginput(1);
 
    if(isempty(x) == 0)
        disp(['Coordinates (', num2str([x,y]), ')']);
        x = round(real(x));
        y = round(real(y));
        disp(['Pixel value: [', num2str(img(y,x,:)),']']);
        block = L((y - kernelSize):(y + kernelSize),(x - kernelSize):(x + kernelSize));
        
        exposure = 0.25 / mean(block(:));
        
        disp(['Exposure: ', num2str(exposure), 's']);
        disp(['F-stop: ', num2str(log2(exposure))]);
        
        img_cur_exp = (img * exposure);
        
        if(button == 3)
            bFlag = 0;
        end
    else
        bFlag = 0;
    end
end

end