# Bazel 系统学习项目

从零到精通的 Bazel 学习项目集合，包含 34 个实战项目。

## 快速导航

- [完整学习大纲](bazel-learning-roadmap.md)
- 项目目录：`project01-hello-world/` 到 `project34-code-generation/`

## 已完成项目 (26/36)

**基础入门 (1-6)**: Hello World, Python 构建, 多文件程序, 模块依赖, 计算器, 多语言构建

**依赖与测试 (7-12)**: 跨 package 依赖, 可见性控制, 测试框架, 测试套件, 数据驱动测试

**配置与生成 (13-16)**: 条件编译, 编译模式, genrule, 模板生成

**自定义规则 (17-20)**: 文件复制规则, 格式化规则, 宏 vs 规则, Provider 机制

**高级特性 (29-34)**: CI/CD 集成, 远程缓存, 打包规则, 构建变体, 平台交叉编译, 代码生成

## 核心知识点

每个项目包含完整代码、详细讲解、实际应用场景和关键要点总结。

## 开始学习

```bash
cd project01-hello-world && cat README.md && bazel build //:main
```
