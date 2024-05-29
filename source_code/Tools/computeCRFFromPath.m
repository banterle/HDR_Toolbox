function lin_fun = computeCRFFromPath(path_crf, path_out)
%
%
%        lin_fun = computeCRFFromPath(path_crf, path_out)
%
%        This estimates a Camera Response Function (CRF) from path_crf,
%        if we have a color checker or a colorful scene for calibrating the CRF.
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

if ~isfolder(path_crf)
    error('path_images is not a folder');
end

[stack_crf, ~] = ReadLDRStack(path_crf, format, 1);
stack_crf_exposure = ReadLDRStackInfo(path_crf, format);
[lin_fun, ~] = DebevecCRF(stack_crf, stack_crf_exposure, 256);

fid = fopen([path_out, '/crf.txt'], 'w');
[r,c] = size(lin_fun);

for i=1:r
    fprintf(fid, '%3.3f %3.3f %3.3f\n', lin_fun(i,1), lin_fun(i,2), lin_fun(i,3));
end
fclose(fid);

end