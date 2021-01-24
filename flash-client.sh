#!/usr/bin/env bash

# Send firmware .bin files over the network to a machine running the flash server.

#set -e
#set -x

host="r3"
port="4850"

HERE_PATH="$(realpath "$(dirname "$0")")"

part_src="$HERE_PATH/build/partition_table/partition-table.bin"
boot_src="$HERE_PATH/build/bootloader/bootloader.bin"
main_src="$HERE_PATH/build/reminder.bin"

part_dst="part.bin"
boot_dst="boot.bin"
main_dst="main.bin"

ram_path="/run/user/$(id -u)/esp32-flash-client"

mkdir -p "$ram_path"
cd "$ram_path" || exit

while true; do
  read -r -p "Press Enter to trigger flashing send flash files to flash-server at $host:$port... "

  cp "$part_src" "$ram_path/$part_dst"
  cp "$boot_src" "$ram_path/$boot_dst"
  cp "$main_src" "$ram_path/$main_dst"

  tar -c --xz "$part_dst" "$boot_dst" "$main_dst" | nc $host $port -N
done
