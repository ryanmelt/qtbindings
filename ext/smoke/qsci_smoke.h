#ifndef QSCI_SMOKE_H
#define QSCI_SMOKE_H

#include <smoke.h>

// Defined in smokedata.cpp, initialized by init_qsci_Smoke(), used by all .cpp files
extern "C" SMOKE_EXPORT Smoke* qsci_Smoke;
extern "C" SMOKE_EXPORT void init_qsci_Smoke();
extern "C" SMOKE_EXPORT void delete_qsci_Smoke();

#ifndef QGLOBALSPACE_CLASS
#define QGLOBALSPACE_CLASS
class QGlobalSpace { };
#endif

#endif
