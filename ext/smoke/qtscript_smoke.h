#ifndef QTSCRIPT_SMOKE_H
#define QTSCRIPT_SMOKE_H

#include <smoke.h>

// Defined in smokedata.cpp, initialized by init_qsci_Smoke(), used by all .cpp files
extern "C" SMOKE_EXPORT Smoke* qtscript_Smoke;
extern "C" SMOKE_EXPORT void init_qtscript_Smoke();
extern "C" SMOKE_EXPORT void delete_qtscript_Smoke();

#ifndef QGLOBALSPACE_CLASS
#define QGLOBALSPACE_CLASS
class QGlobalSpace { };
#endif

#endif
