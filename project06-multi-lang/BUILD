load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@rules_python//python:defs.bzl", "py_binary")

cc_binary(
    name = "greeter_cpp",
    srcs = ["greeter.cc"],
)

py_binary(
    name = "greeter_py",
    srcs = ["greeter.py"],
    main = "greeter.py",
)
