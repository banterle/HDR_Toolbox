function target_exposure = GalloReferenceImage(stack, folder_name, format)
%
%
%        index = GalloReferenceImage(stack)
%
%
%        Input:
%           -stack: a stack (4D) containing all images.
%           -folder_name: the folder name where the stack is stored. This flag
%           is valid if stack is empty, [].
%           -format: the file format of the stack. This flag is valid if
%           stack is empty, [].
%
%        Output:
%   `       -reference_exposure: the index of the reference image in the stack.
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
%     "Artifact-free High Dynamic Range Imaging"
% 	  by  O. Gallo, N. Gelfand, W. Chen, M. Tico, and K. Pulli. 
%     in IEEE International Conference on Computational Photography (ICCP)
%     2009
%

bStack = ~isempty(stack);

if(~bStack)
    lst = dir([folder_name, '/*.', format]);
    n = length(lst);
else
    n = size(stack, 4);
end

t_oe = 248 / 255;
t_ue =   7 / 255;

target_exposure = -1;

for i=1:n
    if(bStack)
        current_exposure = stack(:,:,:,i);
    else
        current_exposure = ldrimread([folder_name, '/', lst(i).name]);
    end
    
    r = size(current_exposure, 1);
    c = size(current_exposure, 2);
    
    if(i == 1)
        value = r * c;            
    end
    
    over_exp = max(current_exposure, [], 3);
    under_exp = min(current_exposure, [], 3);
    
    mask_oe = zeros(r, c);
    mask_oe(over_exp >= t_oe) = 1;

    mask_ue = zeros(r, c);
    mask_ue(under_exp <= t_ue) = 1;

    mask = mask_oe + mask_ue;
    mask(mask > 1) = 1;
    
    tmp_value = sum(mask(:));
    
    if(tmp_value < value) 
        target_exposure = i;
        value = tmp_value; 
    end    
end

end