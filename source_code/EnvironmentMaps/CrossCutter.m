function CrossCutter(img, cb_name, cb_format)
%
%        CrossCutter(img, cb_name, cb_format)
%
%
%        Input:
%           -img: input environment map encoded as a cubemap
%           -name: a string representing the prefix name for each face of
%            the cubemap. For example: 'output_cubemap' (default)
%           -format: the output format of each face of the cubemap. For
%           example: 'hdr' (default)
%        Output:
%           -ret: it is set to 1 if the function succeeded
%
%     Copyright (C) 2011  Francesco Banterle
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

if(~exist('cb_name', 'var'))
    cb_name = 'output_cube_map';
end

if(~exist('cb_format', 'var'))
    cb_name = 'hdr';
end

c = size(img, 2);

cubeSize = round(c / 3);

%CUBE_POS_Y
imgPosY = img(1:cubeSize,(cubeSize+1):(2*cubeSize),:);
imgPosY = imrotate(imgPosY, -270);
hdrimwrite(imgPosY,[cb_name,'_POS_Y.',cb_format]);

%CUBE_POS_X
hdrimwrite(img((cubeSize+1)    :(2*cubeSize),(cubeSize+1):(2*cubeSize),:),[cb_name,'_POS_X.',cb_format]);

%CUBE_NEG_Y
imgNegY = img((2*cubeSize+1):(3*cubeSize),(cubeSize+1):(2*cubeSize),:);
hdrimwrite(imrotate(imgNegY,-90),[cb_name,'_NEG_Y.',cb_format]);

%CUBE_NEG_X
imgNegX = img((3*cubeSize+1):(4*cubeSize),(cubeSize+1):(2*cubeSize),:); 
for i=1:3
    imgNegX(:,:,i) = flipud(imgNegX(:,:,i));
    imgNegX(:,:,i) = fliplr(imgNegX(:,:,i));
end
hdrimwrite(imgNegX,[cb_name,'_NEG_X.',cb_format]);

%CUBE_POS_Z
hdrimwrite(img((cubeSize+1):(2*cubeSize),1:cubeSize,:),[cb_name,'_POS_Z.',cb_format]);

%CUBE_NEG_Z
hdrimwrite(img((cubeSize+1):(2*cubeSize),(2*cubeSize+1):(3*cubeSize),:),[cb_name,'_NEG_Z.', cb_format]);

end