#! /bin/bash

echo "===================================================="
echo "Install dependencies"
echo "===================================================="

apt-get update
apt-get -y install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev binutils coreutils desktop-file-utils fakeroot fuse libgdk-pixbuf2.0-dev patchelf python3-pip python3-setuptools squashfs-tools strace util-linux zsync git file unzip zip wget curl libc6

echo "===================================================="
echo "Configure"
echo "===================================================="

export PATH="$PATH:$PWD/submodules/flutter/bin"
git config --global --add safe.directory /Passy
git config --global --add safe.directory /Passy/submodules/flutter
git submodule init
git submodule update

echo "===================================================="
echo "Install flutter"
echo "===================================================="

flutter doctor

echo "===================================================="
echo "Configure flutter"
echo "===================================================="

flutter config --no-analytics

echo "===================================================="
echo "Build Passy CLI"
echo "===================================================="

bash build_cli.sh

echo "===================================================="
echo "Prepare releases"
echo "===================================================="

cd /passy-build
mkdir cli
cp -r /Passy/build/cli/latest/. cli
