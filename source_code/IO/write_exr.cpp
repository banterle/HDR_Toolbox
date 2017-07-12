/*==========================================================
 * write_exr.cpp
 *
 * This file writes a $n \times m \times 3$ matrix into an exr file
 *
 * written Francesco Banterle
 * (c) 2015
 *
 *========================================================*/
/* $Revision: 0.1 $ */
/*==========================================================

/*
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 */
 

#include "mex.h"
#include <vector>
#include <string>

#define TINYEXR_IMPLEMENTATION

#include "tinyexr.h"

/* The computational routine */
bool write_exr(char *nameFile, double *data, int width, int height, int channels)
{
    EXRImage image;
    InitEXRImage(&image);

     image.num_channels = channels;

     const char* channel_names[] = {"B", "G", "R"}; // "B", "G", "R", "A" for RGBA image

     std::vector<float> images[3];
     images[0].resize(width * height);
     images[1].resize(width * height);
     images[2].resize(width * height);

     int nPixels = width * height;
     int nPixels2 = nPixels * 2;
     
     if(channels == 1) {
         nPixels = 0;
         nPixels2 = 0;
     }
     
     if(channels == 2) {
         nPixels2 = 0;
     }     
     
     for (int i = 0; i < width; i++){
         for (int j = 0; j < height; j++){
             int index = i * height + j;
             int indexOut = j * width + i;

             images[0][indexOut] = data[index    ];
             images[1][indexOut] = data[index + nPixels];
             images[2][indexOut] = data[index + nPixels2];
         }
     }

     float* image_ptr[3];
     image_ptr[0] = &(images[2].at(0)); // B
     image_ptr[1] = &(images[1].at(0)); // G
     image_ptr[2] = &(images[0].at(0)); // R

     image.channel_names = channel_names;
     image.images = (unsigned char**)image_ptr;
     image.width = width;
     image.height = height;

     image.pixel_types = (int *)malloc(sizeof(int) * image.num_channels);
     image.requested_pixel_types = (int *)malloc(sizeof(int) * image.num_channels);
     for (int i = 0; i < image.num_channels; i++) {
       image.pixel_types[i] = TINYEXR_PIXELTYPE_FLOAT; // pixel type of input image
       image.requested_pixel_types[i] = TINYEXR_PIXELTYPE_HALF; // pixel type of output image to be stored in .EXR
     }

     const char* err;
     int ret = SaveMultiChannelEXRToFile(&image, nameFile, &err);
     if (ret != 0) {
         printf("Save EXR err: %s\n", err);
         return false;
     }

     //FreeEXRImage(&image);

     free(image.pixel_types);
     free(image.requested_pixel_types);
     
     return true;
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    double *inMatrix;

    /* check for proper number of arguments */
    if(nrhs != 2) {
        mexErrMsgIdAndTxt("HDRToolbox:write_exr:nrhs", "Two inputs are required.");
    }
    
    /* create a pointer to the real data in the input matrix  */
    inMatrix = mxGetPr(prhs[0]);
    
    char *buf;
    mwSize buflen;
    int status;    
    buflen = mxGetN(prhs[1])*sizeof(mxChar)+1;
    buf = (char*) mxMalloc(buflen);
    
    /* Copy the string data into buf. */ 
    status = mxGetString(prhs[1], buf, buflen);   
    
    /* get dimensions of the input matrix */
    const mwSize *dims;
    dims = mxGetDimensions(prhs[0]);
       
    int nDim = (int)mxGetNumberOfDimensions(prhs[0]);

    int channels;
    if(nDim == 2) {
        channels = 1;
    } else {
      channels = dims[2];

      if(channels > 3) {
          channels = 3;
          printf("Only the first three color channels of this matrix will be written on the disk!\n");
      }
    }
    /* call the computational routine */
    if(dims[0] > 0 && dims[1] > 0) {
        write_exr(buf, inMatrix, dims[1], dims[0], channels );
    } else {
        printf("This matrix is not valid and the exr file cannot be written on the disk!\n");
    }
}
