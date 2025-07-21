project(RetroEngine)

add_executable(RetroEngine WIN32 ${RETRO_FILES})

set(RETRO_SUBSYSTEM "DX9" CACHE STRING "The subsystem to use")
option(USE_MINIAUDIO "Whether or not to use MiniAudio or default to XAudio." OFF)

set(DEP_PATH windows)

message(NOTICE "configuring for the " ${RETRO_SUBSYSTEM} " subsystem")

if(RETRO_SUBSYSTEM STREQUAL "DX9")
    target_link_libraries(RetroEngine
        d3d9
        d3dcompiler
        XInput
    )
elseif(RETRO_SUBSYSTEM STREQUAL "DX11")
    target_link_libraries(RetroEngine
        d3d11
        d3dcompiler
        DXGI
        XInput
    )
elseif(RETRO_SUBSYSTEM STREQUAL "OGL")
elseif(RETRO_SUBSYSTEM STREQUAL "VK")
    find_package(glfw3 CONFIG)

    if(NOT glfw3_FOUND)
        message("could not find glfw, attempting to build from source")
        add_subdirectory(dependencies/ogl/glfw)
    else()
        message("found GLFW")
    endif()

    find_package(Vulkan REQUIRED)

    target_compile_definitions(RetroEngine PRIVATE VULKAN_USE_GLFW=1)
    target_link_libraries(RetroEngine
        glfw
        Vulkan::Vulkan
    )
elseif(RETRO_SUBSYSTEM STREQUAL "SDL2")
elseif(RETRO_SUBSYSTEM STREQUAL "SDL3")
else()
    message(FATAL_ERROR "RETRO_SUBSYSTEM must be one of DX9, DX11, OGL, VK, SDL2, or SDL3")
endif()

if(USE_MINIAUDIO)
    if(RETRO_SUBSYSTEM STREQUAL "DX9" OR RETRO_SUBSYSTEM STREQUAL "DX11")
        message(FATAL_ERROR "portaudio not supported for DX9 and DX11.")
    endif()
    target_compile_definitions(RetroEngine PRIVATE RETRO_AUDIODEVICE_MINI=1)
endif()

target_compile_definitions(RetroEngine PRIVATE _CRT_SECURE_NO_WARNINGS)
target_link_libraries(RetroEngine
    winmm
    comctl32
)

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(RetroEngine PRIVATE -Wno-microsoft-cast -Wno-microsoft-exception-spec)
endif()
    
target_sources(RetroEngine PRIVATE ${RETRO_NAME}/${RETRO_NAME}.rc)