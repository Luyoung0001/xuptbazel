load("@rules_cc//cc:defs.bzl", "cc_library")

cc_library(
    name = "internal",
    srcs = ["internal.cc"],
    hdrs = ["internal.h"],
    visibility = ["//visibility:private"],
)

cc_library(
    name = "public_api",
    srcs = ["public_api.cc"],
    hdrs = ["public_api.h"],
    deps = [":internal"],
    visibility = ["//visibility:public"],
)
