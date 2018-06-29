function imgOut = bilateralNoiseRemoval(img, sigma_s, sigma_r)
%                                                                                   
%       imgOut = bilateralNoiseRemoval(img, sigma_s, sigma_r)
%
%
%        Input:
%           -img: input image to be denoised
%           -simga_s: spatial sigma; size of the neighborhood to be used
%           for denosing
%           -sigma_r: range sigma; what intesities to use for filtering
%
%        Output:
%           -imgOut: filtered denoised image
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

col = size(img,3);

if(~exist('sigma_s', 'var'))
    sigma_r = 4;
end

if(sigma_s<4)
    sigma_s = 4;
end

if(~exist('sigma_r', 'var'))
    sigma_r = 0.01;
end

if(sigma_r <= 0.0)
    sigma_r = 0.01;
end

switch col
	case 1
    	minC = min(img(:));
        maxC = max(img(:));
        delta = (maxC - minC);        
        img = (img - minC) / delta;
        imgOut = bilateralFilter(img, [], 0.0, 1.0, sigma_s, sigma_r) * delta + minC;
            
    case 3
        imgLab = ConvertXYZtoCIELab(ConvertRGBtoXYZ(img, 0), 0);
            
        for i=1:col
            tmp = imgLab(:,:,i);
            minC = min(tmp(:));
            maxC = max(tmp(:));
            delta = (maxC - minC);            
            tmp = (tmp - minC) / delta;
            imgLab(:,:,i) = bilateralFilter(tmp,[], 0.0, 1.0,sigma_s,sigma_r) * delta + minC;
        end
            
        imgOut = ConvertRGBtoXYZ(ConvertXYZtoCIELab(imgLab,1),1);
            
    otherwise
        imgOut = zeros(size(img));
        
        for i=1:col
            tmp = img(:,:,i);
            minC = min(tmp(:));
            maxC = max(tmp(:));
            delta = (maxC - minC);
            tmp = (tmp - minC) / delta;
            imgOut(:,:,i) = bilateralFilter(tmp, [], 0.0, 1.0,sigma_s, sigma_r) * delta + minC;
        end
end

end

