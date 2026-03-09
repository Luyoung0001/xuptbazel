"""自定义打包规则"""

def _tar_package_impl(ctx):
    """tar.gz 打包规则实现"""
    output = ctx.actions.declare_file(ctx.label.name + ".tar.gz")

    # 收集所有输入文件
    files = depset(transitive = [dep[DefaultInfo].files for dep in ctx.attr.srcs])

    # 创建文件列表
    file_list = ctx.actions.declare_file(ctx.label.name + "_files.txt")
    ctx.actions.write(
        output = file_list,
        content = "\n".join([f.path for f in files.to_list()]),
    )

    # 执行 tar 命令
    ctx.actions.run_shell(
        inputs = files,
        outputs = [output],
        command = "tar -czf {} -C . {}".format(
            output.path,
            " ".join([f.path for f in files.to_list()]),
        ),
    )

    return [DefaultInfo(files = depset([output]))]

tar_package = rule(
    implementation = _tar_package_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
    },
)

def _zip_package_impl(ctx):
    """zip 打包规则实现"""
    output = ctx.actions.declare_file(ctx.label.name + ".zip")

    # 收集所有输入文件
    files = depset(transitive = [dep[DefaultInfo].files for dep in ctx.attr.srcs])

    # 执行 zip 命令
    ctx.actions.run_shell(
        inputs = files,
        outputs = [output],
        command = "zip -q {} {}".format(
            output.path,
            " ".join([f.path for f in files.to_list()]),
        ),
    )

    return [DefaultInfo(files = depset([output]))]

zip_package = rule(
    implementation = _zip_package_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
    },
)
