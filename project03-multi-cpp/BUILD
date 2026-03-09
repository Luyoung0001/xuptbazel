load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

cc_library(
    name = "utils",
    srcs = ["utils.cc"],
    hdrs = ["utils.h"],
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [":utils"],
)
