#pragma once

#if defined cork_EXPORTS
#	if defined _WIN32 || defined _WIN64
#		if defined(_MSC_VER)
#			define CORK_API __declspec( dllexport )
#		else
#			define CORK_API __attribute__((dllexport))
#		endif
#	else
#		define CORK_API __attribute__((visibility("default")))
#	endif
#else
#	define CORK_API
#endif
