VersionInfo = provider(
    fields = {
        "version": "版本号",
        "build_date": "构建日期",
    }
)

def _version_lib_impl(ctx):
    return [VersionInfo(
        version = ctx.attr.version,
        build_date = "2024-01-01",
    )]

version_lib = rule(
    implementation = _version_lib_impl,
    attrs = {"version": attr.string()},
)

def _print_version_impl(ctx):
    info = ctx.attr.dep[VersionInfo]
    out = ctx.actions.declare_file(ctx.attr.name + ".txt")
    ctx.actions.write(
        output = out,
        content = "Version: {}\nDate: {}".format(
            info.version, info.build_date
        ),
    )
    return [DefaultInfo(files = depset([out]))]

print_version = rule(
    implementation = _print_version_impl,
    attrs = {"dep": attr.label()},
)
