# Project 32: 构建变体 (Build Variants)

## 学习目标
- 理解构建变体的概念
- 使用 config_setting 定义构建配置
- 通过 select() 实现条件编译
- 创建 debug/release 等多种构建模式

## 核心概念

### 1. 什么是构建变体？
构建变体允许同一份代码生成不同版本的产物：
- Debug 版本：包含调试信息，未优化
- Release 版本：优化编译，去除调试信息
- Profile 版本：包含性能分析工具

### 2. config_setting
定义构建配置的匹配条件：
```python
config_setting(
    name = "debug_mode",
    values = {"compilation_mode": "dbg"},
)
```

### 3. select() 条件选择
根据配置选择不同的值：
```python
copts = select({
    ":debug_mode": ["-g", "-O0"],
    "//conditions:default": ["-O2"],
})
```

## 项目结构
```
project32-build-variants/
├── MODULE.bazel
├── BUILD
├── main.cc              # 主程序
└── debug_utils.cc       # 调试工具（仅 debug 模式）
```

## 运行示例

```bash
# Debug 模式构建
bazel build //:app -c dbg

# Release 模式构建（优化）
bazel build //:app -c opt

# 查看编译选项差异
bazel build //:app -c dbg -s | grep "main.cc"
bazel build //:app -c opt -s | grep "main.cc"
```

## 深入理解

### Bazel 的编译模式

Bazel 内置三种编译模式：
- **fastbuild** (默认): 快速编译，最小优化
- **dbg**: 调试模式，包含调试符号
- **opt**: 优化模式，最大性能

通过 `-c` 标志指定：
```bash
bazel build //:app -c dbg   # 调试模式
bazel build //:app -c opt   # 优化模式
```

### config_setting 的匹配机制

`config_setting` 可以匹配多种条件：
```python
config_setting(
    name = "linux_x64",
    values = {
        "cpu": "k8",
        "compilation_mode": "opt",
    },
)
```
所有条件必须同时满足才会匹配。

### select() 的工作原理

`select()` 在分析阶段（loading phase）求值：
```python
copts = select({
    ":debug_mode": ["-DDEBUG"],
    ":opt_mode": ["-O3"],
    "//conditions:default": ["-O2"],
})
```
Bazel 会根据当前配置选择匹配的分支。

### 条件编译的最佳实践

**1. 使用宏定义控制代码**
```cpp
#ifdef DEBUG
    // 调试代码
#endif
```

**2. 通过 copts 传递宏**
```python
copts = select({
    ":debug_mode": ["-DDEBUG"],
})
```

**3. 条件依赖**
```python
deps = select({
    ":debug_mode": [":debug_lib"],
    "//conditions:default": [],
})
```

### 自定义构建配置

除了内置的编译模式，还可以定义自定义配置：
```python
config_setting(
    name = "mobile",
    define_values = {"platform": "mobile"},
)
```

使用：
```bash
bazel build //:app --define platform=mobile
```

## 关键要点

- `config_setting` 定义配置匹配条件
- `select()` 根据配置选择不同的值
- 支持条件编译选项、依赖、源文件
- 可以创建 debug/release 等多种构建变体
- 构建变体让同一份代码适应不同场景

