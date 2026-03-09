# 项目15: 使用 genrule 生成代码

## 学习目标
- 使用 `genrule` 生成代码
- 理解代码生成流程
- 在构建中使用生成的文件

## 核心概念

### genrule
通用代码生成规则：
- `srcs`: 输入文件
- `outs`: 输出文件
- `cmd`: 生成命令

## 项目结构
```
project15-genrule/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── template.txt
└── main.cc
```

## 实践步骤

### 步骤 1: 创建 template.txt
```
VERSION=1.0.0
BUILD_DATE=2024-01-01
```

### 步骤 2: 创建 BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_binary")

genrule(
    name = "gen_version",
    srcs = ["template.txt"],
    outs = ["version.h"],
    cmd = "echo '#define VERSION \"1.0.0\"' > $(OUTS)",
)

cc_binary(
    name = "main",
    srcs = ["main.cc", ":gen_version"],
)
```

### 步骤 3: 创建 main.cc
```cpp
#include <iostream>
#include "version.h"

int main() {
    std::cout << "Version: " << VERSION << std::endl;
    return 0;
}
```
