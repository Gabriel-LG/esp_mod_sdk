#
# Copyright (c) 2015, Lambertus Gorter <l.gorter@gmail.com>
# All rights reserved.
#

## Boilerplate to determine module path, name and build path
MODULE_PATH       := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
MODULE_NAME       := $(notdir $(patsubst %/,%,$(MODULE_PATH)))
$(if $(BUILD_PATH),,$(error BUILD_PATH not set))
MODULE_BUILD_PATH := $(BUILD_PATH)/$(MODULE_NAME)
## Boilerplate end


# Append linker script to LDFLAGS
LDFLAGS += -T$(MODULE_PATH)/ld/eagle.app.v6.ld
LIBDIR  +=  $(MODULE_PATH)/ld
