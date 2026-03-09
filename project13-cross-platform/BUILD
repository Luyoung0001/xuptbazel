load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "main",
    srcs = ["main.cc"] + select({
        "@platforms//os:linux": ["platform_linux.cc"],
        "@platforms//os:macos": ["platform_macos.cc"],
    }),
)
