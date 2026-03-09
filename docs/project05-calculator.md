# 项目5: 简单计算器程序

## 学习目标
- 综合运用 cc_library 和 cc_binary
- 实现一个完整的小程序
- 理解模块化设计

## 项目结构
```
project05-calculator/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── main.cc
├── calculator.h
└── calculator.cc
```

## 功能设计
实现基本的四则运算：加、减、乘、除

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

### 步骤 3: 创建 main.cc
```cpp
#include <iostream>
#include "calculator.h"

int main() {
    Calculator calc;

    std::cout << "10 + 5 = " << calc.add(10, 5) << std::endl;
    std::cout << "10 - 5 = " << calc.subtract(10, 5) << std::endl;
    std::cout << "10 * 5 = " << calc.multiply(10, 5) << std::endl;
    std::cout << "10 / 5 = " << calc.divide(10, 5) << std::endl;

    return 0;
}
```

### 步骤 4: 创建 BUILD 文件
```python
load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

cc_library(
    name = "calculator",
    srcs = ["calculator.cc"],
    hdrs = ["calculator.h"],
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [":calculator"],
)
```

### 步骤 5: 创建 MODULE.bazel
```python
module(name = "calculator")

bazel_dep(name = "rules_cc", version = "0.0.9")
```
