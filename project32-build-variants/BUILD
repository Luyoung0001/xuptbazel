load("@rules_cc//cc:defs.bzl", "cc_binary")

config_setting(
    name = "debug_mode",
    values = {"compilation_mode": "dbg"},
)

config_setting(
    name = "opt_mode",
    values = {"compilation_mode": "opt"},
)

cc_binary(
    name = "app",
    srcs = ["main.cc"],
    copts = select({
        ":debug_mode": ["-DDEBUG", "-g", "-O0"],
        ":opt_mode": ["-O3", "-DNDEBUG"],
        "//conditions:default": ["-O2"],
    }),
)
