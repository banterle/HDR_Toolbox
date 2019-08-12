/*==========================================================
 * bilateralFilterS
 *
 * This file writes a $n \times m \times 3$ matrix into an exr file
 *
 * written Francesco Banterle
 * (c) 2015-2019
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
#include <random>
#include <chrono>

const float C_PI = 3.141592653589793f;

#define MAX(a,b) a > b ? a : b

/**
 * @brief KernelSize
 * @param sigma
 * @return
 */
int KernelSize(float sigma)
{
    int kernelSize = int(ceilf(sigma * 5.0f));
    return (kernelSize > 3) ? kernelSize : 3;
}

/**
 * @brief Random returns a number in [0, 2^32 - 1] to a float in [0, 1].
 * @param n is a 32-bit unsigned integer number.
 * @return It returns n as a normalized float in [0, 1].
 */
inline float Random(unsigned int n)
{
    return float(n) / 4294967295.0f;
}

inline int Clamp(int x, int a, int b)
{
    if(x > b) {
        return b;
    } else {
        if(x < a) {
            return a;
        } else {
            return x;
        }
    }
}

/**
 * @brief bilateralFilterS
 * @param img_in
 * @param img_edge
 * @param out
 * @param width
 * @param height
 * @param channels
 * @param sigma_s
 * @param sigma_r
 */
void bilateralFilterS(double *img_in, double *img_edge, double *out, int width, int height, int channels, float sigma_s, float sigma_r)
{
    if(sigma_s < 0.0) {
        sigma_s = 1.0;
    }

    if(sigma_r < 0.0) {
        sigma_r = 0.01f;
    }

    if(img_edge == NULL) {
        img_edge = img_in;
    }

    int nSamples = 2 * KernelSize(sigma_s);

    std::mt19937 m(std::chrono::system_clock::now().time_since_epoch().count());
    float *tmp_out = new float[channels];
    float *tmp_cur = new float[channels];
    float *tmp_cur_edge = new float[channels];

    float sigma_s_sq_2 = sigma_s * sigma_s * 2.0;
    float sigma_r_sq_2 = sigma_r * sigma_r * 2.0;

    int stride = height * width;

    int tile = 128;
    int tile_sq = tile * tile;
    int *x = new int [nSamples * tile_sq];
    int *y = new int [nSamples * tile_sq];
    float C_PI_2 = C_PI * 2.0f;
    
    for(int i=0; i<tile; i++) {
        int tmp = i * tile;
        for(int j=0; j<tile; j++) {
            int index = tmp + j;
            for(int k=0; k<nSamples; k++) {

                float u1, u2;
                do {
                    u1 = Random(m());
                } while(u1 < 0.0f);

                u2 = Random(m());
                
                float r_sq = -logf(u1) * sigma_s_sq_2;                
                float r = sqrtf(MAX(r_sq, 0.0f)) * cosf(u2 * C_PI_2);

                float phi = Random(m()) * C_PI_2;

                x[index + k] = int(cosf(phi) * r);
                y[index + k] = int(sinf(phi) * r);
            }
        }
    }

    int width1 = width - 1;
    int height1 = height - 1;
    
    for(int j = 0; j < width; j++) {
        int j_tmp = j * height;
        
        int tx = j % tile;
        
        for(int i = 0; i < height; i++) {
            int ty = i % tile;
            int address = j_tmp + i;
            float sum_weight = 0.0;
            
            int index_tile = tx * tile + ty;

            for(int c = 0; c < channels; c++) {
                tmp_cur[c]      = img_in  [address + c * stride];
                tmp_cur_edge[c] = img_edge[address + c * stride];
                tmp_out[c] = 0.0;
            }

            for(int k=0; k<nSamples; k++) {
                int x_t = Clamp(j + x[index_tile + k], 0, width1);
                int y_t = Clamp(i + y[index_tile + k], 0, height1);

                int address_samples = x_t * height + y_t;

                //compute range weight
                float weight = 0.0;
                for(int c = 0; c < channels; c++) {
                    float diff = img_edge[address_samples + c * stride] - tmp_cur_edge[c];
                    weight += diff * diff;
                }

                weight = expf(-weight / sigma_r_sq_2);

                sum_weight += weight;

                for(int c = 0; c < channels; c++) {
                    tmp_out[c] += weight * img_in[address_samples + c * stride];
                }
            }

            bool sum_weight_b = sum_weight > 0.0f;
            for(int c = 0; c < channels; c++) {
                out[address + c * stride] = sum_weight_b ? tmp_out[c] / sum_weight : tmp_cur[c];
            }

        }
    }
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    /* check for proper number of arguments */
    if(nrhs != 4) {
        mexErrMsgIdAndTxt("HDRToolbox:write_exr:nrhs", "Two inputs are required.");
    }

    /* create a pointer to the real data in the input matrix  */
    double *img_in = mxGetPr(prhs[0]);

    double *img_edge;
    if(!mxIsEmpty(prhs[1])) {
        img_edge = mxGetPr(prhs[1]);
    } else {
        img_edge = NULL;
    }

    double sigma_s = mxGetScalar(prhs[2]);
    double sigma_r = mxGetScalar(prhs[3]);

    /* get dimensions of the input matrix */
    const mwSize *dims;
    dims = mxGetDimensions(prhs[0]);

    int height = dims[0];
    int width = dims[1];

    int nDim = (int)mxGetNumberOfDimensions(prhs[0]);

    int channels;
    if(nDim == 2) {
        channels = 1;
    } else {
      channels = dims[2];
    }

    //
    plhs[0] = mxCreateNumericArray(nDim, dims, mxDOUBLE_CLASS, mxREAL);
    double *out = mxGetPr(plhs[0]);

    /* call the computational routine */
    if(width > 0 && height > 0) {
        bilateralFilterS(img_in, img_edge, out, width, height, channels, sigma_s, sigma_r);
    } else {
        printf("This matrix is not valid and the exr file cannot be written on the disk!\n");
    }
}
