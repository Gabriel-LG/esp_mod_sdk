#
# Copyright (c) 2015, Lambertus Gorter <l.gorter@gmail.com>
# All rights reserved.
#


#create from host.mk from host.default.mk if it does not exist
ifeq ($(wildcard host.mk),)
CREATE_CFG := $(shell cp host.default.mk host.mk)
endif 

include  host.mk

# The variable PROJECT_PATH is used by the SDK makefile to locate the project and its build location.
# It must be an absolute path.
export PROJECT_PATH := $(abspath .)


.PHONY: $(MAKEGOALS) distclean

ifdef MAKECMDGOALS
$(MAKECMDGOALS):
	$(MAKE) -C $(SDK_PATH) -f makefile.mk $@
else
all:
	$(MAKE) -C $(SDK_PATH) -f makefile.mk
endif


