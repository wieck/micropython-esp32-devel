#!/bin/sh

# ----
# This script creates the $HOME/esp32-devel directory expected by
# build.sh.
# ----

mkdir $HOME/esp32-devel || exit 1
cd $HOME/esp32-devel || exit 1

wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz
tar xzf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

git clone --recursive https://github.com/espressif/esp-idf.git
cd esp-idf
git submodule update --init
cd ..

