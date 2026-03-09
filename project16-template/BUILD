load("@rules_cc//cc:defs.bzl", "cc_binary")

genrule(
    name = "gen_config",
    srcs = ["config.template"],
    outs = ["config.h"],
    cmd = """
    echo '#define APP_NAME "MyApp"' > $(OUTS)
    echo '#define VERSION "2.0"' >> $(OUTS)
    """,
)

cc_binary(
    name = "main",
    srcs = ["main.cc", ":gen_config"],
)
