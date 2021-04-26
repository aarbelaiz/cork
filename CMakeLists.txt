cmake_minimum_required(VERSION 3.17)
set(PROJ_NAME cork)
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

# -- Required dependencies

IF (NOT GMP_FOUND)
    find_package(GMP REQUIRED)
ENDIF (NOT GMP_FOUND)

# -- Sources and headers

set(SRC_FILES
	src/cork.cpp
	src/file_formats/files.cpp
	src/file_formats/ifs.cpp
	src/file_formats/off.cpp
	src/isct/empty3d.cpp
	src/isct/quantization.cpp
	src/isct/triangle.c
	src/util/log.cpp
	src/util/timer.cpp
)

set(INCLUDE_DIRS
  src/accel/
  src/file_formats/
  src/isct/
  src/math/
  src/mesh/
  src/rawmesh/
  src/util/
)

# -- Target definitions

add_library(cork SHARED ${SRC_FILES} src/cork.h src/export.h)

set_target_properties(cork PROPERTIES CXX_STANDARD 11)
set_target_properties(cork PROPERTIES CXX_STANDARD_REQUIRED ON)

target_include_directories(cork PRIVATE ${INCLUDE_DIRS})
target_include_directories(cork PUBLIC ${GMP_INCLUDE_DIRS})

target_compile_definitions(cork PRIVATE -DNO_TIMER -DREDUCED -DTRILIBRARY -DANSI_DECLARATORS)
if(MSVC)
	target_compile_definitions(cork PUBLIC -D_USE_MATH_DEFINES)
elseif(UNIX)
	target_compile_options(cork PRIVATE -fPIC -fvisibility=hidden)
endif()

target_link_libraries(cork PUBLIC ${GMP_LIBRARIES})

# --

add_executable(cork-bin src/main.cpp)

set_target_properties(cork-bin PROPERTIES CXX_STANDARD 11)
set_target_properties(cork-bin PROPERTIES CXX_STANDARD_REQUIRED ON)
set_target_properties(cork-bin PROPERTIES OUTPUT_NAME cork)

target_include_directories(cork-bin PRIVATE ${INCLUDE_DIRS})

target_link_libraries(cork-bin PRIVATE cork)

# -- Export

INSTALL(TARGETS cork
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
)
INSTALL(FILES src/cork.h DESTINATION include)

