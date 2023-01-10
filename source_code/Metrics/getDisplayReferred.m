function img_d = getDisplayReferred(img, display_min, display_max, bRobust, bScaling)
%
%
%       img_d = getDisplayReferred(img, display_min, display_max, bRobust, bScaling)
%
%

if ~exist('display_min', 'var')
    display_min = 0.02;
end

if ~exist('display_max', 'var')
    display_max = 1400.0;
end

if ~exist('bRobust', 'var')
    bRobust = 1;
end

if bScaling
    %anchor to the maximum
    if bRobust
        L_max = MaxQuart(lum(img), 0.999);
    else
        L_max = max(max(lum(img)));
    end    
    
    img = (img * display_max) / L_max; 
else
    %normalize + rescale 
    [img, L_min, L_max] = normalizeImg(img);
    delta_d = display_max - display_min;
    %
    img = img * delta_d + display_min;
end

img_d = ClampImg(img, display_min, display_max);

end