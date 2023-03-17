%
%
%       Author: Francesco Banterle
%       Copyright 2022 (c)
%

fstops = [-3, -2, -1, 0, 1, 2, 3];
img = hdrimread('Bottles_Small.hdr');
stack_exposure = 2.^fstops;

stack = [];
gamma = 0.4;
n = length(stack_exposure);
for i=1:n
    img_i = ClampImg((img*stack_exposure(i)).^(1.0/gamma), 0.0, 1.0);
        
    if i == 1
        [r,c,col] = size(img_i);
        stack = zeros(r,c,col,n);
    end
    
    stack(:,:,:,i) = img_i;
end

length(stack_exposure)
size(stack)

[lin_fun, ~] = DebevecCRF(stack, stack_exposure, 256);
h = figure(1);
set(h, 'Name', 'The Camera Response Function (CRF)');
plot(0:255, lin_fun(:,1), 'r', 0:255, lin_fun(:,2),'g', 0:255, lin_fun(:,3), 'b');
