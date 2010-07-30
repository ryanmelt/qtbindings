#ifndef QTGUI_SMOKE_H
#define QTGUI_SMOKE_H

#include <smoke.h>

// Defined in smokedata.cpp, initialized by init_qtgui_Smoke(), used by all .cpp files
extern "C" SMOKE_EXPORT Smoke* qtgui_Smoke;
extern "C" SMOKE_EXPORT void init_qtgui_Smoke();
extern "C" SMOKE_EXPORT void delete_qtgui_Smoke();

#ifndef QGLOBALSPACE_CLASS
#define QGLOBALSPACE_CLASS
class QGlobalSpace { };
#endif

#endif
