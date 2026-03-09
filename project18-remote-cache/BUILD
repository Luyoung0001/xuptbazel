load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

cc_library(
    name = "lib1",
    srcs = ["lib1.cc"],
    hdrs = ["lib1.h"],
)

cc_library(
    name = "lib2",
    srcs = ["lib2.cc"],
    hdrs = ["lib2.h"],
)

cc_library(
    name = "lib3",
    srcs = ["lib3.cc"],
    hdrs = ["lib3.h"],
)

cc_library(
    name = "lib",
    srcs = ["lib.cc"],
    hdrs = ["lib.h"],
    deps = [":lib1", ":lib2", ":lib3"],
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [":lib"],
)
