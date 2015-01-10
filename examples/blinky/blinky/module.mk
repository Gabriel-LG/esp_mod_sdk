#Boilerplate to determine module path, name and build path
MODULE_PATH       := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
MODULE_NAME       := $(notdir $(patsubst %/,%,$(MODULE_PATH)))
MODULE_BUILD_PATH := $(BUILD_PATH)/$(MODULE_NAME)

#  All paths must be absolute since they may be used for building from different paths.
LIBS    += $(MODULE_NAME)
LIBDIR  += $(MODULE_BUILD_PATH)
INCDIR  += $(MODULE_PATH)

