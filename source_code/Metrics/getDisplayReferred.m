function [img_dst_d, img_ref_d] = getDisplayReferred(img_dst, img_ref)





%display referred hdr-vdp
[img_ref_n, img_min, img_max] = normalizeImg(img_ref);
[img_dst_n, ~, ~] = normalizeImg(img_dst, img_min, img_max);

delta_d = display_max - display_min;
img_ref_d = ClampImg(img_ref_n * delta_d + display_min, 0.0, display_max);
img_dst_d = ClampImg(img_dst_n * delta_d + display_min, 0.0, display_max);

end