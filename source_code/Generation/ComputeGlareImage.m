function imgGlare = ComputeGlareImage( img, PSF, hot_pixels_pos, C)
%
%       imgGlare = ComputeGlareImage( img, PSF )
%
%       This function computes the glare image of an input HDR image given
%       a point spread function (PSF) as a kernel.
%
%        Input:
%           -img: an HDR image
%           -PSF: a point spread function stored as a kernel
%           -hot_pixels_pos: hot pixels' coordinates
%
%        Output:
%           -imgGlare: the estimated glare in img.
%
%     Copyright (C) 2014  Francesco Banterle
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
%

m = size(hot_pixels_pos, 2);

imgGlare = zeros(size(img));

[r,c,col] = size(img);

[X, Y] = meshgrid(1:c, 1:r);

for i=1:m
    x_p = hot_pixels_pos(1, i);
    y_p = hot_pixels_pos(2, i);

    r = max(sqrt((X-x_p).^2 + (Y-y_p).^2), 1);
    value = C(1) + C(2)./r + C(3)./(r.^2) + C(4)./(r.^3);
    
    tmp_glare = zeros(size(img));
    
    for j=1:col
        tmp_glare(:,:,j) = value * img(y_p, x_p, j);
    end
    
    imgGlare = imgGlare + tmp_glare;
    
end

% 
% hot_pixels_col = zeros(m, size(img, 3));
% for i=1:m
%     hot_pixels_col(i, :) = img(hot_pixels_pos(2, i), hot_pixels_pos(1, i), :); 
% end
% 
% 
% PSF_col = zeros(size(PSF,1), size(PSF, 2), size(img, 3));
% for i=1:size(img, 3)
%     PSF_col(:,:,i) = PSF;
% end
%[imgGlare, ~] = imSplat(size(img, 1), size(img, 2), PSF_col, hot_pixels_pos, hot_pixels_col);

%compensation
while(1)
    ind = find(imgGlare > img);
       
    if(isempty(ind))
        break
    end
    
    scale = img(ind(1)) / imgGlare(ind(1));
    
    imgGlare = imgGlare * scale;
end 

end