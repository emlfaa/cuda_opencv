/*
 * @Author: el
 * @Date: 2021-08-21 15:31:55
 * @LastEditors: el
 * @LastEditTime: 2021-08-22 19:04:42
 */

#ifndef CUDA_FUCTION_H_
#define CUDA_FUCTION_H_

#include <opencv2/core.hpp>
#include "../utils/config.h"

class cuda_function {
    cuda_function();
    ~cuda_function();

    void cuda_Init();

public:

    cv::Mat InputImage;
    int ImageWidth;
    int ImageHeight;
    int Scale;
    
};

#endif