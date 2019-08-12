function [motionMap, uv] = MotionEstimation(imgCur, imgNext, blockSize, maxSearchRadius, lambda_reg, bVisualize, me_bidi_mode)
%
%       [motionMap, uv] = MotionEstimation(imgCur, imgNext, blockSize, maxSearchRadius, lambda_reg, bVisualize, me_bidi_mode)
%
%       This function computes motion estimation between two consecutive frames
%
%       input:
%         - imgCur: current frame
%         - imgNext: next frame
%         - blockSize: size of the block
%         - maxSearchRadius: search size in blocks
%         - lambda_reg: regularization coefficient
%         - bVisualize: if it is set to 1 it visualizes the motion field 
%         - me_bidi_mode: it takes these inputs:
%               -'ldr': for LDR images
%               -'hdr': for HDR images
%
%       output:
%         - motionMap: motion map for each pixel
%
%     Copyright (C) 2013-16 Francesco Banterle
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

[r, c, ~] = size(imgCur);

if(~exist('bVisualize', 'var'))
    bVisualize = 0;
end

if(~exist('blockSize', 'var'))
    bAuto = 1;
else
    bAuto = strcmp(blockSize, 'auto');
end

if(bAuto)
    nPixels = r * c;
    blockSize = max([2^ceil(log10(nPixels)), 4]);
end

if(blockSize < 0)
    blockSize = 16;
end

if(~exist('maxSearchRadius', 'var'))
    maxSearchRadius = 2; %size in blocks
end

if(~exist('lambda_reg', 'var'))
    lambda_reg = 0;
end

if(~exist('me_bidi_mode', 'var'))
    me_bidi_mode = 'ldr';
end

switch me_bidi_mode
    case 'hdr'
        imgCur  = log10(imgCur  + 1e-6);
        imgNext = log10(imgNext + 1e-6);
end

shift = round(blockSize * maxSearchRadius);

block_r = ceil(r / blockSize);
block_c = ceil(c / blockSize);

motionMap = zeros(r, c, 3);

uv = zeros(block_r, block_c, 4);

k_vec = [];
l_vec = [];
n_vec = [];
for k=(-shift):shift
	for l=(-shift):shift
        k_vec = [k_vec, k];
        l_vec = [l_vec, l];
        n_vec = [n_vec, abs(k) + abs(l)];
    end
end

n_vec = n_vec / (2 * shift);

vec_n = length(k_vec);

for i=1:block_r   
    for j=1:block_c     
        dx = 0;
        dy = 0;
        err = 1e20;
                
        i_b1 = (i - 1) * blockSize + 1;
        i_e1 = min([i_b1 + blockSize - 1, r]);
        
        j_b1 = (j - 1) * blockSize + 1;
        j_e1 = min([j_b1 + blockSize - 1, c]);
        
        blockCur = imgCur(i_b1:i_e1, j_b1:j_e1, :);
        
        for p=1:vec_n
            i_b2 = i_b1 + k_vec(p);
            i_e2 = i_e1 + k_vec(p);            
            j_b2 = j_b1 + l_vec(p);
            j_e2 = j_e1 + l_vec(p);

            if( (i_b2 > 0) && (j_b2 > 0) && (i_e2 <= r) && (j_e2 <= c) )
            
                tmp_err = abs(blockCur - imgNext(i_b2:i_e2, j_b2:j_e2, :));
                tmp_err = mean(tmp_err(:)) + lambda_reg * n_vec(p);
                
                if(tmp_err < err)
                    err = tmp_err;
                    dx = l_vec(p);
                    dy = k_vec(p);
                end 
            end
        end
        
        motionMap(i_b1:i_e1,j_b1:j_e1, 1) = dx;
        motionMap(i_b1:i_e1,j_b1:j_e1, 2) = dy;
        motionMap(i_b1:i_e1,j_b1:j_e1, 3) = err;
        
        uv(i, j, 1) = (j_b1 + j_e1) / 2.0;
        uv(i, j, 2) = (i_b1 + i_e1) / 2.0;
        uv(i, j, 3) = dx;
        uv(i, j, 4) = dy;
    end
end

if(bVisualize > 0)
    figure(bVisualize)    
    quiver(uv(:, :, 1), r - uv(:, :, 2) + 1, uv(:, :, 3), -uv(:, :, 4));
end

end