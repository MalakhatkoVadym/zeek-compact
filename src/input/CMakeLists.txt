
include(ZeekSubdir)

include_directories(BEFORE
                    ${CMAKE_CURRENT_SOURCE_DIR}
                    ${CMAKE_CURRENT_BINARY_DIR}
)

add_subdirectory(readers)

set(input_SRCS
    Component.cc
    Manager.cc
    ReaderBackend.cc
    ReaderFrontend.cc
)

bif_target(input.bif)

bro_add_subdir_library(input ${input_SRCS})
add_dependencies(bro_input generate_outputs)
