function crf = findHDRLDRCRF(imgHDR, imgLDR)
%
%
%       crf = findHDRLDRCRF(imgHDR, imgLDR)
%
%
%       Input:
%           -imgHDR: an HDR image
%           -imgLDR: an LDR image with values in [0,1] (normalized)
%
%       Output:
%           -crf: the camera response function as polynomial
%
%     Copyright (C) 2016  Francesco Banterle
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

if(~isSameImage(imgHDR, imgLDR))
    error('The input images are different!');
end

if(max(imgLDR(:)) > 1.0)
    imgLDR = imgLDR / 255.0;
end

col = size(imgHDR, 3);

low_threshold =  ( 16.0 / 255.0);
high_threshold = (240.0 / 255.0);

for i=1:col
    ldr_slice = imgLDR(:,:,i);
    hdr_slice = imgHDR(:,:,i);
    
    tmp_max = mean(hdr_slice(:));
    if(tmp_max > 0.0)
        hdr_slice = hdr_slice / tmp_max;
    end
    
    indx = find((ldr_slice >= low_threshold) & (ldr_slice <= high_threshold));
    n = length(indx);

    x = ldr_slice(indx);
    y = hdr_slice(indx);
    
    if(n > 100)
        x = x(1:round((n / 100)):n);
        y = y(1:round((n / 100)):n);
    end
    
    x = [x; 0; 0];
    y = [y; 0; 0];
        
    ft = fittype( 'poly3' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = ones(7, 1);

    [xData, yData] = prepareCurveData(double(x), double(y));
    [fit_ret, ~] = fit( xData, yData, ft, opts );    
    
    x = (0:255) / 255;
    crf(:, i) = feval(fit_ret, x');    
    crf(:, i) = crf(:, i) / max(crf(:, i));
end

end

