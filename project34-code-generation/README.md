# Project 34: 代码生成与模板 (Code Generation & Templates)

## 学习目标
- 使用模板生成代码
- 创建代码生成规则
- 理解 ctx.actions.expand_template
- 实现配置驱动的代码生成

## 核心概念

### 1. 为什么需要代码生成？
- 减少重复代码
- 从配置文件生成代码
- 生成版本信息、构建时间等
- 根据数据模型生成接口代码

### 2. ctx.actions.expand_template
Bazel 提供的模板展开功能：
```python
ctx.actions.expand_template(
    template = ctx.file.template,
    output = output_file,
    substitutions = {
        "{VERSION}": "1.0.0",
    },
)
```

## 项目结构
```
project34-code-generation/
├── MODULE.bazel
├── BUILD
├── codegen.bzl          # 代码生成规则
├── config.h.template    # C++ 头文件模板
├── main.cc             # 使用生成的代码
└── config.json         # 配置文件
```

## 运行示例

```bash
# 构建（会自动生成代码）
bazel build //:app

# 查看生成的代码
cat bazel-bin/config.h

# 运行程序
./bazel-bin/app
```

## 深入理解

### ctx.actions.expand_template 的工作原理

这个 action 执行简单的字符串替换：
```python
ctx.actions.expand_template(
    template = ctx.file.template,
    output = output,
    substitutions = {
        "{KEY}": "value",
    },
)
```
模板中的 `{KEY}` 会被替换为 `value`。

### 代码生成的时机

代码生成发生在**执行阶段**：
1. 分析阶段：Bazel 确定需要生成哪些文件
2. 执行阶段：运行 action 生成代码
3. 编译阶段：使用生成的代码编译

### 更复杂的代码生成

对于复杂场景，可以使用 `ctx.actions.run`：
```python
ctx.actions.run(
    executable = ctx.executable._generator,
    arguments = [config.path, output.path],
    inputs = [config],
    outputs = [output],
)
```
这允许使用自定义的生成器程序。

### 实际应用场景

**1. 版本信息生成**
从 git 标签生成版本号。

**2. API 代码生成**
从 OpenAPI/Swagger 规范生成客户端代码。

**3. 配置代码生成**
从 JSON/YAML 配置生成 C++ 常量。

**4. 协议代码生成**
从 Protocol Buffers 定义生成序列化代码。

### 生成文件的依赖

生成的文件可以作为其他目标的依赖：
```python
cc_binary(
    name = "app",
    srcs = ["main.cc", ":gen_config"],
)
```
Bazel 会自动处理依赖顺序。

## 关键要点

- `ctx.actions.expand_template` 用于简单的模板替换
- 代码生成在执行阶段进行
- 生成的文件可以作为编译输入
- 适合从配置生成代码，减少重复
- 复杂生成可以使用自定义生成器程序

