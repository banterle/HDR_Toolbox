function imgOut = ChiuGlare(img, glare_opt)
%
%       imgOut = ChiuGlare(img, glare_opt )
%
%       This function applies glare to an image
%
%        Input:
%           -img: an input image
%           -glare_opt(1): [0,1]. The default value is 0.8. If it is negative,
%                          the glare effect will not be calculated in the
%                          final image.
%           -glare_opt(2): appearance (1,+Inf]. Default is 8.
%           -glare_opt(3): size of the filter for calculating glare. Default is 121.
%
%        Output:
%           -imgOut: an image with glare
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
%     The paper describing this technique is:
%     "Spatially Nonuniform Scaling Functions for High Contrast Images"
% 	  by Kenneth Chiu and M. Herf and Peter Shirley and S. Swamy and Changyaw Wang and Kurt Zimmerman
%     in Proceedings of Graphics Interface '93
%

if(~exist('glare_opt', 'var'))
    glare_opt(1) = 0.8;
    glare_opt(2) = 8;    
    glare_opt(3) = 121;
end

if(isempty(glare_opt))
    glare_opt(1) = -1;
end

if(glare_opt(1) > 0)
    %calculate a kernel with a Square Root shape for simulating glare
    window2 = round(glare_opt(3) / 2);
    [x, y] = meshgrid(-1:1 / window2:1,-1: 1 / window2:1);
    H3 = (1 - glare_opt(1)) * (abs(sqrt(x.^2 + y.^2) - 1)).^glare_opt(2);    
    H3(window2 + 1, window2 + 1)=0;

    %circle of confusion of the kernel
    distance = sqrt(x.^2 + y.^2);
    H3(distance > 1) = 0;

    %normalize the kernel
    H3 = H3 / sum(H3(:));
    H3(window2 + 1, window2 + 1) = glare_opt(1);
   
    %filter
    imgOut = imfilter(img, H3, 'replicate');
else
    imgOut = img;
end

end

