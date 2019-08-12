function P = pu2_encode( L )
% Perceptually uniform luminance encoding using the CSF from HDR-VDP-2
%
% P = pu2_encode( L )
%
% Transforms absolute luminance values L into approximately perceptually 
% uniform values P. 
%
% This is meant to be used with display-referred quality metrics - the
% image values much correspond to the luminance emitted from the target 
% HDR display.
%
% This is an improved encoding described in detail in the paper:
%
% Aydin, T. O., Mantiuk, R., & Seidel, H.-P. (2008). Extending quality
% metrics to full luminance range images. Proceedings of SPIE (p. 68060B–10). 
% SPIE. doi:10.1117/12.765095
%
% Note that the P-values can be negative or greater than 255. Most metrics
% can deal with such values.
%
% Copyright (c) 2014, Rafal Mantiuk <mantiuk@gmail.com>

persistent P_lut;
persistent l_lut;

l_min = -5;
l_max = 10;


if( isempty( P_lut ) ) % caching for better performance
    
    metric_par.csf_sa = [30.162 4.0627 1.6596 0.2712];    
    l_lut = linspace( l_min, l_max, 2^12 );
    S = hdrvdp_joint_rod_cone_sens( 10.^l_lut, metric_par );
    
    [~, P_lut] = build_jndspace_from_S(l_lut,S);
end


l = log10(max(min(L,10^l_max),10^l_min));

pu_l = 31.9270;
pu_h = 149.9244;

P = 255 * (interp1( l_lut, P_lut, l ) - pu_l) / (pu_h-pu_l);

end

function S = hdrvdp_joint_rod_cone_sens( la, metric_par )
% Copyright (c) 2011, Rafal Mantiuk <mantiuk@gmail.com>

% Permission to use, copy, modify, and/or distribute this software for any
% purpose with or without fee is hereby granted, provided that the above
% copyright notice and this permission notice appear in all copies.
%
% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

cvi_sens_drop = metric_par.csf_sa(2); % in the paper - p6
cvi_trans_slope = metric_par.csf_sa(3); % in the paper - p7
cvi_low_slope = metric_par.csf_sa(4); % in the paper - p8

S = metric_par.csf_sa(1) * ( (cvi_sens_drop./la).^cvi_trans_slope+1).^-cvi_low_slope;

end

function [Y jnd] = build_jndspace_from_S(l,S)

L = 10.^l;
dL = zeros(size(L));

for k=1:length(L)
    thr = L(k)/S(k);

    % Different than in the paper because integration is done in the log
    % domain - requires substitution with a Jacobian determinant
    dL(k) = 1/thr * L(k) * log(10);
end

Y = l;
jnd = cumtrapz( l, dL );

end


