load("@rules_cc//cc:defs.bzl", "cc_binary")

platform(
    name = "linux_x86_64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
)

platform(
    name = "linux_arm64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:arm64",
    ],
)

cc_binary(
    name = "app",
    srcs = ["main.cc"],
)
