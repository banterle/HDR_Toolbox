function g = gsolve(Z,B,l,w)
%
%       g = gsolve(Z,B,l,w)
%
%       Author: a modifed version of Paul Debevec and Jitendra Malik's code
%
%        Input:
%           -Z:
%           -B:
%           -l:
%           -w:
%
%        Output:
%           -g:
%
%
%

n = 256;
A = zeros(size(Z, 1) * size(Z, 2) + n + 1, n + size(Z, 1));
b = zeros(size(A, 1), 1);

%the data-fitting term
k = 1;
for i=1:size(Z,1)
    for j=1:size(Z,2)
        wij = w(Z(i,j) + 1);
        A(k,Z(i,j)+1) =  wij; 
        A(k,n+i)      = -wij;
        b(k,1)        =  wij * B(j);
        k = k+1;
    end
end

% Fix the curve by setting its middle value to 0
A(k,129) = 1;
k = k + 1;

%the smoothness term
for i=1:n-2
    A(k,i)  =    l*w(i+1);
    A(k,i+1)= -2*l*w(i+1);
    A(k,i+2)=    l*w(i+1);
    k = k+1;
end

%Solve the system using SVD
[x, ~] = linsolve(A, b);
%x = A \ b;
g = x(1:n);

end
