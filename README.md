The esp_mod_sdk
===============
The esp_mod_sdk is a modified and modular SDK for the ESP8266. While it provides the same static libraries and headers as the official ESP8266 SDK, the build system is completely rewritten. It offers a number of advantages over the official SDK:

* Projects are modular. Modules can easely be exchanged between projects. 
* The SDK is separated from the projects. This makes it easier to upgrade the SDK.
* Automatic build dependencies make sure that all affected sources are rebuild after changing a source/header file.
* Out of source builds allow for multiple build-types simultaniousely (e.g. debug and release builds)
* Makefiles are much simpler whilst offering more functionality
* Make target for flashing the ESP8266

Goals
-----
The goal of the esp_mod_sdk is to provide an easy to use, lightweight SDK. Providing the possibility to easily exchange funtionality between projects.

Setting up the build system
---------------------------
Follow the instructions for setting up the toolchain from the [esp8266 github wiki](https://github.com/esp8266/esp8266-wiki/wiki/Toolchain). The paragraphs _"Setting up the Espressif SDK"_ and _"Installing Xtensa libraries and headers"_ may be ignored.  
The esp_mod_sdk projects assume that the toolchain binaries, the esp image tool and the esp upload tool are in your system `PATH`. It also assumes `/dev/ttyUSB0` to be the serialport used for uploading. If this is not the case, then copy `host.default.mk` in the project directory to `host.mk` and edit `host.mk`. **Do not edit `host.default.mk`**. 


Using an esp_mod_sdk project
----------------------------
An esp_mod_sdk project can be built by calling `make` from the project directory.  
By setting the `BUILD_TYPE` environment variable, you can specify build type (usually `debug` and `release` are available, while `debug` is the default build type. However the available build types are up to the project).
~~~
[BUILD_TYPE=<build_type>] make [target]
~~~
An esp_mod_sdk project provides the following build targets:
* `all` build the firmware
* `flash` flash the built firmware into the ESP8266
* `clean` clean up the build results (for the specified build type)
* `distclean` clean the project for distribution (removes all build results and `host.mk`)
The build results are stored in the project directory under `build/$(BUILD_TYPE)`


Project structure
-----------------
A project must contain the following files:
* `Makefile` the top level makefile. **This file must not be modified**.
* `project.mk` the project definition.
* `host.default.mk` the default description of the host build system. I specifies where the esp_mod_sdk, the toolchain and the esp tools are located.  
`host.default.mk` is copied to `host.mk`, if `host.mk` is missing.

Projects usually come with one or more modules. These modules are located in the project subdirectories.

### project.mk
`project.mk` will provide the following variables to let the esp_mod_sdk know what to build and how to build it.

* `BUILD_TYPE` must be conditionally assigned to the default build type (usually `debug`).
* `PROJECT_MODULES` modules to be used, provided by the project. This must be a list of module names/paths relative to the project directory.
* `SDK_MODULES`  modules to be used, provided by the esp_mod_sdk. This must be a list of module names/paths relative to the esp_mod_sdk directory.
* `OTHER_MODULES` modules to use from other locations. This must be a list of absolute module paths.
* `ifeq`/`else ifeq` sequence defining the supported `BUILD_TYPE` values and the associated variable values.
* `CCFLAGS` a set of (non-essential) compiler options (all essential options are appended by the SDK/modules)
* `LDFLAGS` a set of (non-essential) linker options (all essential options are appended by the SDK/modules)

Modules
-------
A module delivers one or more static libraries to a project, along with the associated include directories. The include directories are used by the compiler to search for headers included by other modules. The static libraries are linked together to create the firmware images.  
A module must contain the following files:

* `module.mk` specifies which libraries are provided by the module. It also specifies where the libraries and include directories are located.  
libraries are **appended** to the `LIBS` variable, the library directory is **appended** to the `LIBDIR` variable and the include directories are **appended** to the `INCDIR` variable. **The directories must be absolute paths**  
Modules may also provide extra compiler or linker flags by **appending** them to the `CFLAGS` and `LDFLAGS` variables. Note that the `CFLAGS`/`LDFLAGS` will be used for every module to be built, so use with care.  
The boilerplate section should be left unmodified!
* `makefile.mk` contains the build instructions for the module.  
Some significant variables that are exported by the build system (or included from `module.mk`):
    * `MODULE_NAME` the name of the module
    * `MODULE_BUILD_PATH` the directory where the build output for the module must go.
    * `LIBDIR` the output directory for the built libraries (must the same as or subdir of `MODULE_BUILD_PATH`)

The buid target `module` must be provided, as this target will be build by the esp_mod_sdk. **A module may not generate any output MODULE_BUILD_PATH.**  
Each module is built from a separate make process, so any variables that are modified here do not affect other modules.  
For every `.o` (object) file that is built, a `.d` (dependency) file is generated; the dependency files must be included by `makefile.mk` to ensure automatic rebuilds whenever a resource is edited.  
By convention each module should build a single static library `lib$(MODULE_NAME).a` from source.

Remarks
-------
* Perform a clean build after editing a `.mk` file, as the esp_mod_sdk does not automatically rebuild affected modules.
* The `project.mk` file must specify all modules that are to be used, including the dependencies of the used modules.
* The verbosity of the make script will be tuned down in a future release ;)
* The `espressif` module will be split up into multiple modules future releases.
* More modules will be added to the SDK in future releases. (e.g. device drivers, FreeRTOS, webserver(s), etc)
* When a new Espressif SDK is released, the esp_mod_sdk will be updated accordingly.
* Building of cloud-update firmware is not supported (yet).
* The esp_mod_sdk has only been tested under linux so far
* The esp_mod_sdk has only been tested with the gcc toolchain so far (xcc is expected to work)

