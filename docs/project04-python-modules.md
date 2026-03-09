# 项目4: Python 模块依赖

## 学习目标
- 使用 `py_library` 规则
- 理解 Python 模块的依赖关系
- 掌握 Python 包的组织方式

## 核心概念

### py_library 规则
构建 Python 库，主要属性：
- `name`: 库名称
- `srcs`: Python 源文件
- `deps`: 依赖的其他 Python 库
- `imports`: 添加到 PYTHONPATH 的路径

## 项目结构
```
project04-python-modules/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── main.py
└── helper.py
```

## 实践步骤

### 步骤 1: 创建 helper.py
```python
def greet(name):
    return f"Hello, {name}!"

def calculate_sum(numbers):
    return sum(numbers)
```

### 步骤 2: 创建 main.py
```python
from helper import greet, calculate_sum

def main():
    print(greet("Bazel"))
    nums = [1, 2, 3, 4, 5]
    print(f"Sum of {nums} = {calculate_sum(nums)}")

if __name__ == "__main__":
    main()
```

### 步骤 3: 创建 BUILD 文件
```python
load("@rules_python//python:defs.bzl", "py_binary", "py_library")

py_library(
    name = "helper",
    srcs = ["helper.py"],
)

py_binary(
    name = "main",
    srcs = ["main.py"],
    deps = [":helper"],
)
```

### 步骤 4: 创建 MODULE.bazel
```python
module(name = "python_modules")

bazel_dep(name = "rules_python", version = "0.31.0")
```
