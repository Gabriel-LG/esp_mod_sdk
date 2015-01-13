#
# Copyright (c) 2015, Lambertus Gorter <l.gorter@gmail.com>
# All rights reserved.
#
# The configuration of the build system.
# host.mk contains configuration items specific the build system and should be ignored by the version control system.
# host.default.mk is a default that is used to create host.mk if that file is missing.
#

SDK_PATH      := ../..

CC            := xtensa-lx106-elf-gcc
LD            := xtensa-lx106-elf-gcc
AR            := xtensa-lx106-elf-ar

FW_TOOL       := esptool
ESP_TOOL      := esptool.py
ESP_PORT      := /dev/ttyUSB0
