%
%       HDR Toolbox demo 3:
%	   1) Load "CS_Warwick.hdr" HDR image
%	   2) Change the mapping from Longitude Latitude to Cube Map
%	   3) Show the new HDR image using gamma encoding
%	   4) Write the cube map on the disk
%	   5) Write on the disk each face of the cube map ready for OpenGL or
%	   Direct3D
%
%       Author: Francesco Banterle
%       Copyright June 2012 (c)
%
%

clear all;

disp('1) Load "CS_Warwick.hdr" HDR image');
img = hdrimread('CS_Warwick.hdr');

disp('2) Change the mapping from Longitude Latitude to Cube Map');
imgOut = ChangeMapping(img,'LongitudeLatitude', 'CubeMap');

disp('3) Visualization of the new HDR image using gamma encoding');
ldr = GammaTMO(imgOut,2.2,0.0,1);

disp('4) Write the cube map on the disk');
hdrimwrite(imgOut,'CS_Warwick_CUBE_MAP_format.hdr');

disp('5) Write each face of the cube map on the disk');
CrossCutter(imgOut,'CS_Warwick_CM','hdr');