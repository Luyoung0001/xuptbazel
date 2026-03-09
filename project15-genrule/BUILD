load("@rules_cc//cc:defs.bzl", "cc_binary")

genrule(
    name = "gen_version",
    srcs = ["template.txt"],
    outs = ["version.h"],
    cmd = "echo '#define VERSION \"1.0.0\"' > $(OUTS)",
)

cc_binary(
    name = "main",
    srcs = ["main.cc", ":gen_version"],
)
