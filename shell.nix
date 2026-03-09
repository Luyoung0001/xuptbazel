{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    bazel_7
    gcc
    stdenv.cc.cc.lib
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH
    echo "Bazel learning environment loaded!"
    echo "Bazel version: $(bazel version 2>&1 | head -n1)"
  '';
}
