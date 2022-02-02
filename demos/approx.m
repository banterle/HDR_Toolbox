function [x,y] = approx(img)

img = imresize(img, 0.25);
img(img<0.0) = 0.0;
out = SchlickTMO(img);
out(out<0.0) = 0.0;

x = lum(img);
y = lum(out);

[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Normalize = 'on';
opts.StartPoint = [0.857879476325022 0.0113517550961521 -0.243536865739907 -0.22328469244579];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );

end