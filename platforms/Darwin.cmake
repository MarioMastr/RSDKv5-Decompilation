project(RetroEngine)

add_executable(RetroEngine MACOSX_BUNDLE ${RETRO_FILES} ${CMAKE_SOURCE_DIR}/dependencies/mac/cocoaHelpers.mm)

set(RETRO_SUBSYSTEM "SDL2" CACHE STRING "The subsystem to use")

set(DEP_PATH mac)

message(NOTICE "configuring for the " ${RETRO_SUBSYSTEM} " subsystem")

find_package(Ogg CONFIG)

if(NOT ${Ogg_FOUND})
    message(FATAL_ERROR "libogg not found, please install libogg from homebrew before continuing")
else()
    message("found libogg")
    add_library(libogg ALIAS Ogg::ogg)
    target_link_libraries(RetroEngine libogg)
endif()

find_package(boost_filesystem CONFIG)

if(NOT ${boost_filesystem_FOUND})
    message(FATAL_ERROR "boost not found, please install boost from homebrew before continuing")
else()
    message("found boost")
    add_library(libboost ALIAS Boost::filesystem)
    target_link_libraries(RetroEngine libboost)
endif()

target_link_libraries(RetroEngine "/Users/ashrafmohamed/Library/Frameworks/SDL2.framework" "-framework AppKit" "/opt/homebrew/lib/libtheora.dylib")