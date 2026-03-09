# Bazel 缓存性能测试指南

## 项目结构

```
project30-remote-cache/
├── main.cc           # 主程序
├── lib.cc/lib.h      # 主库（依赖 lib1, lib2, lib3）
├── lib1.cc/lib1.h    # 子库 1
├── lib2.cc/lib2.h    # 子库 2
├── lib3.cc/lib3.h    # 子库 3
└── cache_server.py   # HTTP 缓存服务器
```

## 快速测试

### 运行完整测试（推荐）

```bash
./test_cache_advanced.sh
```

这个脚本会自动测试：
1. 无缓存构建（基准）
2. 磁盘缓存（写入 + 读取）
3. HTTP 远程缓存（写入 + 读取）

并输出详细的时间对比和加速比。

### 手动测试各种缓存

#### 1. 无缓存
```bash
bazel clean
time bazel build //...
```

#### 2. 磁盘缓存
```bash
# 首次构建（写入缓存）
bazel clean
time bazel build //... --disk_cache=/tmp/bazel-disk-cache

# 二次构建（读取缓存）
bazel clean
time bazel build //... --disk_cache=/tmp/bazel-disk-cache
```

#### 3. HTTP 远程缓存
```bash
# 启动缓存服务器
python3 cache_server.py &

# 首次构建（写入缓存）
bazel clean
time bazel build //... --remote_cache=http://localhost:8080

# 二次构建（读取缓存）
bazel clean
time bazel build //... --remote_cache=http://localhost:8080

# 停止服务器
pkill -f cache_server.py
```

## 预期结果

典型的性能对比：

```
无缓存构建:        3-5 秒
磁盘缓存(读):      0.5-1 秒  (3-5x 加速)
HTTP缓存(读):      0.8-1.5 秒 (2-4x 加速)
```

## 说明

- 磁盘缓存最快，因为是本地 I/O
- HTTP 缓存稍慢，因为有网络开销（即使是 localhost）
- 实际项目中，远程缓存的优势在于团队共享
