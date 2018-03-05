function [Q, S, N, s_maps, s_local] = TMQI(hdrImage, ldrImage, window)
%
%       [Q, S, N, s_maps, s_local] = TMQI(hdrImage, ldrImage, window)
%
%
%       -Input :
%           -hdrImage: the HDR image being used as reference. The HDR 
%                      image must be an m-by-n-by-3 single or double array
%           -ldrImage: the LDR image being compared with values in [0,255]
%           -window: local window for statistics (see the above
%                    reference). default widnow is Gaussian given by
%                    window = fspecial('gaussian', 11, 1.5);
%
%       -Output:
%           -s_maps: The structural fidelity maps of the LDR image.     
%           -s_local: the mean of s_map in each scale (see above refernce).
%           -S: The tructural fidelity score of the LDR test image. 
%           -N: The statistical naturalness score of the LDR image.
%           -Q: The TMQI score of the LDR image. 
%
%       -Basic Usage:
%           Given LDR test image and its corresponding HDR images, 
%
%               [Q, S, N, s_maps, s_local] = TMQI(hdrImage, ldrImage);
%
%       -Advanced Usage: User defined parameters. For example
%               window = ones(8);
%               [Q, S, N, s_maps, s_local] = TMQI(hdrImage, ldrImage, window);
%
%       -Notes:
%           This is an implementation of an objective image quality
%           assessment model for tone mapped low dynamic range (LDR) images
%           using their corresponding high dynamic range (HDR) images as 
%           references.
% 
%       -Citing:
%           Please refer to the following paper and the website with 
%           suggested usage
%
%           H. Yeganeh and Z. Wang, "Objective Quality Assessment of Tone Mapped
%           Images," IEEE Transactios on Image Processing, vol. 22, no. 2, pp. 657- 
%           667, Feb. 2013.
%
%           http://www.ece.uwaterloo.ca/~z70wang/research/tmqi/
%
%       -Contact:
%           Kindly report any suggestions or corrections to
%           hyeganeh@ieee.org, hojat.yeganeh@gmail.com, or zhouwang@ieee.org
%
%
%     Copyright (C) 2012  Hojatollah Yeganeh and Zhou Wang
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

if (nargin < 2 || nargin > 3)
   s_maps = -Inf;
   s_local = -Inf;
   S = -Inf;
   N = -Inf;
   Q = -Inf;
   return;
end

if (size(hdrImage) ~= size(ldrImage))
   s_maps = -Inf;
   s_local = -Inf;
   S = -Inf;
   N = -Inf;
   Q = -Inf;
   return;
end

[M N D] = size(hdrImage);

if (nargin == 2)
   if ((M < 11) || (N < 11))
	   s_maps = -Inf;
       s_local = -Inf;
       S = -Inf;
       N = -Inf;
       Q = -Inf;
       disp('the image size is less than the window size'); 
     return
   end
   window = fspecial('gaussian', 11, 1.5);	%
end

if (nargin == 3)
   [H W] = size(window);
   if ((H*W) < 4 || (H > M) || (W > N))
	   s_maps = -Inf;
       s_local = -Inf;
       S = -Inf;
       N = -Inf;
       Q = -Inf;
      return
   end
end

%---------- default parameters -----
a = 0.8012;
Alpha = 0.3046;
Beta = 0.7088;
%---------- default parameters -----
level = 5;
weight = [0.0448 0.2856 0.3001 0.2363 0.1333];
%--------------------
L_hdr = lum(hdrImage);
lmin = min(L_hdr(:));
lmax = max(L_hdr(:));
L_hdr = double(round((2^32 - 1)/(lmax - lmin)).*(L_hdr - lmin));
%-------------------------------------------

L_ldr = lum(double(ldrImage));
lmax = max(L_ldr(:));
if(lmax <= 1.0)
    warning(['It seems this is a normalized LDR image with values in [0,1].'
        'This means that the algorithm will produce wrong results.'
        'If this is the case please multiply ldrImage by 255']);
end

%----------- structural fidelity -----------------
[S s_local s_maps] = TMQI_StructuralFidelity(L_hdr, L_ldr,level,weight, window);
%--------- statistical naturalness ---------------
N = TMQI_StatisticalNaturalness(L_ldr);
%------------- overall quality -----------------
Q =  a*(S^Alpha) + (1-a)*(N^Beta);

end


