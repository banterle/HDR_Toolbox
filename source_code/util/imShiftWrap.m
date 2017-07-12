function imgOut = imShiftWrap(img, isw_dx)
%
%
%       imgOut = imShiftWrap(img, isw_dx)
%
%       This function shifts pixels on the right with wrapping of the moved
%       pixels. This can be used as rotation on the Y-axis for environment
%       map encoded as longituted-latitude encoding.
%
%       Input:
%           -img: an input image to be shifted with wrapping
%           -isw_dx: the amount in pixel for shifting the image on the
%           X-axis. This can be positive or negative
%
%       Output:
%           -imgOut: img shifted of isw_dx pixels on the X-axis
%
%     Copyright (C) 2012  Francesco Banterle
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

if(~exist('isw_dx','var'))
    isw_dx = 0;
end

imgOut = zeros(size(img));

if(abs(isw_dx) > 0)
    if(isw_dx > 0)
        imgOut(:,(isw_dx + 1):end,:) = img(:,1:(end - isw_dx),:);
        imgOut(:,1:isw_dx,:)       = img(:,(end - isw_dx + 1):end,:);
    else
        imgOut(:,1:(end + isw_dx),:)     = img(:,(1 - isw_dx):end,:);    
        imgOut(:,(end + isw_dx + 1):end,:) = img(:,1:( -isw_dx),:);    
    end
else
    imgOut = img;
end


end