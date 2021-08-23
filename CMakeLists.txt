cmake_minimum_required(VERSION 3.16)
project(cuda_ImageProcess LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)

# cuda
find_package(CUDA REQUIRED)
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS})

# opencv
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS} /usr/local/cuda/include cuda cpu)
link_directories(/usr/local/cuda/lib64)

# tensorrt
include_directories(/home/ub/workspace/Toolkits/TensorRT-7.0.0.11/include)
link_directories(/home/ub/workspace/Toolkits/TensorRT-7.0.0.11/lib)

# yololayer
#cuda_add_library(myplugins SHARED ${PROJECT_SOURCE_DIR}/tensorrt/yolov5/yololayer.cu)
#target_link_libraries(myplugins nvinfer cudart)

set(utils_file utils/config.h
               utils/file_process.h utils/file_process.cpp)

set(cuda_file cuda/cuda.cu
              cuda/cuda_action.h cuda/cuda_action.cpp
              cuda/cuda_fuction.h cuda/cuda_fuction.cpp)

# Print debugging information
MESSAGE(STATUS "Project: ${PROJECT_NAME}")
MESSAGE(STATUS "PROJECT_SOURCE_DIR： ${PROJECT_SOURCE_DIR}")
MESSAGE(STATUS "OpenCV library status:")
MESSAGE(STATUS "    version: ${OpenCV_VERSION}")
MESSAGE(STATUS "    libraries: ${OpenCV_LIBS}")
MESSAGE(STATUS "    include path: ${OpenCV_INCLUDE_DIRS}")

#add_executable(cuda_ImageProcess main.cpp)
cuda_add_executable(cuda_ImageProcess main.cpp ${utils_file} ${cuda_file}
        OPTIONS -std=c++11;-gencode arch=compute_60,code=sm_60;-gencode arch=compute_61,code=sm_61;-gencode arch=compute_70,code=sm_70;-gencode arch=compute_75,code=sm_75)

target_link_libraries(cuda_ImageProcess ${OpenCV_LIBS})
target_link_libraries(cuda_ImageProcess nvinfer)
target_link_libraries(cuda_ImageProcess cudart)