/*
 * @Author: el
 * @Date: 2021-08-21 22:48:18
 * @LastEditors: el
 * @LastEditTime: 2021-08-22 22:35:01
 */

#include "../utils/config.h"

class cuda_process {

public:

    cuda_process();
    ~cuda_process();
    
    void Init(InputArg cudaArg);

    void process();

};