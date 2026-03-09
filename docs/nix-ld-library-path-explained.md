# LD_LIBRARY_PATH 和 Nix 标准库详解

## 问题1: LD_LIBRARY_PATH 的作用

```bash
export LD_LIBRARY_PATH="${pkgsPinned.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
```

### 作用
- `LD_LIBRARY_PATH` 是 Linux 动态链接器使用的环境变量
- 告诉系统在**运行时**去哪里找共享库（.so 文件）
- 当你运行程序时，动态链接器会在这些路径中查找 `libstdc++.so.6` 等库

### 为什么需要它？
你的程序编译后是这样的：
```
hello (可执行文件)
  └─ 依赖 libstdc++.so.6 (C++ 标准库)
  └─ 依赖 libc.so.6 (C 标准库)
```

运行时，系统需要找到这些 `.so` 文件。

---

## 问题2: pkgsPinned.stdenv.cc.cc.lib 是什么？

这是 Nix 的层级结构，让我们逐层解析：

```
pkgsPinned                    # Nix 包集合
  └─ stdenv                   # 标准构建环境
      └─ cc                   # C/C++ 编译器包装器
          └─ cc               # 实际的编译器（gcc/clang）
              └─ lib          # 编译器附带的库目录
```

### 具体路径
在你的系统上，这个路径展开后类似：
```
/nix/store/xxxxx-gcc-13.2.0/lib
```

里面包含：
- `libstdc++.so.6` - C++ 标准库
- `libgcc_s.so.1` - GCC 运行时库
- 其他编译器支持库

### 是"我们的"库吗？
**是的！** 这是 Nix 为你提供的 C++ 标准库。

---

## 问题3: Bazel 能获取到这个环境变量吗？

### 答案：部分能，但有限制

#### Bazel 的两个阶段

**1. 编译阶段（Build Time）**
- Bazel 在沙箱中编译
- 默认**不继承**大部分环境变量
- 使用 `--action_env` 可以传递环境变量

**2. 运行阶段（Run Time）**
- `bazel run` 会继承当前 shell 的环境变量
- 包括 `LD_LIBRARY_PATH`
- 所以你的程序能找到库

#### 验证一下

```bash
# 查看 Nix 提供的库路径
echo $LD_LIBRARY_PATH

# 查看实际路径
ls -la $(echo $LD_LIBRARY_PATH | cut -d: -f1)
# 你会看到 libstdc++.so.6 等文件

# 运行程序时，动态链接器会使用这个路径
ldd bazel-bin/hello
# 输出会显示 libstdc++.so.6 => /nix/store/xxxxx/lib/libstdc++.so.6
```

---

## 总结

1. **LD_LIBRARY_PATH**: 告诉运行时去哪找 .so 文件
2. **pkgsPinned.stdenv.cc.cc.lib**: Nix 提供的 GCC 标准库路径
3. **Bazel 编译时**: 不需要这个变量（编译器知道库在哪）
4. **Bazel 运行时**: 需要这个变量（动态链接器需要找到 .so）

这就是为什么我们在 `shellHook` 中设置它！
