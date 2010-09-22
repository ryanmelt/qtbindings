#ifndef QTDECLARATIVE_SMOKE_H
#define QTDECLARATIVE_SMOKE_H

#include <smoke.h>

// Defined in smokedata.cpp, initialized by init_qtdeclarative_Smoke(), used by all .cpp files
extern "C" SMOKE_EXPORT Smoke* qtdeclarative_Smoke;
extern "C" SMOKE_EXPORT void init_qtdeclarative_Smoke();
extern "C" SMOKE_EXPORT void delete_qtdeclarative_Smoke();

#ifndef QGLOBALSPACE_CLASS
#define QGLOBALSPACE_CLASS
class QGlobalSpace { };
#endif

#endif
