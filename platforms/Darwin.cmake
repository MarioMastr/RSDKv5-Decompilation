project(RetroEngine)

set(RENDERER_FILES
    RSDKv5/RSDK/Graphics/SDL2/SDL2RenderDevice.cpp
    RSDKv5/RSDK/Audio/SDL2/SDL2AudioDevice.cpp
    RSDKv5/RSDK/Input/SDL2/SDL2InputDevice.cpp
    RSDKv5/RSDK/Input/Keyboard/KBInputDevice.cpp
)

add_executable(RetroEngine ${RETRO_FILES} ${RENDERER_FILES} ${LEGACY_RETRO_FILES} dependencies/mac/cocoaHelpers.mm)

set(RETRO_SUBSYSTEM "SDL2" CACHE STRING "The subsystem to use")

set(DEP_PATH mac)

message(NOTICE "configuring for the " ${RETRO_SUBSYSTEM} " subsystem")

find_package(Ogg CONFIG)
if(NOT ${Ogg_FOUND})
    message(NOTICE "libogg not found, install libogg from homebrew")
else()
    message("found libogg")
    target_link_libraries(RetroEngine ${OGG_INCLUDE_DIR}/../lib/libogg.a)
endif()

include(FindBoost)
set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_RUNTIME OFF)
find_package(Boost COMPONENTS filesystem REQUIRED)
if(NOT ${Boost_FOUND})
    message(NOTICE "boost not found, install libogg from homebrew")
else()
    message("found libogg")
    add_library(libboost ALIAS Boost::filesystem)
    target_link_libraries(RetroEngine libboost)
endif()

find_package(SDL2 CONFIG)
if(NOT ${SDL2_FOUND})
    message(NOTICE "sdl2 not found, install sdl2 from homebrew")
else()
    message("found sdl2")
    add_library(libSDL2 ALIAS SDL2::SDL2-static)
    target_link_libraries(RetroEngine libSDL2)
endif()

find_package(PkgConfig)
pkg_check_modules(THEORA REQUIRED theora)
if(NOT ${THEORA_FOUND})
    message(NOTICE "theora not found, install theora from homebrew")
else()
    message("found theora")
    pkg_get_variable(THEORA_LIBRARY_DIRS theora libdir)
    target_link_libraries(RetroEngine ${THEORA_LIBRARY_DIRS}/libtheora.a)
endif()

target_link_libraries(RetroEngine "-framework AppKit")
