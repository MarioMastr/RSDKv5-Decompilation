project(RetroEngine)

set(MACOSX_BUNDLE_ICON_FILE ${RETRO_NAME}.icns)
set(RETRO_ICON ${CMAKE_CURRENT_SOURCE_DIR}/${RETRO_NAME}/${RETRO_NAME}.icns)
set_source_files_properties(${RETRO_ICON} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

add_executable(RetroEngine MACOSX_BUNDLE ${RETRO_ICON} ${RETRO_FILES} dependencies/mac/cocoaHelpers.mm)

set(RETRO_SUBSYSTEM "SDL2" CACHE STRING "The subsystem to use")

message(NOTICE "configuring for the " ${RETRO_SUBSYSTEM} " subsystem")

target_include_directories(RetroEngine PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/mac)