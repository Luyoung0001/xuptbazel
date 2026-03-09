# 项目6: 同时构建 C++ 和 Python 版本的工具

## 学习目标
- 在同一个项目中管理多语言
- 理解不同语言的构建目标
- 使用 Bazel 构建多个可执行文件

## 项目结构
```
project06-multi-lang/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── greeter.cc      # C++ 版本
└── greeter.py      # Python 版本
```

## 功能设计
实现一个简单的问候工具，用 C++ 和 Python 两种语言实现相同功能

## 实践步骤

### 步骤 1: 创建 greeter.cc
```cpp
#include <iostream>
#include <string>

int main(int argc, char* argv[]) {
    std::string name = (argc > 1) ? argv[1] : "World";
    std::cout << "Hello from C++, " << name << "!" << std::endl;
    return 0;
}
```

### 步骤 2: 创建 greeter.py
```python
import sys

def main():
    name = sys.argv[1] if len(sys.argv) > 1 else "World"
    print(f"Hello from Python, {name}!")

if __name__ == "__main__":
    main()
```

### 步骤 3: 创建 BUILD 文件
```python
load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@rules_python//python:defs.bzl", "py_binary")

cc_binary(
    name = "greeter_cpp",
    srcs = ["greeter.cc"],
)

py_binary(
    name = "greeter_py",
    srcs = ["greeter.py"],
)
```

### 步骤 4: 创建 MODULE.bazel
```python
module(name = "multi_lang")

bazel_dep(name = "rules_cc", version = "0.0.9")
bazel_dep(name = "rules_python", version = "0.31.0")
```

### 步骤 5: 构建和运行
```bash
# 构建所有目标
bazel build //...

# 运行 C++ 版本
bazel run //:greeter_cpp -- Bazel

# 运行 Python 版本
bazel run //:greeter_py -- Bazel
```

**注意**: `--` 后面的参数会传递给程序
