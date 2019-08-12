function [L,Ldetail] = AshikhminFiltering(L, Ashikhmin_sMax)  
%
%
%      [L,Ldetail] = AshikhminFiltering(L, Ashikhmin_sMax)  
%
%
%       Input:
%           -L: input grayscale image
%           -Ashikhmin_sMax: maximum filter size
%
%       Output:
%           -L: filtered image
%           -Ldetail: detail image
%
%     Copyright (C) 2013  Francesco Banterle
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

%sMax should be one degree of visual angle, the value is set as in the original paper
if(~exist('Ashikhmin_sMax', 'var'))
    Ashikhmin_sMax = 10;
end

if(Ashikhmin_sMax < 1)
    Ashikhmin_sMax = 10;
end

%precomputing filtered images
[r, c] = size(L);
Lfiltered = zeros(r,c,Ashikhmin_sMax); %filtered images
LC = zeros(r,c,Ashikhmin_sMax);
for i=1:Ashikhmin_sMax
    Lfiltered(:,:,i) = filterGaussianWindow(L,i); 
    %normalized difference of Gaussian levels
    LC(:,:,i) = RemoveSpecials(abs(Lfiltered(:,:,i) ...
        - filterGaussianWindow(L, i * 2)) ./ Lfiltered(:,:,i)); 
end  
  
%threshold is a constant for solving the band-limited local contrast LC at a given
%image location. This is kept as in the original paper
threshold = 0.5;
    
%adaptation image
L_adapt = -ones(size(L));
for i=1:Ashikhmin_sMax
    LC_i = LC(:,:,i);
    ind = find(LC_i < threshold);
    if(~isempty(ind))
        Lfiltered_i = Lfiltered(:,:,i);
        L_adapt(ind) = Lfiltered_i(ind);
    end
end
    
%set the maximum level
ind = find(L_adapt < 0);
L_adapt(ind) = Lfiltered(r * c * (Ashikhmin_sMax - 1) + ind);
    
%Remove the detail layer
Ldetail = RemoveSpecials(L ./ L_adapt);
L = L_adapt;

end
    