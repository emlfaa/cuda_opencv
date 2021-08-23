/*
 * @Author: el
 * @Date: 2021-08-21 15:23:54
 * @LastEditors: el
 * @LastEditTime: 2021-08-22 22:33:28
 */
#include <iostream>
#include <string>
#include <vector>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>


#include "utils/config.h"
#include "utils/file_process.h"
#include "cuda/cuda_action.h"

using namespace std;

int main() {

    InputArg inputarg;

    if(inputarg.data_type == 0)
    {
        cuda_process cudaHandle;

        file_process fileHandle;

        std::vector<string> filesname;
        fileHandle.GetFileNames(inputarg.file_path, filesname);
        for(int i = 0; i < filesname.size(); i++) {
            
            int position = filesname[i].find_last_of("/");
            string Current_filename = filesname[i].substr(position + 1, filesname[i].size() - position);

            std::vector<string> imagesname;
            fileHandle.GetFileNames(filesname[i], imagesname);

            for(int j = 0; j < imagesname.size(); j++) {

                int position_last = imagesname[j].find_last_of("/");

                string current_name = imagesname[j].substr(position_last + 1, imagesname[j].size() - position_last);

                std::cout << current_name << std::endl;

                cv::Mat image = cv::imread(imagesname[j]);
                
                if (image.empty()) {
                    std::cout << "Could not open or find the image: " << imagesname[j] << std::endl;
                    return -1;
                }


            }
        }
    
    }

    std::cout << "Hello, World!" << std::endl;
    return 0;
}
