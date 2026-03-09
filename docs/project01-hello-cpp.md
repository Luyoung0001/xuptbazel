# 项目1: Hello World - 编译单个 C++ 文件

## 学习目标
- 创建第一个 WORKSPACE 文件
- 编写第一个 BUILD 文件
- 使用 `cc_binary` 规则
- 执行 `bazel build` 和 `bazel run`

## 项目结构
```
project01-hello-cpp/
├── WORKSPACE
├── BUILD
└── hello.cc
```

## 核心概念详解

### WORKSPACE 文件
这是 Bazel 项目的根标识文件。即使是空文件也必须存在。它告诉 Bazel：
- 这里是项目的根目录
- 所有的 `//` 标签都从这里开始

### BUILD 文件
定义构建规则的文件。每个包（目录）可以有一个 BUILD 文件。

### cc_binary 规则
用于构建 C++ 可执行文件，主要属性：
- `name`: 目标名称（必需）
- `srcs`: 源文件列表（必需）
- `deps`: 依赖的库
- `copts`: 编译选项
- `linkopts`: 链接选项

## 实践步骤

### 步骤 1: 创建项目目录
```bash
mkdir -p project01-hello-cpp
cd project01-hello-cpp
```

### 步骤 2: 创建 WORKSPACE
```bash
touch WORKSPACE
```
空文件即可，表示这是 Bazel 项目根目录。

### 步骤 3: 创建 hello.cc
```cpp
#include <iostream>

int main() {
    std::cout << "Hello, Bazel!" << std::endl;
    return 0;
}
```

### 步骤 4: 创建 BUILD 文件
```python
cc_binary(
    name = "hello",
    srcs = ["hello.cc"],
)
```

**解释**:
- `cc_binary`: 告诉 Bazel 这是一个 C++ 可执行文件
- `name = "hello"`: 目标名称，生成的可执行文件名
- `srcs = ["hello.cc"]`: 源文件列表

### 步骤 5: 构建项目
```bash
bazel build //:hello
```

**输出解析**:
```
INFO: Analyzed target //:hello (15 packages loaded, 50 targets configured).
INFO: Found 1 target...
Target //:hello up-to-date:
  bazel-bin/hello
INFO: Build completed successfully, 3 total actions
```

- `//:hello` 表示根目录下的 hello 目标
- `bazel-bin/hello` 是生成的可执行文件路径

### 步骤 6: 运行程序
```bash
bazel run //:hello
```

**输出**:
```
INFO: Running command line: bazel-bin/hello
Hello, Bazel!
```

或者直接运行生成的文件：
```bash
./bazel-bin/hello
```

## 深入理解

### Bazel 的构建过程
1. **加载阶段**: 读取 WORKSPACE 和 BUILD 文件
2. **分析阶段**: 构建依赖图
3. **执行阶段**: 运行必要的编译命令

### 目录结构
Bazel 创建的目录：
- `bazel-bin/`: 构建输出（可执行文件、库）
- `bazel-out/`: 中间文件
- `bazel-testlogs/`: 测试日志
- `bazel-<project>/`: 指向项目根目录的符号链接

这些都是符号链接，实际文件在用户缓存目录中。

### 增量构建
再次运行 `bazel build //:hello`：
```
INFO: Analyzed target //:hello (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:hello up-to-date:
  bazel-bin/hello
INFO: Build completed successfully, 1 total action
```

注意 "0 packages loaded" - Bazel 检测到没有变化，直接使用缓存！

## 练习任务

1. **修改输出**: 改变 hello.cc 的输出内容，重新构建观察增量编译
2. **添加编译选项**: 在 BUILD 中添加 `copts = ["-Wall"]`
3. **查看详细输出**: 使用 `bazel build //:hello --verbose_failures`
4. **清理构建**: 运行 `bazel clean`，观察目录变化

## 常见问题

**Q: 为什么用 `//` 开头？**
A: `//` 表示从 WORKSPACE 根目录开始的绝对路径。`:hello` 前面的 `//` 表示当前包在根目录。

**Q: bazel-bin 是什么？**
A: 符号链接，指向实际的构建输出目录。Bazel 使用沙箱隔离构建。

**Q: 可以不用 bazel run 吗？**
A: 可以，直接运行 `./bazel-bin/hello`。但 `bazel run` 会先确保构建是最新的。

## 下一步

完成这个项目后，你已经掌握了：
✅ Bazel 项目的基本结构
✅ 如何编写简单的 BUILD 文件
✅ 使用 cc_binary 构建 C++ 程序
✅ bazel build 和 bazel run 命令

准备好进入项目2：Python 脚本构建！
