#!/bin/sh

CLOSURE_DIR="/usr/local/closure_compiler"
mkdir -p ${CLOSURE_DIR}
cd ${CLOSURE_DIR}
dnf install -y java-9-openjdk
wget "https://dl.google.com/closure-compiler/compiler-latest.tar.gz"
tar -xf compiler-latest.tar.gz
rm compiler-latest.tar.gz README.md COPYING
mv closure-compiler* compiler.jar
chmod 755 compiler.jar

