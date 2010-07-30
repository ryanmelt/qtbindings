#ifndef QTXMLPATTERNS_SMOKE_H
#define QTXMLPATTERNS_SMOKE_H

#include <smoke.h>

// Defined in smokedata.cpp, initialized by init_qtxmlpatterns_Smoke(), used by all .cpp files
extern "C" SMOKE_EXPORT Smoke* qtxmlpatterns_Smoke;
extern "C" SMOKE_EXPORT void init_qtxmlpatterns_Smoke();
extern "C" SMOKE_EXPORT void delete_qtxmlpatterns_Smoke();

#ifndef QGLOBALSPACE_CLASS
#define QGLOBALSPACE_CLASS
class QGlobalSpace { };
#endif

#endif
