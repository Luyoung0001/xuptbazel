# 项目12: 工具链版本依赖绑定

## 项目说明

这个项目演示如何在 Bazel 中绑定和管理工具版本。

## 使用的工具版本

- Python 3.11 (默认)
- Python 3.9 (可选)

## 运行示例

### 使用默认版本 (Python 3.11)
```bash
bazel run //src:hello
```

### 切换到 Python 3.9
```bash
bazel run //src:hello --@rules_python//python/config_settings:python_version=3.9
```

## 配置说明

- `.bazelrc` - 设置默认 Python 版本
- `MODULE.bazel` - 注册可用的 Python 版本
- `src/BUILD` - 定义构建目标

## 验证版本

运行程序会输出当前使用的 Python 版本。
