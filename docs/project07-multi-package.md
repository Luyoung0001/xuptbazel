# 项目7: 多层目录结构的库项目

## 学习目标
- 跨 package 依赖（不同目录的 BUILD 文件）
- 理解 package 的概念
- 掌握目标标签的完整语法

## 核心概念

### Package（包）
- 包含 BUILD 文件的目录就是一个 package
- 每个 package 有独立的命名空间
- 子目录可以有自己的 BUILD 文件

### 跨 Package 依赖
```python
deps = ["//src/core:math"]  # 完整路径
```
- `//` 从 WORKSPACE 根开始
- `src/core` 是 package 路径
- `:math` 是目标名称

## 项目结构
```
project07-multi-package/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── main.cc
├── src/
│   ├── core/
│   │   ├── BUILD
│   │   ├── math.h
│   │   └── math.cc
│   └── utils/
│       ├── BUILD
│       ├── string_utils.h
│       └── string_utils.cc
```

## 实践步骤

### 步骤 1: 创建 src/core/math.h
```cpp
#ifndef MATH_H
#define MATH_H

int power(int base, int exp);

#endif
```

### 步骤 2: 创建 src/core/math.cc
```cpp
#include "src/core/math.h"

int power(int base, int exp) {
    int result = 1;
    for (int i = 0; i < exp; i++) {
        result *= base;
    }
    return result;
}
```

### 步骤 3: 创建 src/core/BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_library")

cc_library(
    name = "math",
    srcs = ["math.cc"],
    hdrs = ["math.h"],
    visibility = ["//visibility:public"],
)
```

**重点**: `visibility = ["//visibility:public"]` 让其他 package 可以使用这个库

### 步骤 4: 创建 src/utils/string_utils.h
```cpp
#ifndef STRING_UTILS_H
#define STRING_UTILS_H

#include <string>

std::string repeat(const std::string& str, int times);

#endif
```

### 步骤 5: 创建 src/utils/string_utils.cc
```cpp
#include "src/utils/string_utils.h"

std::string repeat(const std::string& str, int times) {
    std::string result;
    for (int i = 0; i < times; i++) {
        result += str;
    }
    return result;
}
```

### 步骤 6: 创建 src/utils/BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_library")

cc_library(
    name = "string_utils",
    srcs = ["string_utils.cc"],
    hdrs = ["string_utils.h"],
    visibility = ["//visibility:public"],
)
```

### 步骤 7: 创建 main.cc
```cpp
#include <iostream>
#include "src/core/math.h"
#include "src/utils/string_utils.h"

int main() {
    std::cout << "2^10 = " << power(2, 10) << std::endl;
    std::cout << repeat("Hello ", 3) << std::endl;
    return 0;
}
```

### 步骤 8: 创建根目录 BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [
        "//src/core:math",
        "//src/utils:string_utils",
    ],
)
```

### 步骤 9: 创建 MODULE.bazel
```python
module(name = "multi_package")

bazel_dep(name = "rules_cc", version = "0.0.9")
```

## 依赖图
```
main (cc_binary)
  ├─ //src/core:math
  └─ //src/utils:string_utils
```
