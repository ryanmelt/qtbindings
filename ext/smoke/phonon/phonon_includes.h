#ifdef __SMOKEGEN_RUN__
#  define PHONON_EXPORT
#  define PHONON_DEPRECATED
#  define PHONON_EXPORT_DEPRECATED
#endif

#include <phonon/abstractaudiooutput.h>
#include <phonon/abstractmediastream.h>
#include <phonon/abstractvideooutput.h>
#include <phonon/addoninterface.h>
#include <phonon/audiodataoutput.h>
#include <phonon/audiodataoutputinterface.h>
#include <phonon/audiooutput.h>
#include <phonon/audiooutputinterface.h>
#include <phonon/backendcapabilities.h>
#include <phonon/backendinterface.h>
#include <phonon/effect.h>
#include <phonon/effectinterface.h>
#include <phonon/effectparameter.h>
#include <phonon/effectwidget.h>
#include <phonon/mediacontroller.h>
#include <phonon/medianode.h>
#include <phonon/mediaobject.h>
#include <phonon/mediaobjectinterface.h>
#include <phonon/mediasource.h>
#include <phonon/objectdescription.h>
#include <phonon/objectdescriptionmodel.h>
#include <phonon/path.h>
#include <phonon/phonon_export.h>
#include <phonon/phonondefs.h>
#include <phonon/phononnamespace.h>
#include <phonon/platformplugin.h>
#include <phonon/seekslider.h>
#include <phonon/streaminterface.h>
#include <phonon/videoplayer.h>
#include <phonon/videowidget.h>
#include <phonon/videowidgetinterface.h>
#include <phonon/volumefadereffect.h>
#include <phonon/volumefaderinterface.h>
#include <phonon/volumeslider.h>

#include <QtCore/qurl.h>
