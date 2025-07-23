cmake_minimum_required(VERSION 3.7)

project(RetroEngine)

set(DECOMP_VERSION 1.1.0-a)

set(RETRO_REVISION 3 CACHE STRING "What revision to compile for. Defaults to v5U = 3")
option(RETRO_DISABLE_PLUS "Disable plus. Should be set on for any public releases." OFF)

option(RETRO_MOD_LOADER "Enables or disables the mod loader." ON)
set(RETRO_MOD_LOADER_VER 2 CACHE STRING "Sets the mod loader version. Defaults to latest")

option(RETRO_DISABLE_LOG "Disables the log. Defaults to OFF." OFF)

set(RETRO_NAME "RSDKv5")

if(RETRO_REVISION STREQUAL "3")
    set(RETRO_NAME "RSDKv5U")
endif()

set(RETRO_OUTPUT_NAME ${RETRO_NAME} CACHE STRING "The exported name of the executable.")

set(RETRO_FILES
    RSDKv5/main.cpp
    RSDKv5/RSDK/Core/RetroEngine.cpp
    RSDKv5/RSDK/Core/Math.cpp
    RSDKv5/RSDK/Core/Reader.cpp
    RSDKv5/RSDK/Core/Link.cpp
    RSDKv5/RSDK/Core/ModAPI.cpp
    RSDKv5/RSDK/Dev/Debug.cpp
    RSDKv5/RSDK/Storage/Storage.cpp
    RSDKv5/RSDK/Storage/Text.cpp
    RSDKv5/RSDK/Graphics/Drawing.cpp
    RSDKv5/RSDK/Graphics/Scene3D.cpp
    RSDKv5/RSDK/Graphics/Animation.cpp
    RSDKv5/RSDK/Graphics/Sprite.cpp
    RSDKv5/RSDK/Graphics/Palette.cpp
    RSDKv5/RSDK/Graphics/Video.cpp
    RSDKv5/RSDK/Audio/Audio.cpp
    RSDKv5/RSDK/Input/Input.cpp
    RSDKv5/RSDK/Scene/Scene.cpp
    RSDKv5/RSDK/Scene/Collision.cpp
    RSDKv5/RSDK/Scene/Object.cpp
    RSDKv5/RSDK/Scene/Objects/DefaultObject.cpp
    RSDKv5/RSDK/Scene/Objects/DevOutput.cpp
    RSDKv5/RSDK/User/Core/UserAchievements.cpp
    RSDKv5/RSDK/User/Core/UserCore.cpp
    RSDKv5/RSDK/User/Core/UserLeaderboards.cpp
    RSDKv5/RSDK/User/Core/UserPresence.cpp
    RSDKv5/RSDK/User/Core/UserStats.cpp
    RSDKv5/RSDK/User/Core/UserStorage.cpp
    dependencies/all/tinyxml2/tinyxml2.cpp
    dependencies/all/iniparser/iniparser.cpp
    dependencies/all/iniparser/dictionary.cpp
    dependencies/all/miniz/miniz.c
)

if(NOT PLATFORM)
    if(WIN32) # THIS ASSUMES VCPKG OR SOURCES !!!!!!!
        set(PLATFORM "Windows" CACHE STRING "The platform to compile for.")
    elseif(ANDROID)
        set(PLATFORM "Android" CACHE STRING "The platform to compile for.")
    else()
        set(PLATFORM ${CMAKE_SYSTEM_NAME} CACHE STRING "The platform to compile for.")
    endif()
endif()

include(platforms/${PLATFORM}.cmake)

# Set C++ standard after including the platform file since they could override mod loader support
# which relies on C++17. Otherwise the engine is mostly C++11.
if(RETRO_MOD_LOADER)
    set_target_properties(RetroEngine PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED ON)
else()
    set_target_properties(RetroEngine PROPERTIES CXX_STANDARD 11 CXX_STANDARD_REQUIRED ON)
endif()

set_target_properties(RetroEngine PROPERTIES OUTPUT_NAME ${RETRO_OUTPUT_NAME})

include(FetchContent)

set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

FetchContent_Declare(
    libogg
    GIT_REPOSITORY https://gitlab.xiph.org/xiph/ogg.git
    GIT_TAG v1.3.6 # new version!!!!!!!!!!!!!!!
)
FetchContent_MakeAvailable(libogg)

FetchContent_Declare(
    libtheora
    GIT_REPOSITORY https://gitlab.xiph.org/xiph/theora.git
    GIT_TAG v1.2.0
)
FetchContent_MakeAvailable(libtheora)

file(GLOB THEORA_SOURCES "${libtheora_SOURCE_DIR}/lib/*.c")

add_library(libtheora STATIC ${THEORA_SOURCES})
set_target_properties(libtheora
    PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${libtheora_SOURCE_DIR}/include"
    ARCHIVE_OUTPUT_DIRECTORY "${libtheora_BUILD_DIR}"
    PREFIX ""
)
target_include_directories(libtheora PRIVATE ${libtheora_SOURCE_DIR}/include ${libogg_SOURCE_DIR}/include)

if (RETRO_SUBSYSTEM STREQUAL "SDL2")
    FetchContent_Declare(
        SDL2
        GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
        GIT_TAG release-2.32.8
        PATCH_COMMAND git apply ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/mac/SDL2_cocoawindow.patch # displayp3
    )
    FetchContent_MakeAvailable(SDL2)
    
    add_dependencies(RetroEngine SDL2::SDL2-static)
    target_link_libraries(RetroEngine SDL2::SDL2-static)
endif()

if (RETRO_SUBSYSTEM STREQUAL "SDL3")
    FetchContent_Declare(
        SDL3
        GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
        GIT_TAG release-3.2.18
        PATCH_COMMAND git apply ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/mac/SDL3_cocoawindow.patch # displayp3
    )
    FetchContent_MakeAvailable(SDL3)
    
    add_dependencies(RetroEngine SDL3::SDL3-static)
    target_link_libraries(RetroEngine SDL3::SDL3-static)
endif()

if(RETRO_SUBSYSTEM STREQUAL "OGL")
    FetchContent_Declare(GLFW
        GIT_REPOSITORY https://github.com/glfw/glfw.git
        GIT_TAG 3.4
    )
    FetchContent_MakeAvailable(GLFW)
    target_link_libraries(RetroEngine glfw)

    FetchContent_Declare(GLEW
        GIT_REPOSITORY https://github.com/Perlmint/glew-cmake.git
        GIT_TAG "glew-cmake-2.2.0"
    )
    FetchContent_MakeAvailable(GLEW)
    target_link_libraries(RetroEngine libglew_static)
endif()

add_dependencies(RetroEngine Ogg::ogg libtheora)
target_link_libraries(RetroEngine Ogg::ogg libtheora)

target_include_directories(RetroEngine PRIVATE
    RSDKv5/
    dependencies/all/
    dependencies/all/tinyxml2/
    dependencies/all/iniparser/
)

if(DEFINED DEP_PATH)
    target_include_directories(RetroEngine PRIVATE
        dependencies/${DEP_PATH}/
    )
endif()

if(NOT DEFINED GAME_STATIC)
    set(GAME_STATIC OFF)
endif()

target_compile_definitions(RetroEngine PRIVATE
    RETRO_REVISION=${RETRO_REVISION}
    RSDK_USE_${RETRO_SUBSYSTEM}=1
    
    RETRO_USE_MOD_LOADER=$<BOOL:${RETRO_MOD_LOADER}>
    RETRO_MOD_LOADER_VER=${RETRO_MOD_LOADER_VER}

    RETRO_STANDALONE=$<NOT:$<BOOL:${GAME_STATIC}>>
    
    RSDK_AUTOBUILD=$<BOOL:${RETRO_DISABLE_PLUS}>
    RETRO_DISABLE_LOG=$<BOOL:${RETRO_DISABLE_LOG}>
    
    RETRO_DEV_EXTRA="${PLATFORM} - ${RETRO_SUBSYSTEM} - ${CMAKE_CXX_COMPILER_ID}"
    DECOMP_VERSION="${DECOMP_VERSION}"
)

if(WITH_RSDK)
    if(NOT GAME_STATIC)
        add_custom_command(TARGET RetroEngine POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:${GAME_NAME}>
            $<TARGET_FILE_DIR:RetroEngine>)
    endif()

    target_compile_definitions(${GAME_NAME} PRIVATE
        RETRO_REVISION=${RETRO_REVISION}

        RETRO_USE_MOD_LOADER=$<BOOL:${RETRO_MOD_LOADER}>
        RETRO_MOD_LOADER_VER=${RETRO_MOD_LOADER_VER}
    
        GAME_INCLUDE_EDITOR=$<BOOL:${GAME_INCLUDE_EDITOR}>

        MANIA_PREPLUS=$<BOOL:${MANIA_PREPLUS}>
        MANIA_FIRST_RELEASE=$<BOOL:${MANIA_FIRST_RELEASE}>
        GAME_VERSION=${GAME_VERSION}
    )
endif()