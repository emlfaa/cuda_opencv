#include <iostream>

#include <cuda_runtime.h>

#include "cuda_fuction.h"

#define THREAD_DIM_X 512

inline __device__ __host__ float regin_union(float a1, float a2, float b1, float b2) {
    return (min)(a2, b2) - (max)(a1, b1);
}

// Down resize
__global__ void _resize_kernel(uint8_t *src_pix,
                               uint8_t *dst_pix, 
                               int srcWidth, 
                               int srcHeight,
                               int srcChannel,
                               int dstWidth,
                               int dstHeight
                               )
{
    const int gidx = blockIdx.x * blockDim.x + threadIdx.x;
    const int dc = gidx % srcChannel;
    const int dx = gidx / srcChannel % dstWidth;
    const int dy = gidx / srcChannel / dstWidth;
    
    if(dy >= dstHeight) return;

    const float bw = (float) srcWidth / (float) dstWidth;
    const float bh = (float) srcHeight / (float) dstHeight;
    const float fx1 = dx * bw;
    const float fx2 = (dx + 1) * bw;
    const float fy1 = dy * bh;
    const float fy2 = (dy + 1) * bh;
    const int st_x = (int) floor(fx1), ed_x = ceil(fx2);
    const int st_y = (int) floor(fy1), ed_y = ceil(fy2);
    float sv = 0;
    for(int x = st_x; x < ed_x; x++) {
        float px = regin_union(x, x + 1.0f, fx1, fx2);
        for(int y = st_y; y < ed_y; y++) {
            float py = region_union(y, y + 1.0f, fy1, fy2);
            sv += src_pix[srcChannel * (x + srcWidth * y) + dc] * px * py;
        }
    }

    sv /= bw * bh;
    dst_pix[srcChannel * (dy * dstHeight + dx) + dc] = (uint8_t) sv;
}

// RGB to gray
__global__ void bgr2gray_kernel(const uchar3 *src, 
                                const int srcWidth,
                                const int srcHeight, 
                                unsigned char *dst) {
    
    const unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
    const unsigned int idy = blockIdx.y * blockDim.y + threadIdx.y;

    if(idx < srcWidth && idy < srcHeight)
    {
        uchar3 rgb = src[idy * srcWidth + idx];
        dst[idy * srcWidth + idx] = 0.299f * rgb.x + 0.587f * rgb.y + 0.114f * rgb.z;
    }
}

void cuda_function::ImgDownSampling() {

    uint8_t *img_gpu;
    uint8_t *imgSmall_gpu;

    // cuda 空间申请
    cudaMalloc((void**) &img_gpu, ImageSize);
    cudaMalloc((void**) &imgSmall_gpu, imageSize / scale / scale);

    cudaMemcpy(img_gpu, InputImage.data, imageSize, cudaMemcpyHostToDevice);

    if(img_gpu == NULL || imgSmall_gpu == NULL)
    {
        printf("ImgDownSampling() create cuda memory is failed！！！！！！");
        std::exit(0);
    }

    const int SW = ImageWidth / scale;
    const int SH = ImageHeight / scale;

    _resize_kernel<<<(SW * 3 * SH + THREAD_DIM_X - 1) / THREAD_DIM_X, THREAD_DIM_X>>>(img_gpu, imgW, imgH, 3, imgSmall_gpu, SW, SH);
    img_small.create(imgH / scale, imgW / scale, CV_8UC3);
    cudaMemcpy(img_small.data, imgSmall_gpu, SW * 3 * SH, cudaMemcpyDeviceToHost);
}

void cuda_function::ImgRGB2GRAY() {

    uchar3 *img_input;
    unsigned char *img_output; 

    cudaMalloc((void**)&img_input, ImageWidth*ImageHeight*sizeof(uchar3));
    cudaMalloc((void**)&img_output, ImageWidth * ImageHeight * sizeof(unsigned char));
    cudaMemcpy(img_input, InputImage.data, ImageWidth*ImageHeight*sizeof(uchar3), cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(32, 32);
    dim3 blocksPerGrid((ImageWidth + threadsPerBlock.x - 1) / threadsPerBlock.x,
                       (ImageHeight + threadsPerBlock.y - 1) / threadsPerBlock.y);
    
    _rgb2gray<<<blocksPerGrid, threadsPerBlock>>>(img_input, image)
}