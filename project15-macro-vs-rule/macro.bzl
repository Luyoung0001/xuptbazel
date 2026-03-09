def multi_copy_macro(name, srcs):
    """宏：在加载阶段展开成多个规则"""
    for i, src in enumerate(srcs):
        native.genrule(
            name = "{}_{}".format(name, i),
            srcs = [src],
            outs = ["{}.copy".format(src)],
            cmd = "cp $< $@",
        )
