load("@rules_cc//cc:defs.bzl", "cc_binary")

config_setting(
    name = "debug_mode",
    values = {"compilation_mode": "dbg"},
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    copts = select({
        ":debug_mode": ["-DDEBUG", "-g"],
        "//conditions:default": ["-O2"],
    }),
)
