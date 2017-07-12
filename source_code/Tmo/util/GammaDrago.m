function imgOut = GammaDrago(img, drago_gamma, drago_slope, drago_start)
%
%        imgOut = GammaDrago(img, drago_gamma, drago_slope, drago_start)
%
%        This function applies gamma correction for the Drago et al.'s TMO,
%        please see DragoTMO.m
%
%        Input:
%           -img: an LDR image tone mapped with DragoTMO.m
%           -drago_gamma: is the elevation ratio of the line passing by the
%            origin and tangent to the curve
%           -drago_slope: f-stop value
%           -drago_start: is the abscissa at the point of tangency
%
%        Output:
%           -imgOut: gamma corrected img version
%
%     Copyright (C) 2013  Francesco Banterle
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

if(~exist('drago_gamma','var'))
    drago_gamma = 2.2;
end

if(~exist('drago_slope','var'))
    drago_slope = 4.5;
end

if(~exist('drago_start','var'))
    drago_start = 0.018;
end

%applying gamma correction as in Drago et al. 2003
indx1 = find(img<=drago_start);
indx2 = find(img> drago_start);
img(indx1) =  img(indx1)*drago_slope;
img(indx2) = (img(indx2).^(0.9/drago_gamma))*1.099-0.099;

%clamping values out of the range [0.0,1.0]
imgOut = ClampImg(img, 0.0, 1.0);

end