function weight = WeightFunction(img, weight_type, bMeanWeight, bounds, pp)
%
%       weight = WeightFunction(img, weight_type, bMeanWeight, bounds, pp)
%
%
%        Input:
%           -img: input LDR image in [0,1]
%           -weight_type:
%               - 'all': weight is set to 1
%               - 'identity': it returns img
%               - 'reverse': it returns (1 - img)
%               - 'hat': hat function 1 - (2 * img - 1)^12
%               - 'poly': a polynomial where x is img
%               - 'box': weight is set to 1 in [bounds(1), bounds(2)]
%               - 'Deb97': Debevec and Malik 97 weight function
%               - 'Robertson': a Gaussian with shifting and scaling
%           -bMeanWeight:
%           -bounds: range of valid values for Deb97 and box
%           -pp:
%
%        Output:
%           -weight: the output weight function for a given LDR image
%
%     Copyright (C) 2011-15  Francesco Banterle
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

if(~exist('bMeanWeight', 'var'))
    bMeanWeight = 0;
end

if(~exist('bounds', 'var'))
    bounds = [0, 1];
end

col = size(img, 3);
if((size(img, 3) > 1) && bMeanWeight)
    L = mean(img, 3);
    
    for i=1:col
        img(:,:,i) = L;
    end
end

if(strcmp(weight_type, 'Deb97_p05'))
    bounds = [0.05, 0.95];
    weight_type = 'Deb97';
end

switch weight_type
    case 'all'
        weight = ones(size(img));

    case 'identity'
        weight = img;
        
    case 'reverse'
        weight = 1.0 - img;

    case 'box'
        weight = ones(size(img));
        weight(img < bounds(1)) = 0.0;
        weight(img > bounds(2)) = 0.0;        
        
    case 'Robertson'
        shift    = exp(-4);
        scaleDiv = (1.0 - shift);
        t = img - 0.5;
        weight = (exp(-16.0 * (t .* t) ) - shift) / scaleDiv;
            
    case 'hat'
        weight = 1 - (2 * img - 1).^12;
        
    case 'poly'              
        weight = zeros(size(img));
        
        for i=1:size(img, 3)
            d_pp = polyder(pp(:, i)');
            weight(:,:,i) = polyval(pp(:, i), img) ./ polyval(d_pp, img);
        end
        
    case 'Deb97'
        Zmin = bounds(1);
        Zmax = bounds(2);
        tr = (Zmin + Zmax) / 2;
        delta = Zmax - Zmin;
        
        indx1 = find (img <= tr);
        indx2 = find (img > tr);
        weight = zeros(size(img));
        weight(indx1) = img(indx1) - Zmin;
        weight(indx2) = Zmax - img(indx2);
        
        if(delta > 0.0)
            weight = weight / tr;
        end
        
        
    otherwise 
        weight = -1;
end

weight(weight < 0.0) = 0.0;
weight(weight > 1.0) = 1.0;

end