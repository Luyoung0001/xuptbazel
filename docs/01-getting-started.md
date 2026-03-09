# 1.1 环境搭建与基本概念

## Bazel 是什么？

Bazel 是 Google 开源的构建工具，源自 Google 内部的 Blaze 系统。它的核心优势：

1. **快速**: 增量编译，只重新构建变化的部分
2. **可扩展**: 支持大型代码库（monorepo）
3. **多语言**: 支持 C++, Java, Python, Go 等
4. **可重现**: 相同输入保证相同输出
5. **远程缓存**: 团队共享构建结果

## 核心概念

### 1. WORKSPACE 文件
- 位于项目根目录
- 定义项目边界
- 声明外部依赖
- 一个项目只有一个 WORKSPACE

### 2. BUILD 文件
- 每个包（package）一个
- 定义构建目标（targets）
- 使用 Starlark 语言（Python 子集）

### 3. Target（目标）
构建的基本单位，三种类型：
- **Files**: 源文件或生成文件
- **Rules**: 定义如何从输入生成输出
- **Package groups**: 用于访问控制

### 4. Label（标签）
目标的唯一标识符：
```
//package/path:target_name
```
- `//` 表示 WORKSPACE 根目录
- `package/path` 是包路径
- `:target_name` 是目标名称

### 5. Rule（规则）
定义构建逻辑的函数，常见规则：
- `cc_binary`: C++ 可执行文件
- `cc_library`: C++ 库
- `py_binary`: Python 可执行文件
- `py_library`: Python 库

## 安装 Bazel

### 方法 1: 使用 Bazelisk（推荐）
Bazelisk 是 Bazel 版本管理器，自动下载正确版本。

```bash
# macOS
brew install bazelisk

# Linux
wget https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64
chmod +x bazelisk-linux-amd64
sudo mv bazelisk-linux-amd64 /usr/local/bin/bazel
```

### 方法 2: 直接安装 Bazel
```bash
# Ubuntu/Debian
sudo apt install apt-transport-https curl gnupg
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg
sudo mv bazel.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
sudo apt update && sudo apt install bazel
```

### 验证安装
```bash
bazel version
```

## 基本命令

```bash
# 构建目标
bazel build //path/to:target

# 运行可执行文件
bazel run //path/to:target

# 运行测试
bazel test //path/to:test

# 清理构建输出
bazel clean

# 查询目标信息
bazel query //...
```

## 下一步

现在环境已准备好，让我们开始第一个项目！
