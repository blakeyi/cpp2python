# 1.1 使用pybind11

PyBind11 是一个轻量级的头文件库，它使得将 C++ 和 Python 代码集成变得非常简单。PyBind11 支持现代 C++ 特性，并且可以很容易地将 C++ 函数、类和数据结构暴露给 Python。

主要步骤：
安装 PyBind11：可以通过 pip 或者包管理器安装。
编写绑定代码：创建一个包含 PYBIND11_MODULE 的 C++ 文件来定义模块接口。
编译为共享库：使用 CMake 或其他构建工具编译代码为 .so 文件。
Python 导入：在 Python 中直接导入生成的模块。

注意!!!:
PYBIND11_MODULE定义的名称要和你的so名称一模一样, 不然可能会出现

```Bash
Traceback (most recent call last):
  File "test.py", line 1, in <module>
    import libexample_pybind11
ImportError: dynamic module does not define module export function (PyInit_libexample_pybind11)
```

```c++
#include <pybind11/pybind11.h>

namespace py = pybind11;

int add(int i, int j) {
    return i + j;
}

PYBIND11_MODULE(example, m) {
    m.doc() = "pybind11 example plugin"; // optional module docstring
    m.def("add", &add, "A function which adds two numbers");
}

```

# 1.2 使用 SWIG (Simplified Wrapper and Interface Generator)

SWIG 是一种强大的工具，用于生成 C/C++ 代码与多种编程语言之间的接口，包括 Python。它支持复杂的 C++ 功能，如模板、命名空间等，并且允许你自定义包装代码。

主要步骤：
编写接口文件：创建一个 .i 文件描述如何包装 C++ 代码。
运行 SWIG：使用 SWIG 命令行工具生成包装代码。
编译包装代码：编译生成的代码以及原始 C++ 源码为共享库。
Python 导入：在 Python 中导入生成的模块。

```c++
// MyClass.cpp:
class MyClass {
public:
    MyClass();
    ~MyClass();
    void greet(const char* name);
};

// myclass.i
%module myclass
%{
#include "myclass.h"
%}

%include "myclass.h"
```

# 2.1 关于pybind11的路径问题的几种解决方案
出现如下报错, 原因是找不到pybind11的安装路径, 其原因大概率是因为python多版本安装的问题, 有几种解决方案
```
-- Found Python3: /usr/bin/python3.6 (found version "3.6.8") found components: Interpreter Development 
CMake Error at CMakeLists.txt:22 (find_package):
  By not providing "Findpybind11.cmake" in CMAKE_MODULE_PATH this project has
  asked CMake to find a package configuration file provided by "pybind11",
  but CMake did not find one.

  Could not find a package configuration file provided by "pybind11" with any
  of the following names:

    pybind11Config.cmake
    pybind11-config.cmake

  Add the installation prefix of "pybind11" to CMAKE_PREFIX_PATH or set
  "pybind11_DIR" to a directory containing one of the above files.  If
  "pybind11" provides a separate development package or SDK, be sure it has
  been installed.
```
## 2.1.1 方案一: 使用 FetchContent 下载并包含 PyBind11

```Shell
include(FetchContent)
FetchContent_Declare(
  pybind11
  GIT_REPOSITORY https://gitee.com/yunfeiliu/pybind11.git # 这里可以使用https://github.com/pybind/pybind11.git, 根据自己的网络决定
#   GIT_TAG        v2.10.4  # 选择一个稳定的版本标签
)
FetchContent_MakeAvailable(pybind11)
```

## 2.1.2 方案二: 直接指定pybind11的路径

```Shell
# 先从Cmake的输出看你使用的python版本, 比如我这里使用的是python3.6
# 然后执行python3.6 -m pip show pybind11, 查看Location字段的值, 填到下面
set(CMAKE_PREFIX_PATH "/usr/local/lib/python3.6/site-packages")
find_package(pybind11 REQUIRED)
```
