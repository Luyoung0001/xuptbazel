# 项目20: Provider 机制 - 规则间通信的本质

## 为什么需要 Provider？

**核心问题**: 规则如何传递信息给依赖它的规则？

例如：
- C++ 库如何告诉二进制文件需要链接哪些库？
- 如何传递编译选项？
- 如何收集所有依赖的头文件？

## Provider 的本质

Provider 是规则的**输出接口**，类似于：
- 函数的返回值
- API 的响应格式

### 内置 Provider
- `DefaultInfo` - 默认输出文件
- `CcInfo` - C++ 编译信息
- `PyInfo` - Python 运行时信息

### 自定义 Provider
定义自己的数据结构

## 项目结构
```
project20-provider/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── provider.bzl
└── consumer.bzl
```

## 实践：创建版本信息 Provider

### 步骤 1: 定义 Provider
```python
# provider.bzl
VersionInfo = provider(
    fields = {
        "version": "版本号",
        "build_date": "构建日期",
    }
)
```

**关键**: Provider 定义数据结构

### 步骤 2: 创建生产者规则
```python
def _version_lib_impl(ctx):
    return [VersionInfo(
        version = ctx.attr.version,
        build_date = "2024-01-01",
    )]

version_lib = rule(
    implementation = _version_lib_impl,
    attrs = {"version": attr.string()},
)
```

**关键**: 规则返回 Provider 实例

### 步骤 3: 创建消费者规则
```python
def _print_version_impl(ctx):
    info = ctx.attr.dep[VersionInfo]
    out = ctx.actions.declare_file(ctx.attr.name + ".txt")
    ctx.actions.write(
        output = out,
        content = "Version: {}\nDate: {}".format(
            info.version, info.build_date
        ),
    )
    return [DefaultInfo(files = depset([out]))]

print_version = rule(
    implementation = _print_version_impl,
    attrs = {"dep": attr.label()},
)
```

**关键**: 通过 `ctx.attr.dep[VersionInfo]` 读取 Provider

### 步骤 4: 创建 BUILD
```python
load(":provider.bzl", "version_lib", "print_version")

version_lib(
    name = "v1",
    version = "1.0.0",
)

print_version(
    name = "show",
    dep = ":v1",
)
```

### 步骤 5: 运行
```bash
bazel build //:show
cat bazel-bin/show.txt
```
