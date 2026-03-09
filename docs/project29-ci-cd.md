# 项目29: GitHub Actions 集成 - CI/CD 实战

## 为什么需要 CI/CD？

**核心问题**: 如何确保每次提交都能正确构建和测试？

## Bazel 在 CI 中的优势

1. **增量构建** - 只构建变化的部分
2. **远程缓存** - 团队共享构建结果
3. **可重现** - 相同输入保证相同输出

## 项目结构
```
project29-ci-cd/
├── .github/
│   └── workflows/
│       └── ci.yml
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── main.cc
└── main_test.cc
```

## 实践步骤

### 步骤 1: 创建 .github/workflows/ci.yml
```yaml
name: CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Bazel
        run: |
          wget https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64
          chmod +x bazelisk-linux-amd64
          sudo mv bazelisk-linux-amd64 /usr/local/bin/bazel

      - name: Build
        run: bazel build //...

      - name: Test
        run: bazel test //...
```

### 步骤 2: 创建 main.cc
```cpp
#include <iostream>

int add(int a, int b) { return a + b; }

int main() {
    std::cout << "Result: " << add(2, 3) << std::endl;
    return 0;
}
```

### 步骤 3: 创建 main_test.cc
```cpp
#include <iostream>

int add(int a, int b);

int main() {
    if (add(2, 3) != 5) return 1;
    std::cout << "Test passed!" << std::endl;
    return 0;
}
```

### 步骤 4: 创建 BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_test")

cc_binary(
    name = "main",
    srcs = ["main.cc"],
)

cc_test(
    name = "main_test",
    srcs = ["main_test.cc"],
)
```
