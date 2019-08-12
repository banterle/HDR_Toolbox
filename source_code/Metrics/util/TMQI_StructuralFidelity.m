function [S s_local s_maps] = TMQI_StructuralFidelity(L_hdr, L_ldr,level,weight, window)
%
%       [S s_local s_maps] = TMQI_StructuralFidelity(L_hdr, L_ldr,level,weight, window)
%
%
%        Input:
%           -L_hdr: an HDR image
%           -L_ldr: an LDR image
%           -weight:
%           -window:
%
%        Output:
%           -S: 
%           -s_local: 
%           -s_maps:
%
%
%     Copyright (C) 2012 Hojatollah Yeganeh and Zhou Wang
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

downsample_filter = ones(2)./4;
f = 32;
for l = 1:level
    f = f/2;
    [s_local(l) smap] = TMQI_LocalStructuralFidelity(L_hdr, L_ldr, window , f);
    s_maps{l} = smap;
    filtered_im1 = imfilter(L_hdr, downsample_filter, 'symmetric', 'same');
    filtered_im2 = imfilter(L_ldr, downsample_filter, 'symmetric', 'same');
    clear L_hdr;
    clear L_ldr;
    L_hdr = filtered_im1(1:2:end, 1:2:end);
    L_ldr = filtered_im2(1:2:end, 1:2:end);
end

S = prod(s_local.^weight);
end
