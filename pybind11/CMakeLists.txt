cmake_minimum_required(VERSION 3.10)

project(example_pybind11)

# 设置 C++ 标准
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# 添加编译选项，但禁用一些警告
if(MSVC)
    add_compile_options(/W4)
else()
    add_compile_options(-w)  # 禁用所有警告
endif()

# 找到 Python 解释器、编译器和库
find_package(Python3 REQUIRED COMPONENTS Interpreter Development)

# 方案一: 使用 FetchContent 下载并包含 PyBind11
include(FetchContent)
FetchContent_Declare(
  pybind11
  GIT_REPOSITORY https://gitee.com/yunfeiliu/pybind11.git # 这里可以使用https://github.com/pybind/pybind11.git, 根据自己的网络决定
#   GIT_TAG        v2.10.4  # 选择一个稳定的版本标签
)
FetchContent_MakeAvailable(pybind11)

# 方案二: 直接指定pybind11的路径
# 先从Cmake的输出看你使用的python版本, 比如我这里使用的是python3.6
# 然后执行python3.6 -m pip show pybind11, 查看Location字段的值, 填到下面
# set(CMAKE_PREFIX_PATH "/usr/local/lib/python3.6/site-packages")
# find_package(pybind11 REQUIRED)



# 设置 Python 相关的包含目录
include_directories(${Python3_INCLUDE_DIRS})

# 如果你需要额外的 Python 包头文件路径，例如 Torch，应该使用 pip 安装并让 find_package 处理
# 或者使用其他方法获取这些包的位置，而不要硬编码路径

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}  # 添加项目根目录到包含路径
)

# 创建 tbl 动态库 (shared library)
add_library(${PROJECT_NAME} SHARED example_pybind11.cpp)

# 确保 tbl 也链接 pybind11::module 以获得正确的包含路径
target_link_libraries(${PROJECT_NAME} PRIVATE  pybind11::module ${Python3_LIBRARIES})

# 安装指令（可选）
install(TARGETS ${PROJECT_NAME} DESTINATION lib)
