load("@rules_cc//cc:defs.bzl", "cc_binary")
load(":codegen.bzl", "config_gen")

config_gen(
    name = "gen_config",
    template = "config.h.template",
    config = "config.json",
    out = "config.h",
    app_name = "MyApp",
    version = "1.0.0",
)

cc_binary(
    name = "app",
    srcs = [
        "main.cc",
        ":gen_config",
    ],
)
