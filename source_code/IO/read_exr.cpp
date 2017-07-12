/*==========================================================
 * read_exr.cpp
 *
 * This file reads a $n \times m \times 3$ matrix into an exr file
 *
 * written Francesco Banterle
 * (c) 2015
 *
 *========================================================*/
/* $Revision: 0.1 $ */

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
     along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#include "mex.h"
#include <vector>
#include <string>

#define TINYEXR_IMPLEMENTATION

#include "tinyexr.h"

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    /* check for proper number of arguments */
    if(nrhs != 1) {
        mexErrMsgIdAndTxt("HDRToolbox:write_exr:nrhs", "One input is required.");
    }
    
    char *nameFile;
    mwSize buflen;
    int status;    
    buflen = mxGetN(prhs[0])*sizeof(mxChar)+1;
    nameFile = (char*) mxMalloc(buflen);
    
    /* Copy the string data into buf. */ 
    status = mxGetString(prhs[0], nameFile, buflen);
    
    /* call the computational routine */
    EXRImage image;
    InitEXRImage(&image);

    const char* err;
    int ret = ParseMultiChannelEXRHeaderFromFile(&image, nameFile, &err);
    if (ret != 0) {
        printf("Parse EXR error: %s\n", err);
        return;
    }

    int width = image.width;
    int height = image.height;
    int channels = image.num_channels;

    //Allocate into memory

    mwSize dims[3];
    dims[0] = height;
    dims[1] = width;
    dims[2] = channels;

    plhs[0] = mxCreateNumericArray(channels, dims, mxDOUBLE_CLASS, mxREAL);
    double *outMatrix = mxGetPr(plhs[0]);

    for (int i = 0; i < image.num_channels; i++) {
        if (image.pixel_types[i] == TINYEXR_PIXELTYPE_HALF) {
            image.requested_pixel_types[i] = TINYEXR_PIXELTYPE_FLOAT;
        }
    }
    
    ret = LoadMultiChannelEXRFromFile(&image, nameFile, &err);
    
    if (ret != 0) {
        printf("Load EXR error: %s\n", err);
        return;
    }
    
    float **images = (float**) image.images;
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
            
            outMatrix[index    ]        = images[2][indexOut];
            outMatrix[index + nPixels]  = images[1][indexOut];
            outMatrix[index + nPixels2] = images[0][indexOut];
        }
    }
    
    FreeEXRImage(&image);
}
