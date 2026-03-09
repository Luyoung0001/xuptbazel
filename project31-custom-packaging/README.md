# Project 31: 自定义打包规则 (Custom Packaging Rules)

## 学习目标
- 创建自定义的打包规则
- 理解如何处理文件集合
- 学习生成 tar.gz 和 zip 归档文件
- 掌握规则的输出文件声明

## 核心概念

### 1. 打包规则的需求
在实际项目中，我们经常需要：
- 将编译产物打包成归档文件
- 包含配置文件、文档等资源
- 生成可分发的软件包
- 支持多种归档格式

### 2. 文件集合处理
Bazel 规则需要处理：
- 收集依赖的所有文件
- 过滤特定类型的文件
- 组织文件的目录结构

### 3. ctx.actions.run
使用系统工具（tar, zip）来创建归档：
```python
ctx.actions.run(
    inputs = files,
    outputs = [output],
    executable = "tar",
    arguments = args,
)
```

## 项目结构
```
project31-custom-packaging/
├── MODULE.bazel
├── BUILD
├── packaging.bzl        # 自定义打包规则
├── app.cc              # 示例应用
├── config.txt          # 配置文件
└── README.txt          # 文档
```

## 实现步骤

### 步骤 1: 定义 tar_package 规则
创建一个规则，将文件打包成 .tar.gz 格式。

### 步骤 2: 定义 zip_package 规则
创建一个规则，将文件打包成 .zip 格式。

### 步骤 3: 使用规则打包应用
将编译好的二进制文件和资源文件一起打包。

## 运行示例

```bash
# 构建 tar 包
bazel build //:app_tar

# 构建 zip 包
bazel build //:app_zip

# 查看生成的文件
ls -lh bazel-bin/*.tar.gz bazel-bin/*.zip

# 解压验证
tar -tzf bazel-bin/app.tar.gz
unzip -l bazel-bin/app.zip
```

## 深入理解

### 规则实现的关键点

**1. 声明输出文件**
```python
output = ctx.actions.declare_file(ctx.label.name + ".tar.gz")
```
必须先声明输出文件，Bazel 才能追踪它。

**2. 收集依赖文件**
```python
files = depset(transitive = [dep[DefaultInfo].files for dep in ctx.attr.srcs])
```
使用 `depset` 高效地收集所有传递依赖的文件。

**3. 执行打包命令**
```python
ctx.actions.run_shell(
    inputs = files,
    outputs = [output],
    command = "tar -czf {} ...".format(output.path),
)
```
`run_shell` 允许执行任意 shell 命令。

### depset 的重要性

`depset` 是 Bazel 中的特殊数据结构：
- 避免重复文件
- 高效处理大量文件
- 延迟计算，节省内存

错误示例（不要这样做）：
```python
files = []
for dep in ctx.attr.srcs:
    files += dep[DefaultInfo].files.to_list()  # 低效！
```

正确示例：
```python
files = depset(transitive = [dep[DefaultInfo].files for dep in ctx.attr.srcs])
```

### ctx.actions.run vs ctx.actions.run_shell

**run_shell**：
- 可以使用 shell 语法（管道、重定向等）
- 更灵活但可移植性较差
- 适合简单的命令组合

**run**：
- 直接执行可执行文件
- 更安全、可移植性更好
- 适合调用特定工具

### 改进方向

当前实现的局限性：
1. 文件路径包含 `bazel-out/` 前缀
2. 没有自定义归档内的目录结构
3. 依赖系统的 tar/zip 命令

改进方案：
- 使用 `ctx.actions.run` 替代 `run_shell`
- 添加 `strip_prefix` 参数控制路径
- 使用 Bazel 内置的归档工具

## 关键要点

- 自定义规则可以封装复杂的打包逻辑
- `depset` 是处理文件集合的高效方式
- `ctx.actions.declare_file` 声明输出
- `ctx.actions.run_shell` 执行打包命令
- 打包规则让软件分发变得简单
