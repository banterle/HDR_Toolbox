function cur_shift = WardGetExpShift(img1, img2, ward_percentile, shift_bits)
%
%
%       cur_shift = WardGetExpShift(img1, img2, ward_percentile, shift_bits)
%
%       This function computes the Ward's MTB.
%
%       Input:
%           -img1: the target image
%           -img2: the image that needs to be aligned to img1
%
%       Output:
%           -cur_shift: shifting vector for aligning img2 into img1.
%
%     Copyright (C) 2012-15  Francesco Banterle
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

if(~exist('ward_percentile', 'var'))
    ward_percentile = 0.5;
end

if(~exist('shift_bits', 'var'))
    shift_bits = 6;
end

cur_shift = zeros(2, 1);
shift_ret = zeros(2, 1);

while(shift_bits > 0)
    %computing MTB
    sml_img1 = imresize(img1, 2^(-shift_bits), 'bilinear');
    sml_img2 = imresize(img2, 2^(-shift_bits), 'bilinear');
    
    [tb1, eb1] = WardComputeThreshold(sml_img1, ward_percentile);
    [tb2, eb2] = WardComputeThreshold(sml_img2, ward_percentile);

    min_err = size(sml_img1, 1) * size(sml_img1, 2);

    tb1 = logical(tb1);
    eb1 = logical(eb1);

    for i=-1:1
        for j=-1:1
            xs = cur_shift(1) + i;
            ys = cur_shift(2) + j;

            shifted_tb2 = logical(imShift(tb2, [xs, ys]));
            shifted_eb2 = logical(imShift(eb2, [xs, ys]));

            diff_b = bitxor(tb1, shifted_tb2);
            diff_b = diff_b & eb1;
            diff_b = diff_b & shifted_eb2;

            err = sum(diff_b(:));

            if (err < min_err)
                shift_ret = [xs; ys];
                min_err = err;
            end
        end
    end
    
    shift_bits = shift_bits - 1;
    cur_shift  = shift_ret * 2;
end

end
