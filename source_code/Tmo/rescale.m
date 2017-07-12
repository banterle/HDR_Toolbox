function output = rescale(img)

L = lum(img);
Lori = L;
minL = min(L(:));
maxL = max(L(:));

L = (L - minL) / (maxL - minL);

output = ChangeLuminance(img, Lori, L);

end