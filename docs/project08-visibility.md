# 项目8: 创建私有库和公共 API

## 学习目标
- 理解 `visibility` 属性
- 区分公共接口和私有实现
- 掌握访问控制

## 核心概念

### Visibility（可见性）
控制哪些目标可以依赖当前目标：

- `["//visibility:public"]` - 所有人可见
- `["//visibility:private"]` - 仅当前 package 可见（默认）
- `["//src/app:__pkg__"]` - 仅指定 package 可见
- `["//src/app:__subpackages__"]` - 指定 package 及其子包可见

## 项目结构
```
project08-visibility/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── main.cc
└── lib/
    ├── BUILD
    ├── public_api.h
    ├── public_api.cc
    ├── internal.h
    └── internal.cc
```

## 实践步骤

### 步骤 1: 创建 lib/internal.h（私有）
```cpp
#ifndef INTERNAL_H
#define INTERNAL_H

int secret_calculation(int x);

#endif
```

### 步骤 2: 创建 lib/internal.cc
```cpp
#include "lib/internal.h"

int secret_calculation(int x) {
    return x * x + 10;
}
```

### 步骤 3: 创建 lib/public_api.h（公共）
```cpp
#ifndef PUBLIC_API_H
#define PUBLIC_API_H

int process(int x);

#endif
```

### 步骤 4: 创建 lib/public_api.cc
```cpp
#include "lib/public_api.h"
#include "lib/internal.h"

int process(int x) {
    return secret_calculation(x) * 2;
}
```

### 步骤 5: 创建 lib/BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_library")

# 私有库 - 仅 lib package 内部使用
cc_library(
    name = "internal",
    srcs = ["internal.cc"],
    hdrs = ["internal.h"],
    visibility = ["//visibility:private"],
)

# 公共库 - 所有人可用
cc_library(
    name = "public_api",
    srcs = ["public_api.cc"],
    hdrs = ["public_api.h"],
    deps = [":internal"],
    visibility = ["//visibility:public"],
)
```

### 步骤 6: 创建 main.cc
```cpp
#include <iostream>
#include "lib/public_api.h"
// #include "lib/internal.h"  // 错误！无法访问私有库

int main() {
    std::cout << "process(5) = " << process(5) << std::endl;
    return 0;
}
```

### 步骤 7: 创建根 BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = ["//lib:public_api"],
)
```

### 步骤 8: 创建 MODULE.bazel
```python
module(name = "visibility")

bazel_dep(name = "rules_cc", version = "0.0.9")
```
