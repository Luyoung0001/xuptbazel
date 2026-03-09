# Bazel 安装指南

## 检测到你的系统还没有安装 Bazel

你的系统是 Linux，我推荐使用 Bazelisk（Bazel 版本管理器）。

## 安装方法

### 方法 1: 使用 Bazelisk（推荐）

```bash
# 下载 Bazelisk
wget https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64

# 添加执行权限
chmod +x bazelisk-linux-amd64

# 移动到系统路径
sudo mv bazelisk-linux-amd64 /usr/local/bin/bazel

# 验证安装
bazel version
```

### 方法 2: 使用 npm（如果你有 Node.js）

```bash
npm install -g @bazel/bazelisk
```

### 方法 3: 使用 apt（Ubuntu/Debian）

```bash
# 添加 Bazel 仓库
sudo apt install apt-transport-https curl gnupg
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/bazel.gpg > /dev/null
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list

# 安装 Bazel
sudo apt update
sudo apt install bazel
```

## 安装后继续

安装完成后，回到项目目录运行：

```bash
cd project01-hello-cpp
bazel build //:hello
bazel run //:hello
```

## 需要帮助吗？

如果你想让我帮你安装，请告诉我你想用哪种方法，我可以执行安装命令。
