# Spicy needs the full prefix for Flex and Bison while Zeek captures only the
# paths to the executables. Derive the prefixes from the binary paths under the
# assumption that their bindir is under their prefix (which also implies that
# one such prefix even exists).
if ( NOT FLEX_EXECUTABLE )
   find_package(FLEX REQUIRED)
endif ()
get_filename_component(dir ${FLEX_EXECUTABLE} DIRECTORY ABSOLUTE)
set(FLEX_ROOT ${dir}/..)

if ( NOT BISON_EXECUTABLE )
   find_package(BISON REQUIRED)
endif ()
get_filename_component(dir ${BISON_EXECUTABLE} DIRECTORY ABSOLUTE)
set(BISON_ROOT ${dir}/..)

if ( NOT BINARY_PACKAGING_MODE )
   # TODO: Broker seems to always turn on static libraries. We don't want that for Spicy by default.
   set(BUILD_SHARED_LIBS yes)
endif ()

# Spicy uses slightly less strict warnings than Zeek proper. Mute a few warnings for Spicy.
# NOTE: Compiler flags are inherited down the directory tree, so in order to
# set these flags we do need a customizable subdirectory above the Spicy
# sources.
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-missing-braces")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-vla")

# The script generating precompiled headers for Spicy expects a different build
# system layout than provided for a bundled Spicy, disable it.
set(HILTI_DEV_PRECOMPILE_HEADERS OFF)

add_subdirectory(spicy)

# Disable Spicy unit test targets.
#
# Spicy builds its unit tests as part of `ALL`. They are usually not only
# uninteresting for us but might cause problems. Since any configuration
# we do for our unit tests happens through global C++ compiler flags, they
# would get inherited directly by Spicy which can cause issues, e.g., we set
# `-DDOCTEST_CONFIG_DISABLE` if `ENABLE_ZEEK_UNIT_TESTS` is false, but Spicy
# unit test do not anticipate this define being set.
set_target_properties(
   hilti-rt-tests
   hilti-rt-configuration-tests
   spicy-rt-tests
   hilti-toolchain-tests
   spicy-toolchain-tests
   PROPERTIES EXCLUDE_FROM_ALL TRUE)
