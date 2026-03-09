# 项目16: 从模板生成配置文件

## 学习目标
- 使用 genrule 处理模板
- 生成配置文件
- 在构建中使用生成的配置

## 项目结构
```
project16-template/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── config.template
└── main.cc
```

## 实践步骤

### 步骤 1: 创建 config.template
```
APP_NAME=MyApp
VERSION=2.0
DEBUG=true
```

### 步骤 2: 创建 BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_binary")

genrule(
    name = "gen_config",
    srcs = ["config.template"],
    outs = ["config.h"],
    cmd = """
    echo '#define APP_NAME "MyApp"' > $(OUTS)
    echo '#define VERSION "2.0"' >> $(OUTS)
    """,
)

cc_binary(
    name = "main",
    srcs = ["main.cc", ":gen_config"],
)
```

### 步骤 3: 创建 main.cc
```cpp
#include <iostream>
#include "config.h"

int main() {
    std::cout << "App: " << APP_NAME << std::endl;
    std::cout << "Version: " << VERSION << std::endl;
    return 0;
}
```
