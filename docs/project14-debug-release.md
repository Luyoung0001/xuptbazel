# 项目14: Debug/Release 模式切换

## 学习目标
- 使用 `config_setting` 定义配置
- 通过 `select()` 切换编译选项
- 理解编译标志的使用

## 核心概念

### config_setting
定义自定义配置条件：
```python
config_setting(
    name = "debug_mode",
    values = {"compilation_mode": "dbg"},
)
```

### 编译模式
Bazel 内置三种模式：
- `fastbuild` - 快速构建（默认）
- `dbg` - Debug 模式
- `opt` - 优化模式

## 项目结构
```
project14-debug-release/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
└── main.cc
```

## 实践步骤

### 步骤 1: 创建 main.cc
```cpp
#include <iostream>

int main() {
#ifdef DEBUG
    std::cout << "Debug mode enabled" << std::endl;
#else
    std::cout << "Release mode" << std::endl;
#endif
    return 0;
}
```

### 步骤 2: 创建 BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_binary")

config_setting(
    name = "debug_mode",
    values = {"compilation_mode": "dbg"},
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    copts = select({
        ":debug_mode": ["-DDEBUG", "-g"],
        "//conditions:default": ["-O2"],
    }),
)
```

### 步骤 3: 运行不同模式
```bash
# Debug 模式
bazel run //:main -c dbg
# 输出: Debug mode enabled

# Release 模式
bazel run //:main -c opt
# 输出: Release mode
```
