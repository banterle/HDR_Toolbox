function [framework, distance] = KrawczykImagePartition(C, LLog10, bound, totPixels)
%
%
%       [framework, distance] = KrawczykImagePartition(C, LLog10, bound, totPixels)
%
%
%       Input:
%          -C: centroids.
%          -LLog10: luminance in log10 domain.
%          -totPixels: 
%
%       Output:
%          -framework: 
%          -distance:
%
%     Copyright (C) 2015-2016 Francesco Banterle
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

K = length(C);

framework = -ones(size(LLog10));
distance = 100 * K * ones(size(LLog10));

for i=1:K
    tmpDistance = abs(C(i) - LLog10);
    tmpDistance = min(distance, tmpDistance);
    indx = find(tmpDistance < distance);
    
    if(~isempty(indx))
        %assign the right framework
        framework(indx) = i;
        
        %updating distance
        distance = tmpDistance;
    end
end

%calcualte the maximum distance between adjacent frameworks
sigma = KrawczykMaxDistance(C, bound);
sigma_sq_2 = 2 * sigma^2;
P_norm = KrawczykPNorm(C, LLog10, sigma);

%remove frameworks with P_i < 0.6
while(1)
    K = length(C);
    K_old = K;
    for i=1:(K - 1)
        %Distance between frameworks has to be <= than 1
        P_i = RemoveSpecials(exp(-(C(i) - LLog10).^2 / sigma_sq_2) ./ P_norm);
        if(isempty(find(P_i(framework == i) > 0.6)))
            %merge
            totPixels_i = totPixels(i) + totPixels(i + 1);
            C(i) = (C(i) * totPixels(i) + C(i + 1) * totPixels(i + 1)) / totPixels_i;
            totPixels(i) = totPixels_i;

            %remove not necessary frameworks
            C(i + 1) = [];
            totPixels(i + 1) = [];          
            K = length(C);
            break;
        end
    end
    
    if(K == K_old)
        break;
    else
        [framework, distance] = KrawczykImagePartition(C, LLog10, bound, totPixels);
        sigma = KrawczykMaxDistance(C, bound);
        P_norm = KrawczykPNorm(C, LLog10, sigma);
    end
end

end