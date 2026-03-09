load("@rules_cc//cc:defs.bzl", "cc_binary")
load(":packaging.bzl", "tar_package", "zip_package")

cc_binary(
    name = "app",
    srcs = ["app.cc"],
)

tar_package(
    name = "app_tar",
    srcs = [
        ":app",
        "config.txt",
        "README.txt",
    ],
)

zip_package(
    name = "app_zip",
    srcs = [
        ":app",
        "config.txt",
        "README.txt",
    ],
)
