load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

cc_library(
    name = "calculator",
    srcs = ["calculator.cc"],
    hdrs = ["calculator.h"],
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [":calculator"],
)
