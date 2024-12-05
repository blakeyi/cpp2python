#!/bin/bash

# 获取脚本所在目录的绝对路径（不处理软链接）
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
echo "Script directory (without resolving symlinks): $SCRIPT_DIR"

# 确保我们有正确的文件路径
SWIG_INTERFACE_FILE="$SCRIPT_DIR/example_swig.i"
CPP_SOURCE_FILE="$SCRIPT_DIR/example_swig.cpp"
WRAP_FILE="$SCRIPT_DIR/example_swig_wrap.cxx"
OUTPUT_MODULE="_example_swig.so"

# 使用 swig 生成包装代码
swig -python -c++ "$SWIG_INTERFACE_FILE" || { echo 'SWIG failed'; exit 1; }

# 编译 C++ 源文件和 SWIG 生成的包装器代码
c++ -fPIC -c "$CPP_SOURCE_FILE" "$WRAP_FILE" $(python3-config --includes) || { echo 'Compilation failed'; exit 1; }

# 创建共享库
c++ -shared "${CPP_SOURCE_FILE%.cpp}.o" "${WRAP_FILE%.cxx}.o" -o "$OUTPUT_MODULE" || { echo 'Linking failed'; exit 1; }

echo "Python module created successfully: $OUTPUT_MODULE"