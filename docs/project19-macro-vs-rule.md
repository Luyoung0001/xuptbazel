# 项目19: 宏 vs 规则 - 理解本质区别

## 为什么需要理解这个？

很多人混淆宏和规则，导致：
- 构建性能问题
- 难以调试
- 无法使用高级特性

**核心问题**: 什么时候用宏？什么时候用规则？

## 本质区别

### 宏（Macro）
- **执行时机**: 加载阶段（Loading Phase）
- **本质**: 代码生成器，展开成多个规则
- **类比**: C 语言的 #define

### 规则（Rule）
- **执行时机**: 分析和执行阶段（Analysis & Execution Phase）
- **本质**: 构建动作的定义
- **类比**: 函数调用

## 思考题

**Q1**: 为什么宏不能访问文件内容？
**A**: 因为宏在加载阶段执行，此时文件还没有被构建出来。

**Q2**: 为什么规则可以声明依赖？
**A**: 规则在分析阶段执行，可以构建依赖图。

## 项目结构
```
project19-macro-vs-rule/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── macro.bzl
└── rule.bzl
```

## 实践：对比宏和规则

### 步骤 1: 创建 macro.bzl（宏）
```python
def multi_copy_macro(name, srcs):
    """宏：在加载阶段展开成多个规则"""
    for i, src in enumerate(srcs):
        native.genrule(
            name = "{}_{}".format(name, i),
            srcs = [src],
            outs = ["{}.copy".format(src)],
            cmd = "cp $< $@",
        )
```

**关键**: `native.genrule` 在加载时立即执行

### 步骤 2: 创建 rule.bzl（规则）
```python
def _multi_copy_impl(ctx):
    """规则：在执行阶段处理文件"""
    outputs = []
    for src in ctx.files.srcs:
        out = ctx.actions.declare_file(src.basename + ".copy")
        ctx.actions.run_shell(
            inputs = [src],
            outputs = [out],
            command = "cp {} {}".format(src.path, out.path),
        )
        outputs.append(out)
    return [DefaultInfo(files = depset(outputs))]

multi_copy_rule = rule(
    implementation = _multi_copy_impl,
    attrs = {"srcs": attr.label_list(allow_files = True)},
)
```

**关键**: 规则在分析阶段声明动作，执行阶段才运行

### 步骤 3: 创建 BUILD 对比
```python
load(":macro.bzl", "multi_copy_macro")
load(":rule.bzl", "multi_copy_rule")

# 使用宏
multi_copy_macro(
    name = "macro_copy",
    srcs = ["file1.txt", "file2.txt"],
)

# 使用规则
multi_copy_rule(
    name = "rule_copy",
    srcs = ["file1.txt", "file2.txt"],
)
```

## 深度对比

### 查看宏展开结果
```bash
bazel query --output=build //:macro_copy_0
# 输出: genrule(name = "macro_copy_0", ...)
```

**发现**: 宏生成了 2 个独立的 genrule 目标

### 查看规则结果
```bash
bazel query --output=build //:rule_copy
# 输出: multi_copy_rule(name = "rule_copy", ...)
```

**发现**: 规则只有 1 个目标

## 何时使用？

**宏**: 批量生成目标，简化 BUILD
**规则**: 处理文件，复杂依赖
