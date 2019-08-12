function imgOut = normalizeFromAnything(img)
%
%       imgOut = normalizeFromAnything(img)
%
%
%       input:
%         - img: an image
%
%       output:
%         - imgOut: an image with value in [0,1]
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
%     The paper describing this technique is:
%     "Video Matching"
% 	  by Peter Sand and Seth Teller, MIT Computer Science and Aritficial
% 	  Intelligence Laboratory, Technical Report, November 11 2004.
%

imgOut = [];

if(isa(img, 'uint8'))
    imgOut = single(img) / 255.0;
end

if(isa(img, 'uint16'))
    imgOut = single(img) / 65535.0;
end

if(isa(img, 'double') | isa(img, 'single'))
    max_val = max(img(:));
    if(max_val > 1.0) 
        imgOut = img / max_val;
    end
end

if(isempty(imgOut))
    imgOut = img;
end

end