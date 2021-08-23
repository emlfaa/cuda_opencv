/*
 * @Author: el
 * @Date: 2021-08-21 15:25:45
 * @LastEditors: el
 * @LastEditTime: 2021-08-22 21:03:35
 */
#ifndef CONFIG_H_
#define CONFIG_H_

#include <iostream>

class InputArg{
public:

    int data_type = 0;   // 0:图片  1:视频   2:实时摄像头

    // image input
    std::string file_path = "../img";  // 原始数据目录
    std::string save_path = "../img/result";   // 预处理数据保存目录

    // video input

    bool video_flag = 1;    //
//    std::string video_path = "../img/768x576.avi";
    std::string video_path = "/home/ub/workspace/数据/视频 数据/原视频/201810181739529687.mp4";

    int sc = 8;
    int gray_level = 4;

    bool down_flag = true;                 // 下采样
    bool gray_flag = true;                 // 灰度化
    bool graylevel_flag = true;            // 灰度等级调整
    bool grayequalization_flag = true;     // 灰度图均衡化
    bool RGBequalization_flag = true;      // 彩色图像均衡化
    bool RGBSketch_flag = true;            // 彩色图像变素描
    bool SobelEdge_flag = true;            // sobel算子边缘检测
    bool Binarization_flag = true;         // 二值化


};

#endif