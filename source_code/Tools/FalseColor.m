function [imgOut, FC_MAX_L] = FalseColor(img, FC_compress, FC_Vis, FC_LMax, FC_figure, FC_title)
%
%
%       [imgOut, FC_MAX_L] = FalseColor(img, compress, FC_Vis, LMax)
%
%       This function creates a false color image for re-mapping luminance
%       into an LDR RGB image.
%
%       Input:
%           -img: the input img
%           -FC_compress: compression option for HDR images:
%               -'lin': no compression to the dynamic range (it typically creates
%               good results for LDR images only!)
%               -'log': the HDR domain is compressed using natural
%               logarithm (default parameter)
%               -'log2': the HDR domain is compressed using base 2
%               logarithm
%               -'log10': the HDR domain is compressed using base 10
%               logarithm
%               -'sigmoid': the HDR domain is compressed using a basic
%               sigmoid curve
%           -FC_Vis: a boolean parameter. If it is set to 1, it will show.
%           Default values is 1, so the image will visualized
%           the image as a complete figure including the visualization bar
%           -FC_LMax: the maximum luminance for the color re-mapping functions.
%               This needs to be used when creating false color images with the same scale. 
%           -FC_figure: index for the figure
%           -FC_title: title for the false color window
%           
%       Output:
%           -imgOut: the false color LDR and RGB image (no gamma is
%           required for visualization purposes)
%           -FC_MAX_L: the maxium luminance value in the selected
%           FC_compress domain
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

L = lum(img);

if(~exist('FC_Vis', 'var'))
    FC_Vis = 1;
end

if(~exist('FC_compress', 'var'))
    FC_compress = 'log';
end

if(~exist('FC_figure', 'var'))
    FC_figure = 1;
end

if(~exist('FC_title', 'var'))
    FC_title = 'False color visualization';
end

%minimum luminance
LMin = min(L(:));

%maximum luminance
if(~exist('FC_LMax', 'var'))
    LMax = max(L(:));
else
    if(FC_LMax<0)
        LMax = max(L(:));
    else
        tLMax = max(L(:));
        if(FC_LMax < tLMax)
            LMax = tLMax;
        else
            LMax = FC_LMax - MinL;
        end
    end
end

FC_MAX_L = LMax;

%luminance compression
epsilon = 1e-6; %for avoiding singularities
switch FC_compress
    case 'log2'
        L = log2(L + epsilon);
        LMax = log2(LMax + epsilon);
        LMin = log2(LMin + epsilon);   
        
    case 'log'
        L = log(L + epsilon);    
        LMax = log(LMax + epsilon);
        LMin = log(LMin + epsilon);
        
    case 'log10'
        L = log10(L + epsilon);
        LMax = log10(LMax + epsilon);
        LMin = log10(LMin + epsilon);
        
    case 'sigmoid'
        L = (L ./ (L + 1.0)).^(1.0 / 2.2);
        LMax = (LMax ./ (LMax + 1.0)).^(1.0 / 2.2);
        LMin = (LMin ./ (LMax + 1.0)).^(1.0 / 2.2);
        
    otherwise
end

%creating ticks for the visualization
if(FC_Vis)
    delta = LMax - LMin;
    yticks = LMin:(delta / 4):LMax;

    switch FC_compress
        case 'log2'
            yticks = 2.^yticks - epsilon;
        case 'log'
            yticks = exp(yticks) - epsilon;
        case 'log10'
            yticks = 10.^yticks - epsilon;
        case 'sigmoid'
            yticks = yticks.^2.2;
            yticks = yticks ./ (1.0 - yticks);
        otherwise
    end
end

L = L - LMin;
LMax = LMax - LMin;
L = L / LMax;

contrast = 1.0;
L = L.^(1.0 / contrast);

%Create a color map
n_bit = 8;
res = 2^n_bit;
color_map = colormap(jet(res));

%Coloring using the colormap
L = ClampImg(round(L * res), 1, res);
imgOut = ind2rgb(L, color_map);

if(FC_Vis)%Visualization  
    h = figure(FC_figure);
    set(h, 'Name', FC_title);
    imshow(imgOut, 'InitialMagnification', 'fit');
    colormap(color_map);
         
    hcb = colorbar('Ticks', 0:(1/4):1 ,'YtickLabel',{sprintf('%2.1e', yticks(1)), sprintf('%2.1e', yticks(2)), sprintf('%2.1e', yticks(3)), sprintf('%2.1e', yticks(4)), sprintf('%2.1e', yticks(5))});
    set(hcb,'FontSize', 24);
    set(hcb,'FontName', 'Times New Roman');
    
    pos = hcb.Position;
    
    set(get(hcb,'XLabel'), 'Rotation', 0, 'String', 'Lux', 'FontSize', 24, 'FontName', 'Times New Roman', 'Position', [pos(1), 0.0 , 0.0]);
end

end
