function buildHDRFromPathManyFolders(path_stacks, path_crf, path_out)
%
%
%        buildHDRFromPathManyFolders(path_stacks, path_crf, path_out)
%
%        This builds a HDR image from path_images, if we have a color
%        checker for calibrating the CRF please set it to
%        path_color_checker.
%
%     Copyright (C) 2024  Francesco Banterle
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

lst = dir([path_stacks, '/*']);

path_out_full = [path_stacks, '/', path_out];
mkdir(path_out_full)

for i= 1:length(lst)
    name = lst(i).name;

    path_images_full = [path_stacks, '/', name];
    path_images_full = strrep(path_images_full, '//', '/');
    if isfolder(path_images_full)
        if (strcmp(name, '.') == 0) && (strcmp(name, '..') == 0)
            buildHDRFromPath(path_images_full, path_crf, [path_out_full, '/', name, '.hdr']);
        end
    end
end

end