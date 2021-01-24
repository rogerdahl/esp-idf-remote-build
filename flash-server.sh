#!/usr/bin/env bash

# Receive firmware .bin files over the network and flash them to a device connected to the local
# machine.

#set -e
#set -x

port="4850"
com_dev="/dev/ttyUSB0"
com_rate="115200"
#com_rate="9600"

part="part.bin"
boot="boot.bin"
main="main.bin"

ram_path="/run/user/$(id -u)/esp32-flash-server"

mkdir -p "$ram_path"
cd "$ram_path" || exit

# I tried being clever and pipe the data directly from the server here, but esptool.py requires
# random access to the files. Instead, I store local copies of the files in the ram disk at
# /sys/user.

while true; do
  echo "Waiting for firmware files to flash..."
  nc -l "$port" | tar x --xz --overwrite
  # Command is copied from `idf.py flash`.
  esptool.py \
    --chip esp32 -p "$com_dev" -b "$com_rate" \
    --before=default_reset --after=hard_reset write_flash \
    --flash_mode dio --flash_freq 40m --flash_size 2MB \
    0x8000 "$part" 0x1000 "$boot" 0x10000 "$main"
done
