# 项目15: Protocol Buffers 集成

## 学习目标
- 使用 `genrule` 生成代码
- 集成 Protocol Buffers
- 理解代码生成流程

## 核心概念

### genrule
通用代码生成规则：
```python
genrule(
    name = "gen",
    srcs = ["input.txt"],
    outs = ["output.txt"],
    cmd = "cat $(SRCS) > $(OUTS)",
)
```

### Protocol Buffers
- 定义 .proto 文件
- 生成 C++ 代码
- 在程序中使用

## 项目结构
```
project15-protobuf/
├── WORKSPACE
├── MODULE.bazel
├── BUILD
├── person.proto
└── main.cc
```

## 实践步骤

### 步骤 1: 创建 person.proto
```protobuf
syntax = "proto3";

message Person {
    string name = 1;
    int32 age = 2;
}
```

### 步骤 2: 创建 main.cc
```cpp
#include <iostream>
#include "person.pb.h"

int main() {
    Person person;
    person.set_name("Alice");
    person.set_age(30);

    std::cout << "Name: " << person.name() << std::endl;
    std::cout << "Age: " << person.age() << std::endl;
    return 0;
}
```

### 步骤 3: 创建 BUILD
```python
load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_proto_library")
load("@rules_proto//proto:defs.bzl", "proto_library")

proto_library(
    name = "person_proto",
    srcs = ["person.proto"],
)

cc_proto_library(
    name = "person_cc_proto",
    deps = [":person_proto"],
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [":person_cc_proto"],
)
```

### 步骤 4: 创建 MODULE.bazel
```python
module(name = "protobuf_demo")

bazel_dep(name = "rules_cc", version = "0.0.9")
bazel_dep(name = "rules_proto", version = "5.3.0-21.7")
bazel_dep(name = "protobuf", version = "21.7")
```
