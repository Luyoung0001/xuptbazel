# 项目2: 简单的 Python 脚本构建

## 学习目标
- 使用 `py_binary` 规则
- 理解 Python 在 Bazel 中的构建方式
- 对比 C++ 和 Python 的构建差异

## 核心概念

### py_binary 规则
构建 Python 可执行文件，主要属性：
- `name`: 目标名称
- `srcs`: Python 源文件（必须包含 `__main__`）
- `deps`: 依赖的 Python 库
- `python_version`: "PY2" 或 "PY3"（默认 PY3）

### Python 在 Bazel 中的特点
- **不需要编译**: Python 是解释型语言
- **依赖管理**: Bazel 会打包所有依赖
- **可执行包装器**: Bazel 生成一个 shell 脚本来运行 Python

## 项目结构
```
project02-hello-python/
├── WORKSPACE
├── MODULE.bazel    # Bazel 6.0+ 新的依赖管理
├── BUILD
└── hello.py
```

## 实践步骤

### 步骤 0: 创建 MODULE.bazel（Bazel 6.0+）
```python
module(name = "hello_python")

bazel_dep(name = "rules_python", version = "0.31.0")
```

**重要**: Bazel 6.0+ 使用 Bzlmod（MODULE.bazel）替代 WORKSPACE 管理外部依赖。

### 步骤 1: 创建 hello.py
```python
#!/usr/bin/env python3

def main():
    print("Hello, Bazel from Python!")
    print("Python is interpreted, not compiled!")

if __name__ == "__main__":
    main()
```

### 步骤 2: 创建 BUILD 文件
```python
py_binary(
    name = "hello",
    srcs = ["hello.py"],
)
```

### 步骤 3: 构建和运行
```bash
cd project02-hello-python
bazel build //:hello
bazel run //:hello
```

## 与 C++ 的对比

| 特性 | C++ (cc_binary) | Python (py_binary) |
|------|-----------------|-------------------|
| 编译 | 需要编译成机器码 | 不需要编译 |
| 速度 | 构建慢，运行快 | 构建快，运行慢 |
| 输出 | 二进制可执行文件 | Python 脚本 + 包装器 |
| 依赖 | 链接库文件 | 打包 .py 文件 |

## 练习任务

1. 添加命令行参数处理（使用 `sys.argv`）
2. 导入标准库（如 `import datetime`）
3. 对比构建时间：`time bazel build //:hello`
