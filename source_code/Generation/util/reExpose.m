function image_target = reExpose(img_source, source_exposure, target_exposure, lin_type, lin_fun)
%
%       image_target = reExpose(img_source, source_exposure, target_exposure, lin_type, lin_fun)
%       
%       This function re-exposes an LDR source image with respect to the target image.
%
%        Input:
%           -img_source:
%           -source_exposure:
%           -target_exposure:
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
%           -image_target: the re-exposed image with gamma encoding
%           (1.0/2.2)
%
%     Copyright (C) 2015  Damla Ezgi Akcora
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

Z = RemoveCRF(img_source, lin_type, lin_fun);

image_target = (Z * target_exposure) / source_exposure;
image_target = ClampImg(image_target.^(1.0 / 2.2), 0.0, 1.0);

end