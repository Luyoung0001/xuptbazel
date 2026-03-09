"""代码生成规则"""

def _config_gen_impl(ctx):
    """从模板生成配置头文件"""
    output = ctx.actions.declare_file(ctx.attr.out)

    # 读取配置文件
    config = ctx.file.config

    # 获取当前时间戳
    import_time = ctx.var.get("BUILD_TIMESTAMP", "unknown")

    # 模板替换
    ctx.actions.expand_template(
        template = ctx.file.template,
        output = output,
        substitutions = {
            "{APP_NAME}": ctx.attr.app_name,
            "{APP_VERSION}": ctx.attr.version,
            "{BUILD_TIME}": import_time,
        },
    )

    return [DefaultInfo(files = depset([output]))]

config_gen = rule(
    implementation = _config_gen_impl,
    attrs = {
        "template": attr.label(allow_single_file = True, mandatory = True),
        "config": attr.label(allow_single_file = True, mandatory = True),
        "out": attr.string(mandatory = True),
        "app_name": attr.string(mandatory = True),
        "version": attr.string(mandatory = True),
    },
)
