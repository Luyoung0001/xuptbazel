# 项目13: 跨平台构建

## 学习目标
- 使用 `select()` 实现条件编译
- 理解平台检测
- 为不同操作系统配置不同的编译选项

## 核心概念

### select() 函数
根据条件选择不同的值：
```python
deps = select({
    "@platforms//os:linux": [":linux_lib"],
    "@platforms//os:macos": [":macos_lib"],
    "//conditions:default": [":default_lib"],
})
```

### 平台标识符
Bazel 内置平台：
- `@platforms//os:linux` - Linux 系统
- `@platforms//os:macos` - macOS 系统
- `@platforms//os:windows` - Windows 系统

## 项目结构
```
project13-cross-platform/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── main.cc
├── platform_linux.cc
└── platform_macos.cc
```

## 实践步骤

### 步骤 1: 创建 platform_linux.cc
```cpp
#include <iostream>

void print_platform() {
    std::cout << "Running on Linux" << std::endl;
}
```

### 步骤 2: 创建 platform_macos.cc
```cpp
#include <iostream>

void print_platform() {
    std::cout << "Running on macOS" << std::endl;
}
```

### 步骤 3: 创建 main.cc
```cpp
#include <iostream>

void print_platform();

int main() {
    print_platform();
    return 0;
}
```

### 步骤 4: 创建 BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "main",
    srcs = ["main.cc"] + select({
        "@platforms//os:linux": ["platform_linux.cc"],
        "@platforms//os:macos": ["platform_macos.cc"],
    }),
)
```

**关键点**: `select()` 根据平台选择不同的源文件

### 步骤 5: 创建 MODULE.bazel
```python
module(name = "cross_platform")

bazel_dep(name = "rules_cc", version = "0.0.9")
bazel_dep(name = "platforms", version = "0.0.8")
```

### 步骤 6: 运行
```bash
bazel run //:main
# 输出: Running on Linux (或 macOS)
```
