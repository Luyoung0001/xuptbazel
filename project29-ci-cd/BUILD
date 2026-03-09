load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library", "cc_test")

cc_library(
    name = "add_lib",
    srcs = ["add.cc"],
    hdrs = ["add.h"],
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [":add_lib"],
)

cc_test(
    name = "main_test",
    srcs = ["main_test.cc"],
    deps = [":add_lib"],
)
