load("@rules_cc//cc:defs.bzl", "cc_library", "cc_test")

cc_library(
    name = "calculator",
    srcs = ["calculator.cc"],
    hdrs = ["calculator.h"],
)

cc_test(
    name = "basic_test",
    srcs = ["basic_test.cc"],
    deps = [":calculator"],
    tags = ["unit", "fast"],
)

cc_test(
    name = "edge_case_test",
    srcs = ["edge_case_test.cc"],
    deps = [":calculator"],
    tags = ["unit", "edge"],
)
