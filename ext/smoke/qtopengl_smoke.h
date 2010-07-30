#ifndef QTOPENGL_SMOKE_H
#define QTOPENGL_SMOKE_H

#include <smoke.h>

// Defined in smokedata.cpp, initialized by init_qtopengl_Smoke(), used by all .cpp files
extern "C" SMOKE_EXPORT Smoke* qtopengl_Smoke;
extern "C" SMOKE_EXPORT void init_qtopengl_Smoke();
extern "C" SMOKE_EXPORT void delete_qtopengl_Smoke();

#ifndef QGLOBALSPACE_CLASS
#define QGLOBALSPACE_CLASS
class QGlobalSpace { };
#endif

#endif
