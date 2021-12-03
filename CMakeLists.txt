cmake_minimum_required(VERSION 3.17)
set(PROJ_NAME Cork)
project(${PROJ_NAME})

list (APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/)

# -- Configuration

set(CMAKE_CONFIGURATION_TYPES "Debug;Release;RelWithDebInfo" CACHE STRING "Configs" FORCE)
if(DEFINED CMAKE_BUILD_TYPE AND CMAKE_VERSION VERSION_GREATER "2.8")
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${CMAKE_CONFIGURATION_TYPES})
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)

set(EXECUTABLE_OUTPUT_PATH  ${PROJECT_BINARY_DIR}/bin )
set(LIBRARY_OUTPUT_PATH     ${PROJECT_BINARY_DIR}/lib CACHE PATH "" FORCE)

option(CORK_BUILD_EXECUTABLE "Build cork executable sample" OFF)
option(CORK_BUILD_OFF2OBJ "Build OFF to OBJ file format conversion tool" OFF)

# -- Required dependencies

if (NOT GMP_FOUND)
    find_package(GMP REQUIRED)
endif (NOT GMP_FOUND)

# -- Sources and headers

set(SRC_FILES
    src/cork.cpp
    src/isct/empty3d.cpp
    src/isct/quantization.cpp
    src/isct/triangle.c
    src/util/log.cpp
    src/util/timer.cpp
)

set(INCLUDE_DIRS
    src/
    src/accel/
    src/isct/
    src/math/
    src/mesh/
    src/rawmesh/
    src/util/
)

# -- Target definitions

add_library(libcork SHARED ${SRC_FILES} src/cork.h src/export.h)

set_target_properties(libcork PROPERTIES CXX_STANDARD 11)
set_target_properties(libcork PROPERTIES CXX_STANDARD_REQUIRED ON)

set(ALL_BUILD_INCLUDE_DIRS)
foreach(_include_dir IN LISTS INCLUDE_DIRS)
   list(APPEND ALL_BUILD_INCLUDE_DIRS $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${_include_dir}>)
endforeach()

target_include_directories(libcork PUBLIC ${GMP_INCLUDE_DIRS} ${ALL_BUILD_INCLUDE_DIRS} $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

target_compile_definitions(libcork PRIVATE -DNO_TIMER -DREDUCED -DTRILIBRARY -DANSI_DECLARATORS)

if(UNIX)
    target_compile_options(libcork PRIVATE -fPIC -fvisibility=hidden)
endif()

target_link_libraries(libcork PUBLIC ${GMP_LIBRARIES})

# --

if (CORK_BUILD_EXECUTABLE)

    set(SRC_CORK_BIN_FILES
        src/main.cpp
        src/file_formats/files.cpp
        src/file_formats/ifs.cpp
        src/file_formats/off.cpp
    )

    set(INCLUDE_CORK_BIN_DIRS
        src/file_formats/
    )

    add_executable(cork-bin ${SRC_CORK_BIN_FILES})
    set_target_properties(cork-bin PROPERTIES CXX_STANDARD 11)
    set_target_properties(cork-bin PROPERTIES CXX_STANDARD_REQUIRED ON)
    set_target_properties(cork-bin PROPERTIES OUTPUT_NAME cork)

    target_include_directories(cork-bin PRIVATE ${INCLUDE_CORK_BIN_DIRS})
    target_link_libraries(cork-bin PRIVATE libcork)
endif()

if (CORK_BUILD_OFF2OBJ)
    add_executable(off2obj src/off2obj.cpp)
    set_target_properties(off2obj PROPERTIES CXX_STANDARD 11)
    set_target_properties(off2obj PROPERTIES CXX_STANDARD_REQUIRED ON)
    set_target_properties(off2obj PROPERTIES OUTPUT_NAME off2obj)
    target_link_libraries(off2obj)
endif()

# -- Export

install(TARGETS libcork
    EXPORT cork_EXPORT
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
install(FILES src/cork.h DESTINATION include)

# We export the targets first
install(EXPORT cork_EXPORT DESTINATION cmake NAMESPACE ${PROJ_NAME}:: FILE ${PROJ_NAME}Targets.cmake)

# We create a config file that makes use of the exported targets
configure_file(${PROJ_NAME}Config.cmake.in ${PROJ_NAME}Config.cmake @ONLY)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJ_NAME}Config.cmake DESTINATION cmake)
install(FILES cmake/FindGMP.cmake DESTINATION cmake/)