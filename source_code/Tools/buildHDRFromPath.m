function imgHDR = buildHDRFromPath(path_images, path_crf, path_out)
%
%
%        imgHDR = buildHDRFromPath(path_images, path_crf, path_out)
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

format = 'jpg';

if ~isfolder(path_images)
    error('path_images is not a folder');
end

bSame = 0;
if (strcmp(path_crf, "") == 0) 
    if ~isfolder(path_crf)
        error('path_images is not a folder');
    end
else
    bSame = 1;
end

%read data for stack
[stack, ~] = ReadLDRStack(path_images, format, 1);
stack_exposure = ReadLDRStackInfo(path_images, format);

%compute the crf
if bSame == 1
    [lin_fun, ~] = DebevecCRF(stack, stack_exposure, 256);
else
    disp(path_crf);
    [stack_crf, ~] = ReadLDRStack(path_crf, format, 1);
    stack_crf_exposure = ReadLDRStackInfo(path_crf, format);
    
    [lin_fun, ~] = DebevecCRF(stack_crf, stack_crf_exposure, 256);
end

%build the HDR image
imgHDR = BuildHDR(stack, stack_exposure, 'LUT', lin_fun, 'Deb97', 'log');

hdrimwrite(imgHDR, path_out);

end