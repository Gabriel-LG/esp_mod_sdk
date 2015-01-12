#
# Copyright (c) 2015, Lambertus Gorter <l.gorter@gmail.com>
# All rights reserved.
#
# This makefile is to be invoked by a project makefile.
#


$(if $(PROJECT_PATH),,$(error PROJECT_PATH variable not set))
include $(PROJECT_PATH)/host.mk
include $(PROJECT_PATH)/project.mk
$(if $(BUILD_TYPE),,$(error BUILD_TYPE variable not set))


#initialize internal variables
BUILD_PATH  := $(PROJECT_PATH)/build/$(BUILD_TYPE)
ELF         := $(BUILD_PATH)/$(BUILD_TYPE).elf
STAGE1_IMG  := $(BUILD_PATH)/$(BUILD_TYPE)_stage1.bin
STAGE2_IMG  := $(BUILD_PATH)/$(BUILD_TYPE)_stage2.bin

#The complete list of modules, used by the project.
MODULES      := $(addprefix $(PROJECT_PATH)/,$(PROJECT_MODULES)) $(abspath $(SDK_MODULES)) $(OTHER_MODULES)

#The LIBS, LIBDIR and INCDIR are initialized here and filled by the modules.
LIBS        := gcc
INCDIR      :=
LIBDIR      :=

# Have each module append to the LIBS, LIBDIR and INCDIR lists.
include $(addsuffix /module.mk, $(MODULES))

#Add LDFLAGS/CFLAGS essential to generate viable code (TODO find and move any non-essential flags to project config)
CFLAGS    += -Wl,-EL -fno-inline-functions -nostdlib -mlongcalls -mtext-section-literals  -D__ets__ -DICACHE_FLASH
LDFLAGS   += -nostdlib -Wl,--no-check-sections -u call_user_start -Wl,-static
#Generate dependency files
CFLAGS    += -MMD

#Expand CFLAGS with include paths
CFLAGS += $(addprefix -L,$(LIBDIR))
CFLAGS += $(addprefix -I,$(INCDIR))

#Expand LDFLAGS with Libraries and library paths
LDFLAGS += $(addprefix -L,$(LIBDIR))
LDFLAGS += -Wl,--start-group $(addprefix -l,$(LIBS)) -Wl,--end-group

#export the variables used when building the modules
export CC LD AR 
export CFLAGS LDFLAGS
export BUILD_PATH


.PHONY: all upload clean $(MODULES)

all: $(STAGE1_IMG) $(STAGE2_IMG)

flash: $(STAGE1_IMG) $(STAGE2_IMG)
	$(ESP_TOOL) --port $(ESP_PORT) write_flash 0x00000 $(STAGE1_IMG) 0x40000 $(STAGE2_IMG)

$(STAGE1_IMG): $(ELF)
	$(FW_TOOL) -eo $< -bo $@ -bs .text -bs .data -bs .rodata -bc -ec

$(STAGE2_IMG): $(ELF)
	$(FW_TOOL) -eo $< -es .irom0.text $@ -ec

$(ELF): $(BUILD_PATH)/build
	@mkdir -p $(dir $@)
	$(LD) $(LDFLAGS) -o $@

#$(BUILD_PATH)/build build is touched by target MODULES as side effect, whenever a module gets rebuilt.
$(BUILD_PATH)/build: $(MODULES)
	@true #dummy rule to make sure $(BUILD_PATH)/build is evaluated.

$(MODULES):
	@mkdir -p $(BUILD_PATH)
	@touch -a $(BUILD_PATH)/build #create file if it does not exists
	@$(MAKE) -q -C $@ -f makefile.mk module || ( $(MAKE) -C $@ -f makefile.mk module && touch $(BUILD_PATH)/build)
	 

clean:
	rm -rf $(BUILD_PATH)

distclean:
	rm -rf $(PROJECT_PATH)/build
	rm $(PROJECT_PATH)/host.mk


