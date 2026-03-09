# Project 30: 远程缓存 (Remote Caching)

## 学习目标
- 理解 Bazel 的缓存机制
- 配置本地磁盘缓存
- 理解远程缓存的工作原理
- 学习如何加速团队构建

## 核心概念

### 1. Bazel 缓存层次
Bazel 有多层缓存机制：
- **内存缓存**: 单次构建中的临时缓存
- **本地磁盘缓存**: 持久化到本地磁盘
- **远程缓存**: 团队共享的缓存服务器

### 2. 缓存键 (Cache Key)
Bazel 通过以下因素计算缓存键：
- 输入文件的内容哈希
- 构建规则的定义
- 工具链版本
- 编译选项

只有当所有因素完全相同时，才能命中缓存。

### 3. 本地磁盘缓存
使用 `--disk_cache` 标志指定缓存目录：
```bash
bazel build //... --disk_cache=/tmp/bazel-cache
```

### 4. 远程缓存协议
Bazel 支持两种远程缓存协议：
- **HTTP/REST**: 简单的 HTTP 服务器
- **gRPC**: 更高效的二进制协议

## 项目结构
```
project30-remote-cache/
├── MODULE.bazel          # 模块定义
├── BUILD                 # 构建规则
├── .bazelrc             # Bazel 配置文件
├── lib.cc               # 库实现
├── lib.h                # 库头文件
├── main.cc              # 主程序
├── cache_server.py      # 简单的 HTTP 缓存服务器
└── test_cache.sh        # 测试脚本
```

## 实现步骤

### 步骤 1: 创建测试代码
我们创建一个简单的 C++ 项目来演示缓存效果。

### 步骤 2: 配置 .bazelrc
`.bazelrc` 文件可以预设构建选项，避免每次都在命令行指定。

### 步骤 3: 测试本地磁盘缓存
观察使用缓存前后的构建时间差异。

### 步骤 4: 实现简单的 HTTP 缓存服务器
使用 Python 实现一个符合 Bazel 远程缓存协议的服务器。

## 运行示例

### 快速性能测试（推荐）
```bash
./benchmark.sh
```

这个脚本会自动测试并对比：
- 无缓存构建时间
- 磁盘缓存写入时间
- 磁盘缓存读取时间（通常快 2-3 倍）

### 手动测试

1. 测试无缓存构建：
```bash
bazel clean --expunge
time bazel build //...
```

2. 测试本地磁盘缓存：
```bash
# 首次构建（写入缓存）
bazel clean --expunge
time bazel build //... --disk_cache=/tmp/bazel-cache

# 二次构建（读取缓存）
bazel clean
time bazel build //... --disk_cache=/tmp/bazel-cache
```

3. 测试 HTTP 远程缓存：
```bash
# 启动缓存服务器
python3 cache_server.py &

# 首次构建
bazel clean --expunge
time bazel build //... --remote_cache=http://localhost:8080

# 二次构建
bazel clean
time bazel build //... --remote_cache=http://localhost:8080

# 停止服务器
pkill -f cache_server.py
```

## 深入理解

### 缓存的工作原理

当 Bazel 执行一个 action 时，它会：
1. 计算所有输入的哈希值（源文件、依赖、工具链等）
2. 生成一个唯一的 action key
3. 查询缓存：如果 key 存在，直接使用缓存结果
4. 如果不存在，执行 action 并将结果存入缓存

### 为什么缓存如此重要？

在大型项目中：
- 完整构建可能需要几小时
- 使用缓存后，只需重新编译修改的部分
- 团队成员可以共享构建结果
- CI/CD 可以复用之前的构建

### 缓存失效的原因

缓存会在以下情况失效：
- 源文件内容改变
- 编译选项改变（如 -O2 变为 -O3）
- 工具链版本改变
- 依赖的库改变

### 本地 vs 远程缓存

**本地磁盘缓存**：
- 优点：速度快，无网络延迟
- 缺点：不能跨机器共享

**远程缓存**：
- 优点：团队共享，节省整体构建时间
- 缺点：需要网络传输，需要维护服务器

### 实际应用场景

1. **个人开发**：使用本地磁盘缓存加速重复构建
2. **团队协作**：搭建远程缓存服务器，共享构建结果
3. **CI/CD**：在不同的 CI 任务间共享缓存，加速流水线

## 关键要点

- Bazel 的缓存是基于内容寻址的，完全可靠
- 缓存键包含了所有影响输出的因素
- 远程缓存可以显著提升团队效率
- 生产环境建议使用专业的缓存服务（如 Bazel Remote Cache）
