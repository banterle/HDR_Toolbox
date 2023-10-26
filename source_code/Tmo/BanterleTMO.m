function [imgOut, BTMO_segments, BTMO_which_operator] = BanterleTMO(img, BTMO_segments, BTMO_rescale)
%
%
%        [imgOut, BTMO_segments, BTMO_which_operator] = BanterleTMO(img, BTMO_segments, BTMO_rescale)
%
%
%       Input:
%           -img: an HDR image with calibrated data in cd/m^2.
%           Note that this algorithm was tested with values
%           from 0.015cd/m^2 to 3,000 cd/m^2
%           -BTMO_segments: a segmented image, each value in a segment is a
%           dynamic range zone; i.e. integer values in [-6,9]. If it is not
%           provided this will be computed with the function CreateSegments
%           -BTMO_rescale: the img luminance values are display-referred to
%           the DR37P monitor used in the experiments.
%
%       Output:
%           -imgOut: the tone mapped image using the HybridTMO
%           -BTMO_segments: the segmentation output; the input image is
%           segmented into different zones of dynamic range
%           -BTMO_which_operator: is a string which outputs if only
%           DragoTMO is used, if only Reinhard is used, or if the full
%           BanterleTMO is used.
% 
%       This TMO is an hybrid operator which merges different
%       Tone Mapping Operators: DragoTMO and ReinhardTMO.
%
%     Copyright (C) 2013-15  Francesco Banterle
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
%     "Dynamic Range Compression by Differential Zone Mapping Based on 
%     Psychophysical Experiments"
% 	  by Francesco Banterle, Alessandro Artusi, Elena Sikudova, 
%     Thomas Edward William Bashford-Rogers, Patrick Ledda, Marina Bloj, Alan Chalmers 
%     in ACM Symposium on Applied Perception (SAP) - August 2012 
%
%

checkNegative(img);

if(~exist('BTMO_rescale', 'var'))
    BTMO_rescale = 1;
end

L = lum(img);

if(BTMO_rescale)
    L_max = MaxQuart(L, 0.999);

    if(L_max > 0.0)
        img = img / L_max * 3000.0;
        img = ClampImg(img, 0.015, 3000.0);
        L = lum(img);
    end
end

indx = find(L > 3000);
if(~isempty(indx))
    warning(['The input image has values over 3,000 cd/m^2. ', ...
        'These values were not tested in the original paper.']);
end

indx = find(L < 0.015);
if(~isempty(indx))
    warning(['The input image has values under 0.015 cd/m^2. ', ...
        'These values were not tested in the original paper.']);
end

%segmentation
if(~exist('BTMO_segments', 'var'))
    BTMO_segments = CreateSegments(img);
else    
    if(isempty(BTMO_segments))
        BTMO_segments = CreateSegments(img);        
    else        
        BTMO_segments = round(BTMO_segments);
    end
end

%TMO look-up table for determing the best
%TMO depending on the luminance zone. These
%values were extracted from a psychophysical
%experiment.
% 0 ---> Drago et al. 2003
% 1 ---> Reinhard et al. 2002
LumZone     = [-2, -1, 0, 1, 2, 3, 4];
TMOForZone =  [ 0,  0, 1, 0, 1, 0, 0];

%mask
mask = zeros(size(BTMO_segments));

for i=1:length(LumZone)
    mask(BTMO_segments == LumZone(i)) = TMOForZone(i);
end

imwrite(mask, 'mask.png');
%check for Drago et al.'s operator
indx0 = find(mask == 1);

%check for Reinhard et al.'s operator
indx1 = find(mask == 0);

%are both TMOs used?
if(~isempty(indx0) && ~isempty(indx1)) %pyramid blending with gamma encoding
    img_dra_tmo = DragoTMO(img);
    img_rei_tmo = ReinhardTMO(img, 0.5, -1, 'local', -1);

    gamma = 2.2;
    invGamma = 1.0 / gamma;
    imgA   = img_rei_tmo.^invGamma;
    imgB   = img_dra_tmo.^invGamma;
    
    imwrite(imgA, 'banterle_rei.png');
    imwrite(imgB, 'banterle_dra.png');
    imwrite(mask, 'banterle_mask.png');
    
    %removing gamma for linear output
    imgOut = pyrBlend(imgA, imgB, mask).^gamma;
    imwrite(imgOut.^invGamma, 'banterle_mix.png');
    
    BTMO_which_operator = 'BanterleTMO';
else
    %Only Reinhard et al.'s operator?
    length(indx1)
    length(indx0)
    if(isempty(indx1))
        imgOut = ReinhardTMO(img, -1, -1, 'bilateral', -1);
        BTMO_which_operator = 'ReinhardTMO';
        disp('The BanterleTMO is using ReinhardTMO only');
    end
    
    %Only Drago et al.'s operator?
    if(isempty(indx0))
        imgOut = DragoTMO(img);
        BTMO_which_operator = 'DragoTMO';
        disp('The BanterleTMO is using DragoTMO only');
    end    
end

end
