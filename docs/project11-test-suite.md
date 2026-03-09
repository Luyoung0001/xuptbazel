# 项目11: 为计算器项目添加完整测试套件

## 学习目标
- 编写多个测试文件
- 测试边界情况和错误处理
- 使用测试标签分类
- 选择性运行测试

## 核心概念

### 测试标签（tags）
用于分类和过滤测试：
```python
cc_test(
    name = "basic_test",
    tags = ["unit", "fast"],
)
```

运行特定标签的测试：
```bash
bazel test --test_tag_filters=unit //...
```

## 项目结构
```
project11-test-suite/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── calculator.h
├── calculator.cc
├── basic_test.cc
└── edge_case_test.cc
```

## 实践步骤

### 步骤 1: 创建 calculator.h
```cpp
#ifndef CALCULATOR_H
#define CALCULATOR_H

class Calculator {
public:
    double add(double a, double b);
    double subtract(double a, double b);
    double multiply(double a, double b);
    double divide(double a, double b);
};

#endif
```

### 步骤 2: 创建 calculator.cc
```cpp
#include "calculator.h"
#include <stdexcept>

double Calculator::add(double a, double b) {
    return a + b;
}

double Calculator::subtract(double a, double b) {
    return a - b;
}

double Calculator::multiply(double a, double b) {
    return a * b;
}

double Calculator::divide(double a, double b) {
    if (b == 0) {
        throw std::runtime_error("Division by zero");
    }
    return a / b;
}
```

### 步骤 3: 创建 basic_test.cc
```cpp
#include "calculator.h"
#include <iostream>

#define ASSERT_EQ(a, b) \
    if ((a) != (b)) { \
        std::cout << "FAIL: " << #a << " != " << #b << std::endl; \
        return 1; \
    }

int main() {
    Calculator calc;

    ASSERT_EQ(calc.add(2, 3), 5);
    ASSERT_EQ(calc.subtract(10, 3), 7);
    ASSERT_EQ(calc.multiply(4, 5), 20);
    ASSERT_EQ(calc.divide(10, 2), 5);

    std::cout << "Basic tests passed!" << std::endl;
    return 0;
}
```

### 步骤 4: 创建 edge_case_test.cc
```cpp
#include "calculator.h"
#include <iostream>
#include <stdexcept>

int main() {
    Calculator calc;

    // Test division by zero
    try {
        calc.divide(10, 0);
        std::cout << "FAIL: Should throw on division by zero" << std::endl;
        return 1;
    } catch (const std::runtime_error&) {
        std::cout << "PASS: Division by zero throws" << std::endl;
    }

    // Test negative numbers
    if (calc.add(-5, -3) != -8) {
        std::cout << "FAIL: Negative addition" << std::endl;
        return 1;
    }

    std::cout << "Edge case tests passed!" << std::endl;
    return 0;
}
```

### 步骤 5: 创建 BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_library", "cc_test")

cc_library(
    name = "calculator",
    srcs = ["calculator.cc"],
    hdrs = ["calculator.h"],
)

cc_test(
    name = "basic_test",
    srcs = ["basic_test.cc"],
    deps = [":calculator"],
    tags = ["unit", "fast"],
)

cc_test(
    name = "edge_case_test",
    srcs = ["edge_case_test.cc"],
    deps = [":calculator"],
    tags = ["unit", "edge"],
)
```

### 步骤 6: 运行测试
```bash
# 运行所有测试
bazel test //...

# 只运行 fast 测试
bazel test --test_tag_filters=fast //...

# 运行所有 unit 测试
bazel test --test_tag_filters=unit //...
```
