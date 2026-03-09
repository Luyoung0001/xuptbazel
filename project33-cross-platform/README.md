# Project 33: 平台交叉编译 (Cross-Platform Compilation)

## 学习目标
- 理解 Bazel 的平台抽象
- 配置交叉编译工具链
- 为不同平台构建二进制文件
- 使用 platforms 和 constraints

## 核心概念

### 1. 平台 (Platform)
平台定义了目标执行环境：
- CPU 架构 (x86_64, arm64)
- 操作系统 (linux, macos, windows)
- 其他约束条件

### 2. 工具链 (Toolchain)
工具链提供编译工具：
- 编译器 (gcc, clang)
- 链接器
- 标准库

### 3. 交叉编译
在一个平台上为另一个平台构建：
```bash
bazel build //:app --platforms=//:linux_x86_64
```

## 项目结构
```
project33-cross-platform/
├── MODULE.bazel
├── BUILD
├── platforms.bzl        # 平台定义
└── main.cc             # 跨平台代码
```

## 运行示例

```bash
# 查看当前平台
bazel build //:app --announce_rc | grep "platform"

# 为 Linux x86_64 构建
bazel build //:app --platforms=//:linux_x86_64

# 查看平台特定的编译选项
bazel build //:app --platforms=//:linux_x86_64 -s
```

## 深入理解

### 平台的组成

平台由多个约束值组成：
```python
platform(
    name = "linux_x86_64",
    constraint_values = [
        "@platforms//os:linux",      # 操作系统
        "@platforms//cpu:x86_64",    # CPU 架构
    ],
)
```

### 内置的约束

Bazel 提供了标准约束：
- **OS**: `@platforms//os:linux`, `@platforms//os:macos`, `@platforms//os:windows`
- **CPU**: `@platforms//cpu:x86_64`, `@platforms//cpu:arm64`

### 条件依赖平台

可以根据平台选择不同的依赖：
```python
deps = select({
    "@platforms//os:linux": [":linux_lib"],
    "@platforms//os:macos": [":macos_lib"],
    "//conditions:default": [],
})
```

### 交叉编译的挑战

真正的交叉编译需要：
1. 目标平台的工具链（编译器、链接器）
2. 目标平台的系统库
3. 正确的编译选项

示例：在 Linux 上为 Windows 编译需要 MinGW 工具链。

### 平台 vs config_setting

两者都用于条件编译，但有区别：
- **platform**: 现代方式，更灵活，推荐使用
- **config_setting**: 传统方式，基于编译选项

## 关键要点

- `platform` 定义目标执行环境
- 使用 `constraint_values` 指定平台特征
- `--platforms` 标志指定目标平台
- 可以根据平台条件选择依赖和编译选项
- 真正的交叉编译需要配置工具链


