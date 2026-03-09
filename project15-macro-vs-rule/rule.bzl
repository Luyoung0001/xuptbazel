def _multi_copy_impl(ctx):
    """规则：在执行阶段处理文件"""
    outputs = []
    for src in ctx.files.srcs:
        out = ctx.actions.declare_file(src.basename + ".copy")
        ctx.actions.run_shell(
            inputs = [src],
            outputs = [out],
            command = "cp {} {}".format(src.path, out.path),
        )
        outputs.append(out)
    return [DefaultInfo(files = depset(outputs))]

multi_copy_rule = rule(
    implementation = _multi_copy_impl,
    attrs = {"srcs": attr.label_list(allow_files = True)},
)
