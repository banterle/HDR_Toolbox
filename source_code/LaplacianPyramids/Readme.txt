Title: The Laplacian Pyramid Toolbox for Matlab

Author: Francesco Banterle

Copyright: February 2010-2015 (C)

Description: This toolbox allows the user to
represent images using Laplacian/Gaussian pyramids.

Functions:

- pryBlend.m: blends to images using a weight image
- pyrGaussGen.m: generates a Gaussian pyramid from a greyscale image
- pyrLapGen.m: generates a Laplacian pyramid from a greyscale image
- pyrEmptyGen.m: generates an empty pyramid
- pyrImg3.m: applies a generation function (pyrGaussGen or pyrLapGen)
to a three color channels image
- pyrLst1OP.m: applies a function (parameter) to a list of pyramids
- pyrLst2OP.m: applies a function (parameter) to two lists of pyramids
- pyrLstS2OP.m: applies a function (parameter) to a lists of pyramids and a pyramid
- pyrMul.m: multiplies two pyramids
- pyrAdd.m: addes two pyramids
- pyrVal.m: evaluates a pyramid