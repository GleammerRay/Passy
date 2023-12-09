#! /bin/bash
cd /Passy

echo "===================================================="
echo "Install dependencies"
echo "===================================================="

apt-get update
apt-get -y install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev binutils coreutils desktop-file-utils fakeroot fuse libgdk-pixbuf2.0-dev patchelf python3-pip python3-setuptools squashfs-tools strace util-linux zsync git file unzip zip wget curl

echo "===================================================="
echo "Install dart"
echo "===================================================="

mkdir submodules/flutter/bin/cache
export LAST_PWD=$PWD
cd submodules/flutter/bin/cache
wget https://storage.googleapis.com/dart-archive/channels/stable/release/3.1.0/sdk/dartsdk-linux-arm-release.zip
unzip dartsdk-linux-arm-release.zip
rm dartsdk-linux-arm-release.zip
cd $LAST_PWD

echo "===================================================="
echo "Install flutter"
echo "===================================================="

submodules/flutter/bin/flutter doctor
export PATH="$PATH:$PWD/submodules/flutter/bin"

echo "===================================================="
echo "Configure flutter"
echo "===================================================="

flutter config --no-analytics

echo "===================================================="
echo "Build with updates popup"
echo "===================================================="

bash build_all_with_updates_popup.sh

echo "===================================================="
echo "Prepare releases"
echo "===================================================="

cd /passy-build
mkdir -p linux-bundle/Passy
cp -r /Passy/build/linux/x64/release/bundle/. linux-bundle/Passy
cp /Passy/build/appimage/Passy-Latest-x86_64.AppImage .
chmod +x linux-bundle/Passy/passy
chmod +x Passy-Latest-x86_64.AppImage
