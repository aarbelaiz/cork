# Try to find the GNU Multiple Precision Arithmetic Library (GMP)
# See http://gmplib.org/
#
# GMP_FOUND          - True if GMP/MPIR has been found
# GMP_INCLUDE_DIRS   - include search path
# GMP_LIBRARIES      - libraries to link with
# GMP_LIBRARY_DLL    - library DLL to install. Only available on WIN32.
# GMP_DIR            - the directory the library we link with is found in.


if (GMP_INCLUDE_DIRS AND GMP_LIBRARIES)
  set(GMP_FIND_QUIETLY TRUE)
endif (GMP_INCLUDE_DIRS AND GMP_LIBRARIES)

if(MSVC)

find_library(GMP_LIBRARIES NAMES mpir mpird
	PATHS
		$ENV{GMP_ROOT}
		$ENV{GMP_ROOT}/lib
		${GMP_ROOT}
		${GMP_ROOT}/lib
		${CMAKE_SOURCE_DIR}/../tools/mpir/lib
		${CMAKE_SOURCE_DIR}/../tools/mpird/lib
		${CMAKE_SOURCE_DIR}/../mpir/lib
		${CMAKE_SOURCE_DIR}/../mpird/lib

		$ENV{PROGRAMFILES}/mpir/lib
		$ENV{PROGRAMFILES}/mpird/lib
		$ENV{HOME}/mpir/lib
		$ENV{HOME}/mpird/lib
		${CMAKE_INSTALL_PREFIX}/lib
	DOC "Try first the MPIR DLL when in an Windows environment"
)

find_file(GMP_LIBRARY_DLL NAMES mpir.dll mpird.dll
	PATHS
		${GMP_LIBRARIES_DIR}/../bin
		${GMP_LIBRARIES_DIR}
)

find_path(GMP_INCLUDE_DIRS
	NAMES mpir.h mpird.h
	PATHS
		${GMP_LIBRARIES_DIR}/../include
		${GMP_LIBRARIES_DIR}
)

else()

find_library(GMP_LIBRARIES
	NAMES gmp libgmp
	HINTS
		.
		$ENV{GMP_ROOT}
		$ENV{GMP_ROOT}/lib
		${GMP_ROOT}
		${GMP_ROOT}/lib
		/usr/local/opt/gmp/lib
		/opt/lib
		/usr/local/lib
		$ENV{HOME}/lib
		${CMAKE_INSTALL_PREFIX}/lib
)

find_library(GMPXX_LIBRARIES
	NAMES gmpxx libgmpxx
	HINTS
		.
		$ENV{GMP_ROOT}
		$ENV{GMP_ROOT}/lib
		${GMP_ROOT}
		${GMP_ROOT}/lib
		/usr/local/opt/gmp/lib
		/opt/lib
		/usr/local/lib
		$ENV{HOME}/lib
		${CMAKE_INSTALL_PREFIX}/lib
)

find_path(GMP_INCLUDE_DIRS
	NAMES gmp.h
	HINTS
		.
		$ENV{GMP_ROOT}
		$ENV{GMP_ROOT}/include
		${GMP_ROOT}
		${GMP_ROOT}/include
		${GMP_LIBRARIES_DIR}/../include
		${GMP_LIBRARIES_DIR}
		${INCLUDE_INSTALL_DIR}
)

endif()

get_filename_component(GMP_LIBRARIES_DIR "${GMP_LIBRARIES}" PATH CACHE)

include(FindPackageHandleStandardArgs)

if(MSVC)
	find_package_handle_standard_args(GMP DEFAULT_MSG GMP_LIBRARIES GMP_LIBRARIES_DIR GMP_LIBRARY_DLL GMP_INCLUDE_DIRS)
	mark_as_advanced(GMP_LIBRARY_DLL)
else()
	find_package_handle_standard_args(GMP DEFAULT_MSG GMP_LIBRARIES GMP_LIBRARIES_DIR GMP_INCLUDE_DIRS)
endif()

mark_as_advanced(GMP_LIBRARIES GMP_LIBRARIES_DIR GMP_INCLUDE_DIRS)
