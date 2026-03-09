# 项目12: 工具链版本依赖绑定

## 项目概述

这个项目将深入讲解如何在 Bazel 中：
1. 绑定特定版本的编译器和工具
2. 管理多个工具链版本
3. 在不同项目中使用不同工具版本
4. 实现可重现的构建环境

## 为什么需要版本绑定？

在实际项目中，你可能遇到：
- 不同开发者使用不同版本的编译器导致构建不一致
- CI/CD 环境与本地环境工具版本不同
- 需要同时支持多个工具版本
- 需要确保构建的可重现性

Bazel 通过**工具链（Toolchains）**机制解决这些问题。

## 核心概念

### 1. 工具链（Toolchain）
工具链是 Bazel 中用于封装构建工具的机制：
- 编译器（gcc, clang）
- 解释器（python, node）
- 其他构建工具

### 2. 工具链类型（Toolchain Type）
定义工具链的接口，例如：
- `@bazel_tools//tools/cpp:toolchain_type` - C++ 工具链
- `@rules_python//python:toolchain_type` - Python 工具链

### 3. 工具链解析（Toolchain Resolution）
Bazel 根据平台和约束自动选择合适的工具链。

## 项目结构
```
project12-toolchain-versions/
├── WORKSPACE
├── MODULE.bazel
├── .bazelrc
├── BUILD
├── toolchains/
│   ├── BUILD
│   └── python_toolchain.bzl
├── src/
│   ├── BUILD
│   └── hello.py
└── README.md
```

## 实战：绑定 Python 版本

我们将创建一个项目，演示如何绑定特定的 Python 版本。

### 步骤 1: 理解 Python 工具链

在 Bazel 中，Python 工具链包含：
- Python 解释器路径
- Python 版本信息
- 标准库路径

### 步骤 2: 创建 MODULE.bazel

```python
module(name = "toolchain_demo")

bazel_dep(name = "rules_python", version = "0.31.0")

# 注册 Python 工具链
python = use_extension("@rules_python//python/extensions:python.bzl", "python")

# 绑定 Python 3.11
python.toolchain(
    python_version = "3.11",
)

# 绑定 Python 3.9（可选）
python.toolchain(
    python_version = "3.9",
)
```

**关键点**：
- `python.toolchain()` 注册 Python 版本
- Bazel 会自动下载指定版本的 Python
- 可以注册多个版本，通过配置选择使用哪个

### 步骤 3: 创建 .bazelrc 配置默认版本

```bash
# 设置默认 Python 版本
build --@rules_python//python/config_settings:python_version=3.11
```

这个配置文件让所有构建默认使用 Python 3.11。

### 步骤 4: 创建示例代码 src/hello.py

```python
import sys

def main():
    print(f"Hello from Python {sys.version}")
    print(f"Python version: {sys.version_info.major}.{sys.version_info.minor}")

if __name__ == "__main__":
    main()
```

### 步骤 5: 创建 src/BUILD

```python
load("@rules_python//python:defs.bzl", "py_binary")

py_binary(
    name = "hello",
    srcs = ["hello.py"],
    main = "hello.py",
)
```

### 步骤 6: 运行和验证

```bash
# 使用默认版本（3.11）运行
bazel run //src:hello

# 输出：
# Hello from Python 3.11.x
# Python version: 3.11

# 切换到 Python 3.9
bazel run //src:hello --@rules_python//python/config_settings:python_version=3.9

# 输出：
# Hello from Python 3.9.x
# Python version: 3.9
```

## 高级：自定义工具链

现在让我们创建一个自定义工具链，演示更底层的控制。

### 步骤 7: 创建 toolchains/python_toolchain.bzl

```python
def _python_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        python_version = ctx.attr.python_version,
        python_path = ctx.attr.python_path,
    )
    return [toolchain_info]

python_toolchain = rule(
    implementation = _python_toolchain_impl,
    attrs = {
        "python_version": attr.string(mandatory = True),
        "python_path": attr.string(mandatory = True),
    },
)
```

这个规则定义了一个简单的 Python 工具链。

### 步骤 8: 创建 toolchains/BUILD

```python
load(":python_toolchain.bzl", "python_toolchain")

# 定义工具链类型
toolchain_type(name = "python_toolchain_type")

# 创建 Python 3.11 工具链
python_toolchain(
    name = "python311_toolchain_impl",
    python_version = "3.11",
    python_path = "/usr/bin/python3.11",
)

toolchain(
    name = "python311_toolchain",
    toolchain = ":python311_toolchain_impl",
    toolchain_type = ":python_toolchain_type",
)
```

## 实际应用场景

### 场景 1: 锁定编译器版本

在 C++ 项目中锁定 GCC 版本：

```python
# .bazelrc
build --action_env=CC=/usr/bin/gcc-11
build --action_env=CXX=/usr/bin/g++-11
```

### 场景 2: CI/CD 环境一致性

```python
# .bazelrc.ci
build --@rules_python//python/config_settings:python_version=3.11
build --action_env=PATH=/opt/python3.11/bin:$PATH
```

在 CI 中使用：
```bash
bazel test --config=ci //...
```

### 场景 3: 多版本兼容性测试

```bash
# 测试 Python 3.9
bazel test --@rules_python//python/config_settings:python_version=3.9 //...

# 测试 Python 3.11
bazel test --@rules_python//python/config_settings:python_version=3.11 //...
```

## 最佳实践

### 1. 使用 .bazelrc 管理配置
```bash
# .bazelrc
build --@rules_python//python/config_settings:python_version=3.11
test --test_output=errors
```

### 2. 版本锁定在 MODULE.bazel
```python
bazel_dep(name = "rules_python", version = "0.31.0")  # 精确版本
```

### 3. 文档化工具版本
在 README.md 中记录：
- 需要的工具版本
- 如何切换版本
- CI/CD 使用的版本

### 4. 验证工具版本
```bash
# 查看使用的 Python 版本
bazel run //src:hello

# 查看工具链信息
bazel cquery --output=build //src:hello
```

## 关键要点总结

1. **MODULE.bazel** - 声明和注册工具链版本
2. **.bazelrc** - 配置默认版本和构建选项
3. **命令行参数** - 临时切换版本
4. **工具链规则** - 自定义工具链实现

## 优势

✅ **可重现构建** - 所有开发者使用相同工具版本
✅ **版本隔离** - 不依赖系统安装的工具
✅ **灵活切换** - 轻松测试多个版本
✅ **CI/CD 一致** - 本地和 CI 环境完全一致
