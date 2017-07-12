function imgOut = imWhiteBalance(img)
%
%     imgOut = imWhiteBalance(img)
%
%     This functions crops an HDR image.
%
%     Input:
%       -img: an input image
%
%     Output:
%       -imgOut: an image
%
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


button = 0;
while(button ~= 3)
    img_tmo = ReinhardTMO(img);
    GammaTMO(img_tmo, 2.2, 0.0, 1);
    [x,y,button] = ginput(1);
    
    if(button ~= 3)
        window = img((y - 16):(y + 16), (x - 16):(x + 16), :);
        color = mean(mean(window));

        for i=1:size(img, 3)
            img(:,:,i) = img(:,:,i) / color(i);
        end
    end
end

imgOut = img;

end
