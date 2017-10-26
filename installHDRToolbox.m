%
%     HDR Toolbox Installer
%
%     Copyright (C) 2011-2013  Francesco Banterle
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

disp('Installing the HDR Toolbox...');

folder = cellstr('Alignment');
folder = [folder, cellstr('Alignment/util')];
folder = [folder, cellstr('BatchFunctions')];
folder = [folder, cellstr('ColorCorrection')];
folder = [folder, cellstr('ColorSpace')];
folder = [folder, cellstr('Compression')];
folder = [folder, cellstr('Compression_video')];
folder = [folder, cellstr('Compression_video/util')];
folder = [folder, cellstr('Deghosting')];
folder = [folder, cellstr('Deghosting/util')];
folder = [folder, cellstr('EnvironmentMaps')];
folder = [folder, cellstr('EO')];
folder = [folder, cellstr('EO/util')];
folder = [folder, cellstr('Formats')];
folder = [folder, cellstr('Generation')];
folder = [folder, cellstr('Generation/util')];
folder = [folder, cellstr('Generation_video')];
folder = [folder, cellstr('Generation_video/util')];
folder = [folder, cellstr('IBL')];
folder = [folder, cellstr('IBL/util')];
folder = [folder, cellstr('IO')];
folder = [folder, cellstr('IO_stack')];
folder = [folder, cellstr('IO_video')];
folder = [folder, cellstr('LaplacianPyramids')];
folder = [folder, cellstr('Metrics')];
folder = [folder, cellstr('Metrics/util')];
folder = [folder, cellstr('NativeVisualization')];
folder = [folder, cellstr('Tmo')];
folder = [folder, cellstr('Tmo/util')];
folder = [folder, cellstr('Tmo_video')];
folder = [folder, cellstr('Tools')];
folder = [folder, cellstr('util')];

for i=1:length(folder)
    addpath([pwd(), '/source_code/', char(folder(i))], '-begin');
end

addpath([pwd(), '/demos/'], '-begin');

savepath

clear('folder');

disp('done!');

disp(' ');
disp('Check demos in the folder ''demos'' for learning how to use the HDR Toolbox!');
disp(' ');
disp('If you use the toolbox in your research, please reference the book in your papers:');
disp('@book{Banterle:2011,');
disp('      author = {Banterle, Francesco and Artusi, Alessandro and Debattista, Kurt and Chalmers, Alan},');
disp('      title = {Advanced High Dynamic Range Imaging: Theory and Practice},');
disp('      year = {2011},');
disp('      isbn = {9781568817194},');
disp('      publisher = {AK Peters (CRC Press)},');
disp('      address = {Natick, MA, USA},');
disp('      }');

disp(' ');
disp('Note on Tone Mapping:');
disp('The majority of TMOs return tone mapped images with linear values. This means that gamma encoding');
disp('needs to be applied to the output of these TMOs before visualization or before writing tone mapped images');
disp(' on the disk; otherwise these images may appear dark.');
disp('A few operators (e.g. Mertens et al.''s operator) return gamma encoded values,');
disp('so there is no need to apply gamma to them; in this case a message (e.g. a Warning) is displayed');
disp('after tone mapping alerting that there is no need of gamma encoding.');

disp(' ');
disp('Note on Expansion Operators (Inverse/Reverse Tone Mapping):');
disp('The majority of EOs require to have as input LDR images in the range [0,1] that are LINEARIZED. ');
disp('This means that the camera response function (CRF) or the gamma encoding has been removed.');
disp('This operation is MANDATORY in order to generate fair comparisons; ');
disp('please do use the gammaRemoval parameter to remove gamma if you do not have the CRF of the input image. ');
disp('RAW files do not require this step because they are already linear.');

str_cur = pwd();
try
    cd([str_cur, '/source_code/IO/']);
    mex('read_exr.cpp');
    mex('write_exr.cpp');
catch err    
    disp('read_exr.cpp and write_exr.cpp were not compiled');
end

try
    cd([str_cur, '/source_code/util/']);
    mex('bilateralFilterS.cpp');
catch err
    disp('bilateralFilterS.cpp was not compiled');
end

cd(str_cur);

