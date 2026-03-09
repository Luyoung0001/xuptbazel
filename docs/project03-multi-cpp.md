# 项目3: 多文件 C++ 程序

## 学习目标
- 使用 `cc_library` 规则
- 理解 `deps` 依赖关系
- 掌握模块化编程在 Bazel 中的实现

## 核心概念

### cc_library 规则
构建 C++ 库，主要属性：
- `name`: 库名称
- `srcs`: 源文件（.cc, .cpp）
- `hdrs`: 头文件（.h, .hpp）- 公开接口
- `deps`: 依赖的其他库

### hdrs vs srcs
- `hdrs`: 对外公开的头文件，依赖此库的目标可以 include
- `srcs`: 内部实现文件，外部不可见

## 项目结构
```
project03-multi-cpp/
├── WORKSPACE
├── BUILD
├── main.cc
├── utils.h
└── utils.cc
```

## 实践步骤

### 步骤 1: 创建 utils.h
```cpp
#ifndef UTILS_H
#define UTILS_H

int add(int a, int b);
int multiply(int a, int b);

#endif
```

### 步骤 2: 创建 utils.cc
```cpp
#include "utils.h"

int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}
```

### 步骤 3: 创建 main.cc
```cpp
#include <iostream>
#include "utils.h"

int main() {
    std::cout << "5 + 3 = " << add(5, 3) << std::endl;
    std::cout << "5 * 3 = " << multiply(5, 3) << std::endl;
    return 0;
}
```

### 步骤 4: 创建 BUILD 文件
```python
cc_library(
    name = "utils",
    srcs = ["utils.cc"],
    hdrs = ["utils.h"],
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [":utils"],
)
```

**关键点**:
- `cc_library` 定义了一个库
- `cc_binary` 通过 `deps` 依赖这个库
- `:utils` 表示同一个 BUILD 文件中的 utils 目标

### 步骤 5: 构建和运行
```bash
bazel build //:main
bazel run //:main
```

## 依赖图
```
main (cc_binary)
  └─ depends on → utils (cc_library)
```

## 练习任务
1. 添加 `subtract` 函数
2. 创建第二个库 `math_advanced` 依赖 `utils`
3. 使用 `bazel query --output=graph //:main` 查看依赖图
