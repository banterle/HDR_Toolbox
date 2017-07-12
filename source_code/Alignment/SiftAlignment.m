function stackOut = SiftAlignment(stack, bStackOut, folder_name, format, target_exposure)
%
%
%       stackOut = SiftAlignment(stack, bStackOut, folder_name, format,
%       target_exposure)
%
%       This function shifts pixels on the right with wrapping of the moved
%       pixels. This can be used as rotation on the Y-axis for environment
%       map encoded as longituted-latitude encoding.
%
%       Input:
%           -stack: a stack (4D) containing all images.
%           -folder_name: the folder name where the stack is stored. This flag
%           is valid if stack=[]
%           -format: the file format of the stack. This flag is valid if
%           stack=[].
%           -target_exposure: The index of the target exposure for aligning
%           images. If stack is empty, [], it contains the name of the file
%           for the alignment. If not provided the stack will be analyzed.
%
%       Output:
%           -stackOut: the aligned stack as output
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

if(~exist('folder_name', 'var'))
    folder_name = '';
end

if(~exist('format', 'var'))
    format = '';
end

lst = [];

stackOut = [];

bStack = ~isempty(stack);

if(~bStack)
    lst = dir([folder_name, '/*.', format]);
    n = length(lst);
else
    n = size(stack, 4);
    stack = normalizeFromAnything(stack);
end

if(n < 2)
    return;
end

if(~exist('target_exposure', 'var'))
    target_exposure = GalloReferenceImage(stack, folder_name, format); 
else
    if(~bStack)
        target_exposure = findNameInList(lst, target_exposure);
    end
end

if(bStack)
    img = stack(:,:,:,target_exposure);
else
    img = ldrimread([folder_name, '/', lst(target_exposure).name], 0);
end

[r,c,col] = size(img);

if(bStackOut)
    stackOut = zeros(r, c, col, n);
    stackOut(:,:,:,target_exposure) = img;
end

for i=1:n
    
    if(i ~= target_exposure)
        disp(['Aligning image ', num2str(i), ' to image ', num2str(target_exposure)]);
       
        if(~bStack)
            img_work = ldrimread([folder_name, '/', lst(i).name], 0);
        else
            img_work = stack(:,:,:,i);
        end

        img_work_aligned = SiftImageAlignment(img, img_work);
        
        if(bStackOut)
            stackOut(:,:,:,i) = img_work_aligned;
        end
        
        if(~bStack)
            name = strrep(lst(i).name, ['.',format], ['_aligned.', format]);
            if(strcmp(lst(i).name, name) == 1)
                name = [name, '_align.', format];
            end
            
            imwrite(img_work_aligned, [folder_name, '/', name]);
        end
        
        clear('img_work_aligned');
        clear('img_work');
    end
end

end