load("@rules_python//python:defs.bzl", "py_binary", "py_library")

py_library(
    name = "helper",
    srcs = ["helper.py"],
)

py_binary(
    name = "main",
    srcs = ["main.py"],
    deps = [":helper"],
)
