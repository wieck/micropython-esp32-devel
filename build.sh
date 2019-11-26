#!/bin/sh

# ----
# This shell script will build the Docker image esp32-devel assuming
# that the directory $HOME/esp32-devel contains the esp-idf (git repo)
# and the xtensa-esp32-elf extract. If you installed those components
# in different locations, the resulting container will no work.
# ----

ESP32_DEVEL=$HOME/esp32-devel
GID_DIALOUT=`awk -F ':' '$1=="dialout" {print $3}' </etc/group`

docker build -t esp32-devel \
	--build-arg USER=$USER \
	--build-arg UID=$UID \
	--build-arg GID_DIALOUT=$GID_DIALOUT \
	--build-arg HOME=$HOME \
	--build-arg ESPIDF=$ESP32_DEVEL/esp-idf \
	--build-arg XTENSA_ESP32_ELF=$ESP32_DEVEL/xtensa-esp32-elf \
	.
