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



# Append libraries built by this module to LIBS
LIBS    += json lwip main net80211 phy pp ssl upgrade wpa
# Append the library paths to LIBDIR
LIBDIR  += $(MODULE_PATH)/lib
# Append the include paths to INCDIR
INCDIR  += $(MODULE_PATH)/include $(MODULE_PATH)/include/json
