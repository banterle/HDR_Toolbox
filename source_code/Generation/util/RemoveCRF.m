function imgOut = RemoveCRF(img, lin_type, lin_fun)
%
%       imgOut = RemoveCRF(img, lin_type, lin_fun)
%
%       This function builds an HDR image from a stack of LDR images.
%           -imgOut: an image with values in [0,1]
%
%           -lin_type: the linearization function:
%                      - 'linear': images are already linear
%                      - 'gamma2.2': gamma function 2.2 is used for
%                                    linearization;
%                      - 'sRGB': images are encoded using sRGB
%                      - 'LUT': the lineraziation function is a look-up
%                               table defined stored as an array in the 
%                               lin_fun 
%                      - 'poly': the lineraziation function is a polynomial
%                               stored in lin_fun 
%
%           -lin_fun: it is the camera response function of the camera that
%           took the pictures in the stack. If it is empty, [], and 
%           type is 'LUT' it will be estimated using Debevec and Malik's
%           method.
%
%        Output:
%           -imgOut: a linearized (CRF is removed) image.
%

%is the linearization type of the images defined?
if(~exist('lin_type', 'var'))
    lin_type = 'gamma';
end

%do we have the inverse camera response function?
if(~exist('lin_fun', 'var'))
    lin_fun = 2.2;
end

%linearization of the image
switch lin_type
    case 'gamma'
        imgOut = img.^lin_fun;

    case 'sRGB'
        imgOut = ConvertRGBtosRGB(img, 1);

    case 'LUT'
        imgOut = tabledFunction(img, lin_fun);   

    case 'poly'
        imgOut = zeros(size(img));
        
        for c=1:size(lin_fun, 2)
            imgOut(:,:,c) = polyval(lin_fun(:,c), img(:,:,c));
        end
        
    otherwise
        imgOut = img;
end

end

