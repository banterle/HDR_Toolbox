function imgOut = GammaTMO(img, TMO_gamma, TMO_fstop, TMO_view)
%
%        imgOut = GammaTMO(img, TMO_gamma, TMO_fstop, TMO_view);
%
%        This function applies exposure (in f-stops) and inverse gamma
%        correction to an image. The function can visualize images if
%        TMO_view is set to true (1).
%
%        Input:
%           -img: image to be tonemapped
%           -TMO_gamma: gamma correction value
%           -TMO_fstop: f-stop value
%           -TMO_view: boolean for displaying the image
%
%        Output:
%           -imgOut: gamma corrected exposure
%
%     Copyright (C) 2011-12  Francesco Banterle
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

checkNegative(img);

if(~exist('TMO_gamma','var'))
    TMO_gamma = 2.2;
end

if(TMO_gamma <= 0.0)
    error('TMO_gamma must be a positive scalar.');
end

if(~exist('TMO_fstop','var'))
    TMO_fstop = 0.0;
end

if(~exist('TMO_view','var'))
    TMO_view = 0;
end

invGamma = 1.0 / TMO_gamma;
exposure = 2.^TMO_fstop;

%clamping values out of the range [0.0,1.0]
imgOut = ClampImg((exposure .* img).^invGamma, 0, 1);

if(TMO_view)
    imshow(imgOut);
end

end
