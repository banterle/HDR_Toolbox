function [pp, err] = MitsunagaNayarCRFFull(stack_samples, stack_exposure, N, maxIterations)
%
%       [pp, err] = MitsunagaNayarCRFFull(stack, stack_exposure, N, nSamples, sampling_strategy)
%
%       This function computes camera response function using Mitsunaga and
%       Nayar method.
%
%        Input:
%           -stack_samples: a stack of samples from LDR images
%           -nSamples: number of samples for computing the CRF
%           -N: polynomial degree of the inverse CRF
%           -maxIterations: 
%
%        Output:
%           -pp: a polynomial encoding the inverse CRF
%           -err: the error
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

if(~exist('maxIterations', 'var'))
    maxIterations = -1;
end

threshold = 1e-4;

col = size(stack_samples, 3);

Q = length(stack_exposure);

Mmax = 1.0;

%recovering the CRF
function d = MN_d(c, q1, q2, n)

    M_q   = stack_samples(:, q1, c);
    M_q_p = stack_samples(:, q2, c);

    indx = find(M_q > 0.0 & M_q_p > 0.0);

    d = M_q(indx).^n - R(q1, q2) * (M_q_p(indx).^n);
end

pp = zeros(N + 1, col);
pp_prev = zeros(N + 1, col);

x = (0:255) / 255;
 
err = 0.0;

R0 = ones(Q - 1, Q - 1);
for q1=1:(Q - 1)
    for q2=1:(Q - 1)
        if(q1 ~= q2)
            R0(q1, q2) = stack_exposure(q1) / stack_exposure(q2);
        end
    end
end

for c=1:col
    
    R = R0;
    
    bLoop = 1;
    iter = 0;
    
    while(bLoop)
        A = zeros(N, N);
        b = zeros(N, 1);

        for i=1:N
            %init A
            for j=1:N
                for q1=1:(Q - 1)
                    for q2=1:(Q - 1)
                        if(q1 ~= q2)
                            delta  = MN_d(c, q1, q2, j - 1) - MN_d(c, q1, q2, N);
                            A(i,j) = A(i,j) + sum(MN_d(c, q1, q2, i - 1) .* delta);
                        end
                    end
                end
            end

            %init b
            for q1=1:(Q - 1)
                for q2=1:(Q - 1)
                    if(q1 ~= q2)
                        b(i) = b(i) - sum(Mmax * MN_d(c, q1, q2, i - 1) .* MN_d(c, q1, q2, N));
                    end
                end
            end
        end  

        coeff = A \ b;    
        coeff_n = Mmax - sum(coeff);

        pp(:,c) = flip([coeff; coeff_n]);
        
        f_1 = polyval(pp(:,c),      x);
        f_2 = polyval(pp_prev(:,c), x);
        bLoop = max(abs(f_1 - f_2) > threshold);
        
        bLoop = bLoop & (iter < maxIterations);
        
        if(bLoop)
            pp_prev = pp;

            %update R
            for q=1:(Q - 1)
                for q2=1:(Q - 1)
                    if(q1 ~= q2)
                        s1 = stack_samples(:, q1    , c);
                        s2 = stack_samples(:, q2, c);   
                        
                        indx = find(s1 > 0.0 & s2 > 0.0);                

                        e1 = polyval(pp(:,c), s1(indx));
                        e2 = polyval(pp(:,c), s2(indx));
                        R(q1, q2) = sum(e1) / sum(e2);
                    end
                end
            end
            
            iter = iter + 1;
        end                
    end

    %compute err
    for q1=1:(Q - 1)
        for q2=1:(Q - 1)
            if(q1 ~= q2)
                s1 = stack_samples(:, q1, c);
                s2 = stack_samples(:, q2, c);   

                indx = find(s1 > 0.0 & s2 > 0.0);
                        
                e1 = polyval(pp(:, c), s1(indx));
                e2 = polyval(pp(:, c), s2(indx));
                err = err + sum((e1 - R(q1, q2) * e2).^2);
            end
        end
    end
end

end