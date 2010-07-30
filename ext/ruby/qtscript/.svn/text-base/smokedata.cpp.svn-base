#include <qcoreevent.h>
#include <qdatetime.h>
#include <qfactoryinterface.h>
#include <qobject.h>
#include <qobjectdefs.h>
#include <qregexp.h>
#include <qscriptable.h>
#include <qscriptclass.h>
#include <qscriptclasspropertyiterator.h>
#include <qscriptcontext.h>
#include <qscriptcontextinfo.h>
#include <qscriptengine.h>
#include <qscriptengineagent.h>
#include <qscriptextensioninterface.h>
#include <qscriptextensionplugin.h>
#include <qscriptstring.h>
#include <qscriptvalue.h>
#include <qscriptvalueiterator.h>
#include <qvariant.h>

#include <smoke.h>

#include <qtscript_smoke.h>

static void *qtscript_cast(void *xptr, Smoke::Index from, Smoke::Index to) {
    switch(from) {
      case 1:	//QChildEvent
	switch(to) {
	    case 3: return (void*)(QEvent*)(QChildEvent*)xptr;
	    case 1: return (void*)(QChildEvent*)(QChildEvent*)xptr;
	  default: return xptr;
	}
      case 2:	//QDateTime
	switch(to) {
	    case 2: return (void*)(QDateTime*)(QDateTime*)xptr;
	  default: return xptr;
	}
      case 3:	//QEvent
	switch(to) {
	    case 3: return (void*)(QEvent*)(QEvent*)xptr;
	    case 1: return (void*)(QChildEvent*)(QEvent*)xptr;
	    case 20: return (void*)(QTimerEvent*)(QEvent*)xptr;
	  default: return xptr;
	}
      case 4:	//QFactoryInterface
	switch(to) {
	    case 4: return (void*)(QFactoryInterface*)(QFactoryInterface*)xptr;
	    case 14: return (void*)(QScriptExtensionInterface*)(QFactoryInterface*)xptr;
	    case 15: return (void*)(QScriptExtensionPlugin*)(QFactoryInterface*)xptr;
	  default: return xptr;
	}
      case 5:	//QMetaObject
	switch(to) {
	    case 5: return (void*)(QMetaObject*)(QMetaObject*)xptr;
	  default: return xptr;
	}
      case 6:	//QObject
	switch(to) {
	    case 6: return (void*)(QObject*)(QObject*)xptr;
	    case 12: return (void*)(QScriptEngine*)(QObject*)xptr;
	    case 15: return (void*)(QScriptExtensionPlugin*)(QObject*)xptr;
	  default: return xptr;
	}
      case 7:	//QRegExp
	switch(to) {
	    case 7: return (void*)(QRegExp*)(QRegExp*)xptr;
	  default: return xptr;
	}
      case 8:	//QScriptClass
	switch(to) {
	    case 8: return (void*)(QScriptClass*)(QScriptClass*)xptr;
	  default: return xptr;
	}
      case 9:	//QScriptClassPropertyIterator
	switch(to) {
	    case 9: return (void*)(QScriptClassPropertyIterator*)(QScriptClassPropertyIterator*)xptr;
	  default: return xptr;
	}
      case 10:	//QScriptContext
	switch(to) {
	    case 10: return (void*)(QScriptContext*)(QScriptContext*)xptr;
	  default: return xptr;
	}
      case 11:	//QScriptContextInfo
	switch(to) {
	    case 11: return (void*)(QScriptContextInfo*)(QScriptContextInfo*)xptr;
	  default: return xptr;
	}
      case 12:	//QScriptEngine
	switch(to) {
	    case 6: return (void*)(QObject*)(QScriptEngine*)xptr;
	    case 12: return (void*)(QScriptEngine*)(QScriptEngine*)xptr;
	  default: return xptr;
	}
      case 13:	//QScriptEngineAgent
	switch(to) {
	    case 13: return (void*)(QScriptEngineAgent*)(QScriptEngineAgent*)xptr;
	  default: return xptr;
	}
      case 14:	//QScriptExtensionInterface
	switch(to) {
	    case 4: return (void*)(QFactoryInterface*)(QScriptExtensionInterface*)xptr;
	    case 14: return (void*)(QScriptExtensionInterface*)(QScriptExtensionInterface*)xptr;
	    case 15: return (void*)(QScriptExtensionPlugin*)(QScriptExtensionInterface*)xptr;
	  default: return xptr;
	}
      case 15:	//QScriptExtensionPlugin
	switch(to) {
	    case 6: return (void*)(QObject*)(QScriptExtensionPlugin*)xptr;
	    case 14: return (void*)(QScriptExtensionInterface*)(QScriptExtensionPlugin*)xptr;
	    case 4: return (void*)(QFactoryInterface*)(QScriptExtensionPlugin*)xptr;
	    case 15: return (void*)(QScriptExtensionPlugin*)(QScriptExtensionPlugin*)xptr;
	  default: return xptr;
	}
      case 16:	//QScriptString
	switch(to) {
	    case 16: return (void*)(QScriptString*)(QScriptString*)xptr;
	  default: return xptr;
	}
      case 17:	//QScriptValue
	switch(to) {
	    case 17: return (void*)(QScriptValue*)(QScriptValue*)xptr;
	  default: return xptr;
	}
      case 18:	//QScriptValueIterator
	switch(to) {
	    case 18: return (void*)(QScriptValueIterator*)(QScriptValueIterator*)xptr;
	  default: return xptr;
	}
      case 19:	//QScriptable
	switch(to) {
	    case 19: return (void*)(QScriptable*)(QScriptable*)xptr;
	  default: return xptr;
	}
      case 20:	//QTimerEvent
	switch(to) {
	    case 3: return (void*)(QEvent*)(QTimerEvent*)xptr;
	    case 20: return (void*)(QTimerEvent*)(QTimerEvent*)xptr;
	  default: return xptr;
	}
      case 21:	//QVariant
	switch(to) {
	    case 21: return (void*)(QVariant*)(QVariant*)xptr;
	  default: return xptr;
	}
      default: return xptr;
    }
}

// Group of Indexes (0 separated) used as super class lists.
// Classes with super classes have an index into this array.
static Smoke::Index qtscript_inheritanceList[] = {
	0,	// 0: (no super class)
	6, 0,	// 1: QObject
	6, 14, 0,	// 3: QObject, QScriptExtensionInterface
};

// These are the xenum functions for manipulating enum pointers
void xenum_QScriptEngineAgent(Smoke::EnumOperation, Smoke::Index, void*&, long&);
void xenum_QScriptValue(Smoke::EnumOperation, Smoke::Index, void*&, long&);
void xenum_QScriptClass(Smoke::EnumOperation, Smoke::Index, void*&, long&);
void xenum_QScriptContextInfo(Smoke::EnumOperation, Smoke::Index, void*&, long&);
void xenum_QScriptContext(Smoke::EnumOperation, Smoke::Index, void*&, long&);
void xenum_QScriptEngine(Smoke::EnumOperation, Smoke::Index, void*&, long&);

// Those are the xcall functions defined in each x_*.cpp file, for dispatching method calls
void xcall_QScriptClass(Smoke::Index, void*, Smoke::Stack);
void xcall_QScriptClassPropertyIterator(Smoke::Index, void*, Smoke::Stack);
void xcall_QScriptContext(Smoke::Index, void*, Smoke::Stack);
void xcall_QScriptContextInfo(Smoke::Index, void*, Smoke::Stack);
void xcall_QScriptEngine(Smoke::Index, void*, Smoke::Stack);
void xcall_QScriptEngineAgent(Smoke::Index, void*, Smoke::Stack);
void xcall_QScriptExtensionPlugin(Smoke::Index, void*, Smoke::Stack);
void xcall_QScriptString(Smoke::Index, void*, Smoke::Stack);
void xcall_QScriptValue(Smoke::Index, void*, Smoke::Stack);
void xcall_QScriptValueIterator(Smoke::Index, void*, Smoke::Stack);
void xcall_QScriptable(Smoke::Index, void*, Smoke::Stack);

// List of all classes
// Name, index into inheritanceList, method dispatcher, enum dispatcher, class flags
static Smoke::Class qtscript_classes[] = {
	{ 0L, false, 0, 0, 0, 0 }, 	// 0 (no class)
	{ "QChildEvent", true, 0, 0, 0, 0 }, 	// 1
	{ "QDateTime", true, 0, 0, 0, 0 }, 	// 2
	{ "QEvent", true, 0, 0, 0, 0 }, 	// 3
	{ "QFactoryInterface", true, 0, 0, 0, 0 }, 	// 4
	{ "QMetaObject", true, 0, 0, 0, 0 }, 	// 5
	{ "QObject", true, 0, 0, 0, 0 }, 	// 6
	{ "QRegExp", true, 0, 0, 0, 0 }, 	// 7
	{ "QScriptClass", false, 0, xcall_QScriptClass, xenum_QScriptClass, Smoke::cf_constructor|Smoke::cf_virtual }, 	//8
	{ "QScriptClassPropertyIterator", false, 0, xcall_QScriptClassPropertyIterator, 0, Smoke::cf_constructor|Smoke::cf_virtual }, 	//9
	{ "QScriptContext", false, 0, xcall_QScriptContext, xenum_QScriptContext, 0 }, 	//10
	{ "QScriptContextInfo", false, 0, xcall_QScriptContextInfo, xenum_QScriptContextInfo, Smoke::cf_constructor|Smoke::cf_deepcopy }, 	//11
	{ "QScriptEngine", false, 1, xcall_QScriptEngine, xenum_QScriptEngine, Smoke::cf_constructor|Smoke::cf_virtual }, 	//12
	{ "QScriptEngineAgent", false, 0, xcall_QScriptEngineAgent, xenum_QScriptEngineAgent, Smoke::cf_constructor|Smoke::cf_virtual }, 	//13
	{ "QScriptExtensionInterface", true, 0, 0, 0, 0 }, 	// 14
	{ "QScriptExtensionPlugin", false, 3, xcall_QScriptExtensionPlugin, 0, Smoke::cf_virtual }, 	//15
	{ "QScriptString", false, 0, xcall_QScriptString, 0, Smoke::cf_constructor|Smoke::cf_deepcopy }, 	//16
	{ "QScriptValue", false, 0, xcall_QScriptValue, xenum_QScriptValue, Smoke::cf_constructor|Smoke::cf_deepcopy }, 	//17
	{ "QScriptValueIterator", false, 0, xcall_QScriptValueIterator, 0, Smoke::cf_constructor }, 	//18
	{ "QScriptable", false, 0, xcall_QScriptable, 0, Smoke::cf_constructor }, 	//19
	{ "QTimerEvent", true, 0, 0, 0, 0 }, 	// 20
	{ "QVariant", true, 0, 0, 0, 0 }, 	// 21
};

// List of all types needed by the methods (arguments and return values)
// Name, class ID if arg is a class, and TypeId
static Smoke::Type qtscript_types[] = {
	{ 0, 0, 0 },	//0 (no type)
	{ "FunctionSignature", 0, Smoke::t_voidp | Smoke::tf_stack },	//1
	{ "FunctionWithArgSignature", 0, Smoke::t_voidp | Smoke::tf_stack },	//2
	{ "QAbstractFileEngine::FileFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//3
	{ "QAbstractItemView::EditTriggers", 0, Smoke::t_uint | Smoke::tf_stack },	//4
	{ "QAbstractPrintDialog::PrintDialogOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//5
	{ "QAbstractSpinBox::StepEnabled", 0, Smoke::t_uint | Smoke::tf_stack },	//6
	{ "QAccessible::Relation", 0, Smoke::t_uint | Smoke::tf_stack },	//7
	{ "QAccessible::State", 0, Smoke::t_uint | Smoke::tf_stack },	//8
	{ "QChildEvent*", 1, Smoke::t_class | Smoke::tf_ptr },	//9
	{ "QDBusConnection::RegisterOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//10
	{ "QDateTime", 2, Smoke::t_class | Smoke::tf_stack },	//11
	{ "QDateTimeEdit::Sections", 0, Smoke::t_uint | Smoke::tf_stack },	//12
	{ "QDialogButtonBox::StandardButtons", 0, Smoke::t_uint | Smoke::tf_stack },	//13
	{ "QDir::Filters", 0, Smoke::t_uint | Smoke::tf_stack },	//14
	{ "QDir::SortFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//15
	{ "QDirIterator::IteratorFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//16
	{ "QDockWidget::DockWidgetFeatures", 0, Smoke::t_uint | Smoke::tf_stack },	//17
	{ "QEvent*", 3, Smoke::t_class | Smoke::tf_ptr },	//18
	{ "QEventLoop::ProcessEventsFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//19
	{ "QFile::Permissions", 0, Smoke::t_uint | Smoke::tf_stack },	//20
	{ "QFileDialog::Options", 0, Smoke::t_uint | Smoke::tf_stack },	//21
	{ "QFontComboBox::FontFilters", 0, Smoke::t_uint | Smoke::tf_stack },	//22
	{ "QGL::FormatOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//23
	{ "QGLFormat::OpenGLVersionFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//24
	{ "QGraphicsItem::GraphicsItemFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//25
	{ "QGraphicsScene::SceneLayers", 0, Smoke::t_uint | Smoke::tf_stack },	//26
	{ "QGraphicsView::CacheMode", 0, Smoke::t_uint | Smoke::tf_stack },	//27
	{ "QGraphicsView::OptimizationFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//28
	{ "QIODevice::OpenMode", 0, Smoke::t_uint | Smoke::tf_stack },	//29
	{ "QItemSelectionModel::SelectionFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//30
	{ "QLibrary::LoadHints", 0, Smoke::t_uint | Smoke::tf_stack },	//31
	{ "QLocale::NumberOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//32
	{ "QMainWindow::DockOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//33
	{ "QMdiArea::AreaOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//34
	{ "QMdiSubWindow::SubWindowOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//35
	{ "QMessageBox::StandardButtons", 0, Smoke::t_uint | Smoke::tf_stack },	//36
	{ "QMetaObject::Call", 5, Smoke::t_enum | Smoke::tf_stack },	//37
	{ "QNetworkInterface::InterfaceFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//38
	{ "QObject*", 6, Smoke::t_class | Smoke::tf_ptr },	//39
	{ "QPageSetupDialog::PageSetupDialogOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//40
	{ "QPaintEngine::DirtyFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//41
	{ "QPaintEngine::PaintEngineFeatures", 0, Smoke::t_uint | Smoke::tf_stack },	//42
	{ "QPainter::RenderHints", 0, Smoke::t_uint | Smoke::tf_stack },	//43
	{ "QRegExp", 7, Smoke::t_class | Smoke::tf_stack },	//44
	{ "QScriptClass*", 8, Smoke::t_class | Smoke::tf_ptr },	//45
	{ "QScriptClass::Extension", 8, Smoke::t_enum | Smoke::tf_stack },	//46
	{ "QScriptClass::QueryFlag", 8, Smoke::t_enum | Smoke::tf_stack },	//47
	{ "QScriptClass::QueryFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//48
	{ "QScriptClassPrivate&", 0, Smoke::t_voidp | Smoke::tf_ref },	//49
	{ "QScriptClassPropertyIterator*", 9, Smoke::t_class | Smoke::tf_ptr },	//50
	{ "QScriptClassPropertyIteratorPrivate&", 0, Smoke::t_voidp | Smoke::tf_ref },	//51
	{ "QScriptContext*", 10, Smoke::t_class | Smoke::tf_ptr },	//52
	{ "QScriptContext::Error", 10, Smoke::t_enum | Smoke::tf_stack },	//53
	{ "QScriptContext::ExecutionState", 10, Smoke::t_enum | Smoke::tf_stack },	//54
	{ "QScriptContextInfo&", 11, Smoke::t_class | Smoke::tf_ref },	//55
	{ "QScriptContextInfo*", 11, Smoke::t_class | Smoke::tf_ptr },	//56
	{ "QScriptContextInfo::FunctionType", 11, Smoke::t_enum | Smoke::tf_stack },	//57
	{ "QScriptEngine*", 12, Smoke::t_class | Smoke::tf_ptr },	//58
	{ "QScriptEngine::QObjectWrapOption", 12, Smoke::t_enum | Smoke::tf_stack },	//59
	{ "QScriptEngine::QObjectWrapOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//60
	{ "QScriptEngine::ValueOwnership", 12, Smoke::t_enum | Smoke::tf_stack },	//61
	{ "QScriptEngineAgent*", 13, Smoke::t_class | Smoke::tf_ptr },	//62
	{ "QScriptEngineAgent::Extension", 13, Smoke::t_enum | Smoke::tf_stack },	//63
	{ "QScriptString", 16, Smoke::t_class | Smoke::tf_stack },	//64
	{ "QScriptString&", 16, Smoke::t_class | Smoke::tf_ref },	//65
	{ "QScriptString*", 16, Smoke::t_class | Smoke::tf_ptr },	//66
	{ "QScriptValue", 17, Smoke::t_class | Smoke::tf_stack },	//67
	{ "QScriptValue&", 17, Smoke::t_class | Smoke::tf_ref },	//68
	{ "QScriptValue*", 17, Smoke::t_class | Smoke::tf_ptr },	//69
	{ "QScriptValue::PropertyFlag", 17, Smoke::t_enum | Smoke::tf_stack },	//70
	{ "QScriptValue::PropertyFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//71
	{ "QScriptValue::ResolveFlag", 17, Smoke::t_enum | Smoke::tf_stack },	//72
	{ "QScriptValue::ResolveFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//73
	{ "QScriptValue::SpecialValue", 17, Smoke::t_enum | Smoke::tf_stack },	//74
	{ "QScriptValueIterator&", 18, Smoke::t_class | Smoke::tf_ref },	//75
	{ "QScriptValueIterator*", 18, Smoke::t_class | Smoke::tf_ptr },	//76
	{ "QScriptable*", 19, Smoke::t_class | Smoke::tf_ptr },	//77
	{ "QSizePolicy::ControlTypes", 0, Smoke::t_uint | Smoke::tf_stack },	//78
	{ "QSql::ParamType", 0, Smoke::t_uint | Smoke::tf_stack },	//79
	{ "QString", 0, Smoke::t_voidp | Smoke::tf_stack },	//80
	{ "QString::SectionFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//81
	{ "QStringList", 0, Smoke::t_voidp | Smoke::tf_stack },	//82
	{ "QStyle::State", 0, Smoke::t_uint | Smoke::tf_stack },	//83
	{ "QStyle::SubControls", 0, Smoke::t_uint | Smoke::tf_stack },	//84
	{ "QStyleOptionButton::ButtonFeatures", 0, Smoke::t_uint | Smoke::tf_stack },	//85
	{ "QStyleOptionFrameV2::FrameFeatures", 0, Smoke::t_uint | Smoke::tf_stack },	//86
	{ "QStyleOptionQ3ListViewItem::Q3ListViewItemFeatures", 0, Smoke::t_uint | Smoke::tf_stack },	//87
	{ "QStyleOptionTab::CornerWidgets", 0, Smoke::t_uint | Smoke::tf_stack },	//88
	{ "QStyleOptionToolBar::ToolBarFeatures", 0, Smoke::t_uint | Smoke::tf_stack },	//89
	{ "QStyleOptionToolButton::ToolButtonFeatures", 0, Smoke::t_uint | Smoke::tf_stack },	//90
	{ "QStyleOptionViewItemV2::ViewItemFeatures", 0, Smoke::t_uint | Smoke::tf_stack },	//91
	{ "QTextBoundaryFinder::BoundaryReasons", 0, Smoke::t_uint | Smoke::tf_stack },	//92
	{ "QTextCodec::ConversionFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//93
	{ "QTextDocument::FindFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//94
	{ "QTextEdit::AutoFormatting", 0, Smoke::t_uint | Smoke::tf_stack },	//95
	{ "QTextFormat::PageBreakFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//96
	{ "QTextItem::RenderFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//97
	{ "QTextOption::Flags", 0, Smoke::t_uint | Smoke::tf_stack },	//98
	{ "QTextStream::NumberFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//99
	{ "QTimerEvent*", 20, Smoke::t_class | Smoke::tf_ptr },	//100
	{ "QTreeWidgetItemIterator::IteratorFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//101
	{ "QUdpSocket::BindMode", 0, Smoke::t_uint | Smoke::tf_stack },	//102
	{ "QUrl::FormattingOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//103
	{ "QVariant", 21, Smoke::t_class | Smoke::tf_stack },	//104
	{ "QVariant::Type", 21, Smoke::t_enum | Smoke::tf_stack },	//105
	{ "QWidget::RenderFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//106
	{ "QWizard::WizardOptions", 0, Smoke::t_uint | Smoke::tf_stack },	//107
	{ "Qt::Alignment", 0, Smoke::t_uint | Smoke::tf_stack },	//108
	{ "Qt::DockWidgetAreas", 0, Smoke::t_uint | Smoke::tf_stack },	//109
	{ "Qt::DropActions", 0, Smoke::t_uint | Smoke::tf_stack },	//110
	{ "Qt::ImageConversionFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//111
	{ "Qt::ItemFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//112
	{ "Qt::KeyboardModifiers", 0, Smoke::t_uint | Smoke::tf_stack },	//113
	{ "Qt::MatchFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//114
	{ "Qt::MouseButtons", 0, Smoke::t_uint | Smoke::tf_stack },	//115
	{ "Qt::Orientations", 0, Smoke::t_uint | Smoke::tf_stack },	//116
	{ "Qt::TextInteractionFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//117
	{ "Qt::ToolBarAreas", 0, Smoke::t_uint | Smoke::tf_stack },	//118
	{ "Qt::WindowFlags", 0, Smoke::t_uint | Smoke::tf_stack },	//119
	{ "Qt::WindowStates", 0, Smoke::t_uint | Smoke::tf_stack },	//120
	{ "bool", 0, Smoke::t_bool | Smoke::tf_stack },	//121
	{ "const Handler*", 0, Smoke::t_voidp | Smoke::tf_ptr | Smoke::tf_const },	//122
	{ "const QDateTime&", 2, Smoke::t_class | Smoke::tf_ref | Smoke::tf_const },	//123
	{ "const QList<QScriptValue>&", 0, Smoke::t_voidp | Smoke::tf_ref | Smoke::tf_const },	//124
	{ "const QMetaObject", 5, Smoke::t_class | Smoke::tf_stack | Smoke::tf_const },	//125
	{ "const QMetaObject*", 5, Smoke::t_class | Smoke::tf_ptr | Smoke::tf_const },	//126
	{ "const QRegExp&", 7, Smoke::t_class | Smoke::tf_ref | Smoke::tf_const },	//127
	{ "const QScriptContext*", 10, Smoke::t_class | Smoke::tf_ptr | Smoke::tf_const },	//128
	{ "const QScriptContextInfo&", 11, Smoke::t_class | Smoke::tf_ref | Smoke::tf_const },	//129
	{ "const QScriptEngine::QObjectWrapOptions&", 0, Smoke::t_voidp | Smoke::tf_ref | Smoke::tf_const },	//130
	{ "const QScriptString&", 16, Smoke::t_class | Smoke::tf_ref | Smoke::tf_const },	//131
	{ "const QScriptValue&", 17, Smoke::t_class | Smoke::tf_ref | Smoke::tf_const },	//132
	{ "const QScriptValue::PropertyFlags&", 0, Smoke::t_voidp | Smoke::tf_ref | Smoke::tf_const },	//133
	{ "const QScriptValue::ResolveFlags&", 0, Smoke::t_voidp | Smoke::tf_ref | Smoke::tf_const },	//134
	{ "const QString&", 0, Smoke::t_voidp | Smoke::tf_ref | Smoke::tf_const },	//135
	{ "const QVariant&", 21, Smoke::t_class | Smoke::tf_ref | Smoke::tf_const },	//136
	{ "const char*", 0, Smoke::t_voidp | Smoke::tf_ptr | Smoke::tf_const },	//137
	{ "double", 0, Smoke::t_double | Smoke::tf_stack },	//138
	{ "int", 0, Smoke::t_int | Smoke::tf_stack },	//139
	{ "qint64", 0, Smoke::t_long | Smoke::tf_stack },	//140
	{ "uint", 0, Smoke::t_uint | Smoke::tf_stack },	//141
	{ "uint*", 0, Smoke::t_voidp | Smoke::tf_ptr },	//142
	{ "unsigned int", 0, Smoke::t_uint | Smoke::tf_stack },	//143
	{ "unsigned short", 0, Smoke::t_ushort | Smoke::tf_stack },	//144
	{ "void*", 0, Smoke::t_voidp | Smoke::tf_stack },	//145
	{ "void**", 0, Smoke::t_voidp | Smoke::tf_ptr },	//146
};

static Smoke::Index qtscript_argumentList[] = {
	0,	//0  (void)
	1, 0,	//1  FunctionSignature  
	1, 132, 0,	//3  FunctionSignature, const QScriptValue&  
	1, 132, 139, 0,	//6  FunctionSignature, const QScriptValue&, int  
	1, 139, 0,	//10  FunctionSignature, int  
	100, 0,	//13  QTimerEvent*  
	123, 0,	//15  const QDateTime&  
	124, 0,	//17  const QList<QScriptValue>&  
	126, 0,	//19  const QMetaObject*  
	126, 132, 0,	//21  const QMetaObject*, const QScriptValue&  
	127, 0,	//24  const QRegExp&  
	128, 0,	//26  const QScriptContext*  
	129, 0,	//28  const QScriptContextInfo&  
	131, 0,	//30  const QScriptString&  
	131, 132, 0,	//32  const QScriptString&, const QScriptValue&  
	131, 132, 133, 0,	//35  const QScriptString&, const QScriptValue&, const QScriptValue::PropertyFlags&  
	131, 134, 0,	//39  const QScriptString&, const QScriptValue::ResolveFlags&  
	132, 0,	//42  const QScriptValue&  
	132, 124, 0,	//44  const QScriptValue&, const QList<QScriptValue>&  
	132, 131, 141, 0,	//47  const QScriptValue&, const QScriptString&, uint  
	132, 131, 48, 142, 0,	//51  const QScriptValue&, const QScriptString&, QScriptClass::QueryFlags, uint*  
	132, 132, 0,	//56  const QScriptValue&, const QScriptValue&  
	132, 136, 0,	//59  const QScriptValue&, const QVariant&  
	132, 39, 0,	//62  const QScriptValue&, QObject*  
	132, 39, 61, 0,	//65  const QScriptValue&, QObject*, QScriptEngine::ValueOwnership  
	132, 39, 61, 130, 0,	//69  const QScriptValue&, QObject*, QScriptEngine::ValueOwnership, const QScriptEngine::QObjectWrapOptions&  
	132, 51, 0,	//74  const QScriptValue&, QScriptClassPropertyIteratorPrivate&  
	135, 0,	//77  const QString&  
	135, 132, 0,	//79  const QString&, const QScriptValue&  
	135, 132, 133, 0,	//82  const QString&, const QScriptValue&, const QScriptValue::PropertyFlags&  
	135, 134, 0,	//86  const QString&, const QScriptValue::ResolveFlags&  
	135, 135, 0,	//89  const QString&, const QString&  
	135, 135, 139, 0,	//92  const QString&, const QString&, int  
	135, 58, 0,	//96  const QString&, QScriptEngine*  
	136, 0,	//99  const QVariant&  
	137, 0,	//101  const char*  
	137, 137, 0,	//103  const char*, const char*  
	138, 0,	//106  double  
	139, 0,	//108  int  
	139, 132, 0,	//110  int, const QScriptValue&  
	140, 0,	//113  qint64  
	140, 132, 0,	//115  qint64, const QScriptValue&  
	140, 132, 121, 0,	//118  qint64, const QScriptValue&, bool  
	140, 135, 135, 139, 0,	//122  qint64, const QString&, const QString&, int  
	140, 139, 139, 0,	//127  qint64, int, int  
	141, 0,	//131  uint  
	143, 0,	//133  unsigned int  
	143, 132, 0,	//135  unsigned int, const QScriptValue&  
	143, 132, 133, 0,	//138  unsigned int, const QScriptValue&, const QScriptValue::PropertyFlags&  
	143, 134, 0,	//142  unsigned int, const QScriptValue::ResolveFlags&  
	18, 0,	//145  QEvent*  
	2, 145, 0,	//147  FunctionWithArgSignature, void*  
	37, 139, 146, 0,	//150  QMetaObject::Call, int, void**  
	39, 0,	//154  QObject*  
	39, 18, 0,	//156  QObject*, QEvent*  
	39, 61, 0,	//159  QObject*, QScriptEngine::ValueOwnership  
	39, 61, 130, 0,	//162  QObject*, QScriptEngine::ValueOwnership, const QScriptEngine::QObjectWrapOptions&  
	45, 0,	//166  QScriptClass*  
	45, 132, 0,	//168  QScriptClass*, const QScriptValue&  
	46, 0,	//171  QScriptClass::Extension  
	46, 136, 0,	//173  QScriptClass::Extension, const QVariant&  
	53, 135, 0,	//176  QScriptContext::Error, const QString&  
	58, 0,	//179  QScriptEngine*  
	58, 121, 0,	//181  QScriptEngine*, bool  
	58, 135, 0,	//184  QScriptEngine*, const QString&  
	58, 137, 0,	//187  QScriptEngine*, const char*  
	58, 138, 0,	//190  QScriptEngine*, double  
	58, 139, 0,	//193  QScriptEngine*, int  
	58, 141, 0,	//196  QScriptEngine*, uint  
	58, 49, 0,	//199  QScriptEngine*, QScriptClassPrivate&  
	58, 74, 0,	//202  QScriptEngine*, QScriptValue::SpecialValue  
	62, 0,	//205  QScriptEngineAgent*  
	63, 0,	//207  QScriptEngineAgent::Extension  
	63, 136, 0,	//209  QScriptEngineAgent::Extension, const QVariant&  
	68, 0,	//212  QScriptValue&  
	68, 131, 141, 132, 0,	//214  QScriptValue&, const QScriptString&, uint, const QScriptValue&  
	9, 0,	//219  QChildEvent*  
};

// Raw list of all methods, using munged names
static const char *qtscript_methodNames[] = {
    "",	//0
    "AutoCreateDynamicProperties",	//1
    "AutoOwnership",	//2
    "Callable",	//3
    "ExceptionState",	//4
    "ExcludeChildObjects",	//5
    "ExcludeSuperClassMethods",	//6
    "ExcludeSuperClassProperties",	//7
    "HandlesReadAccess",	//8
    "HandlesWriteAccess",	//9
    "KeepExistingFlags",	//10
    "NativeFunction",	//11
    "NormalState",	//12
    "NullValue",	//13
    "PreferExistingWrapperObject",	//14
    "PropertyGetter",	//15
    "PropertySetter",	//16
    "QObjectMember",	//17
    "QScriptClass",	//18
    "QScriptClass#",	//19
    "QScriptClass#?",	//20
    "QScriptClassPropertyIterator",	//21
    "QScriptClassPropertyIterator#",	//22
    "QScriptClassPropertyIterator#?",	//23
    "QScriptContextInfo",	//24
    "QScriptContextInfo#",	//25
    "QScriptEngine",	//26
    "QScriptEngine#",	//27
    "QScriptEngineAgent",	//28
    "QScriptEngineAgent#",	//29
    "QScriptString",	//30
    "QScriptString#",	//31
    "QScriptValue",	//32
    "QScriptValue#",	//33
    "QScriptValue#$",	//34
    "QScriptValueIterator",	//35
    "QScriptValueIterator#",	//36
    "QScriptable",	//37
    "QtFunction",	//38
    "QtOwnership",	//39
    "QtPropertyFunction",	//40
    "RangeError",	//41
    "ReadOnly",	//42
    "ReferenceError",	//43
    "ResolveFull",	//44
    "ResolveLocal",	//45
    "ResolvePrototype",	//46
    "ResolveScope",	//47
    "ScriptFunction",	//48
    "ScriptOwnership",	//49
    "SkipInEnumeration",	//50
    "SkipMethodsInEnumeration",	//51
    "SyntaxError",	//52
    "TypeError",	//53
    "URIError",	//54
    "UndefinedValue",	//55
    "Undeletable",	//56
    "UnknownError",	//57
    "UserRange",	//58
    "abortEvaluation",	//59
    "abortEvaluation#",	//60
    "activationObject",	//61
    "agent",	//62
    "argument",	//63
    "argument$",	//64
    "argumentCount",	//65
    "argumentsObject",	//66
    "availableExtensions",	//67
    "backtrace",	//68
    "call",	//69
    "call#",	//70
    "call##",	//71
    "call#?",	//72
    "callee",	//73
    "canEvaluate",	//74
    "canEvaluate$",	//75
    "childEvent",	//76
    "childEvent#",	//77
    "clearExceptions",	//78
    "collectGarbage",	//79
    "columnNumber",	//80
    "connectNotify",	//81
    "connectNotify$",	//82
    "construct",	//83
    "construct#",	//84
    "construct?",	//85
    "context",	//86
    "contextPop",	//87
    "contextPush",	//88
    "currentContext",	//89
    "customEvent",	//90
    "customEvent#",	//91
    "data",	//92
    "defaultPrototype",	//93
    "defaultPrototype$",	//94
    "disconnectNotify",	//95
    "disconnectNotify$",	//96
    "engine",	//97
    "equals",	//98
    "equals#",	//99
    "evaluate",	//100
    "evaluate$",	//101
    "evaluate$$",	//102
    "evaluate$$$",	//103
    "event",	//104
    "event#",	//105
    "eventFilter",	//106
    "eventFilter##",	//107
    "exceptionCatch",	//108
    "exceptionCatch$#",	//109
    "exceptionThrow",	//110
    "exceptionThrow$#$",	//111
    "extension",	//112
    "extension$",	//113
    "extension$#",	//114
    "fileName",	//115
    "flags",	//116
    "functionEndLineNumber",	//117
    "functionEntry",	//118
    "functionEntry$",	//119
    "functionExit",	//120
    "functionExit$#",	//121
    "functionMetaIndex",	//122
    "functionName",	//123
    "functionParameterNames",	//124
    "functionStartLineNumber",	//125
    "functionType",	//126
    "globalObject",	//127
    "hasNext",	//128
    "hasPrevious",	//129
    "hasUncaughtException",	//130
    "id",	//131
    "importExtension",	//132
    "importExtension$",	//133
    "importedExtensions",	//134
    "initialize",	//135
    "initialize$#",	//136
    "instanceOf",	//137
    "instanceOf#",	//138
    "isArray",	//139
    "isBoolean",	//140
    "isCalledAsConstructor",	//141
    "isDate",	//142
    "isError",	//143
    "isEvaluating",	//144
    "isFunction",	//145
    "isNull",	//146
    "isNumber",	//147
    "isObject",	//148
    "isQMetaObject",	//149
    "isQObject",	//150
    "isRegExp",	//151
    "isString",	//152
    "isUndefined",	//153
    "isValid",	//154
    "isVariant",	//155
    "keys",	//156
    "lessThan",	//157
    "lessThan#",	//158
    "lineNumber",	//159
    "metaObject",	//160
    "name",	//161
    "newActivationObject",	//162
    "newArray",	//163
    "newArray$",	//164
    "newDate",	//165
    "newDate#",	//166
    "newDate$",	//167
    "newFunction",	//168
    "newFunction?",	//169
    "newFunction?#",	//170
    "newFunction?#$",	//171
    "newFunction?$",	//172
    "newIterator",	//173
    "newIterator#",	//174
    "newObject",	//175
    "newObject#",	//176
    "newObject##",	//177
    "newQMetaObject",	//178
    "newQMetaObject#",	//179
    "newQMetaObject##",	//180
    "newQObject",	//181
    "newQObject#",	//182
    "newQObject##",	//183
    "newQObject##$",	//184
    "newQObject##$$",	//185
    "newQObject#$",	//186
    "newQObject#$$",	//187
    "newRegExp",	//188
    "newRegExp#",	//189
    "newRegExp$$",	//190
    "newVariant",	//191
    "newVariant#",	//192
    "newVariant##",	//193
    "next",	//194
    "nullValue",	//195
    "object",	//196
    "objectById",	//197
    "objectById$",	//198
    "objectId",	//199
    "operator QString",	//200
    "operator!=",	//201
    "operator!=#",	//202
    "operator=",	//203
    "operator=#",	//204
    "operator==",	//205
    "operator==#",	//206
    "parentContext",	//207
    "popContext",	//208
    "positionChange",	//209
    "positionChange$$$",	//210
    "previous",	//211
    "processEventsInterval",	//212
    "property",	//213
    "property#",	//214
    "property##$",	//215
    "property#$",	//216
    "property$",	//217
    "property$$",	//218
    "propertyFlags",	//219
    "propertyFlags#",	//220
    "propertyFlags##$",	//221
    "propertyFlags#$",	//222
    "propertyFlags$",	//223
    "propertyFlags$$",	//224
    "prototype",	//225
    "pushContext",	//226
    "qt_metacall",	//227
    "qt_metacall$$?",	//228
    "queryProperty",	//229
    "queryProperty##$$",	//230
    "remove",	//231
    "returnValue",	//232
    "scope",	//233
    "scriptClass",	//234
    "scriptId",	//235
    "scriptLoad",	//236
    "scriptLoad$$$$",	//237
    "scriptName",	//238
    "scriptUnload",	//239
    "scriptUnload$",	//240
    "setActivationObject",	//241
    "setActivationObject#",	//242
    "setAgent",	//243
    "setAgent#",	//244
    "setData",	//245
    "setData#",	//246
    "setDefaultPrototype",	//247
    "setDefaultPrototype$#",	//248
    "setProcessEventsInterval",	//249
    "setProcessEventsInterval$",	//250
    "setProperty",	//251
    "setProperty##",	//252
    "setProperty##$",	//253
    "setProperty##$#",	//254
    "setProperty$#",	//255
    "setProperty$#$",	//256
    "setPrototype",	//257
    "setPrototype#",	//258
    "setReturnValue",	//259
    "setReturnValue#",	//260
    "setScope",	//261
    "setScope#",	//262
    "setScriptClass",	//263
    "setScriptClass#",	//264
    "setThisObject",	//265
    "setThisObject#",	//266
    "setValue",	//267
    "setValue#",	//268
    "signalHandlerException",	//269
    "signalHandlerException#",	//270
    "state",	//271
    "strictlyEquals",	//272
    "strictlyEquals#",	//273
    "supportsExtension",	//274
    "supportsExtension$",	//275
    "thisObject",	//276
    "throwError",	//277
    "throwError$",	//278
    "throwError$$",	//279
    "throwValue",	//280
    "throwValue#",	//281
    "timerEvent",	//282
    "timerEvent#",	//283
    "toBack",	//284
    "toBoolean",	//285
    "toDateTime",	//286
    "toFront",	//287
    "toInt32",	//288
    "toInteger",	//289
    "toNumber",	//290
    "toObject",	//291
    "toQMetaObject",	//292
    "toQObject",	//293
    "toRegExp",	//294
    "toString",	//295
    "toStringHandle",	//296
    "toStringHandle$",	//297
    "toUInt16",	//298
    "toUInt32",	//299
    "toVariant",	//300
    "tr",	//301
    "tr$",	//302
    "tr$$",	//303
    "uncaughtException",	//304
    "uncaughtExceptionBacktrace",	//305
    "uncaughtExceptionLineNumber",	//306
    "undefinedValue",	//307
    "value",	//308
    "~QScriptClass",	//309
    "~QScriptClassPropertyIterator",	//310
    "~QScriptContext",	//311
    "~QScriptContextInfo",	//312
    "~QScriptEngine",	//313
    "~QScriptEngineAgent",	//314
    "~QScriptString",	//315
    "~QScriptValue",	//316
    "~QScriptValueIterator",	//317
    "~QScriptable",	//318
};

// (classId, name (index in methodNames), argumentList index, number of args, method flags, return type (index in types), xcall() index)
static Smoke::Method qtscript_methods[] = {
	{4, 156, 0, 0, Smoke::mf_const, 82, -1},	//0 QFactoryInterface::keys() const [pure virtual]
	{6, 160, 0, 0, Smoke::mf_const, 126, 1},	//1 QObject::metaObject() const
	{6, 227, 150, 3, 0, 139, 2},	//2 QObject::qt_metacall(QMetaObject::Call, int, void**)
	{6, 104, 145, 1, 0, 121, 5},	//3 QObject::event(QEvent*)
	{6, 106, 156, 2, 0, 121, 6},	//4 QObject::eventFilter(QObject*, QEvent*)
	{6, 282, 13, 1, Smoke::mf_protected, 0, 48},	//5 QObject::timerEvent(QTimerEvent*)
	{6, 76, 219, 1, Smoke::mf_protected, 0, 49},	//6 QObject::childEvent(QChildEvent*)
	{6, 90, 145, 1, Smoke::mf_protected, 0, 50},	//7 QObject::customEvent(QEvent*)
	{6, 81, 101, 1, Smoke::mf_protected, 0, 51},	//8 QObject::connectNotify(const char*)
	{6, 95, 101, 1, Smoke::mf_protected, 0, 52},	//9 QObject::disconnectNotify(const char*)
	{8, 8, 0, 0, Smoke::mf_static|Smoke::mf_enum, 47, 0},	//10 QScriptClass::HandlesReadAccess (enum)
	{8, 9, 0, 0, Smoke::mf_static|Smoke::mf_enum, 47, 1},	//11 QScriptClass::HandlesWriteAccess (enum)
	{8, 3, 0, 0, Smoke::mf_static|Smoke::mf_enum, 46, 2},	//12 QScriptClass::Callable (enum)
	{8, 18, 179, 1, Smoke::mf_ctor, 45, 3},	//13 QScriptClass::QScriptClass(QScriptEngine*)
	{8, 309, 0, 0, Smoke::mf_dtor, 0, 16},	//14 QScriptClass::~QScriptClass()
	{8, 97, 0, 0, Smoke::mf_const, 58, 4},	//15 QScriptClass::engine() const
	{8, 229, 51, 4, 0, 48, 5},	//16 QScriptClass::queryProperty(const QScriptValue&, const QScriptString&, QScriptClass::QueryFlags, uint*)
	{8, 213, 47, 3, 0, 67, 6},	//17 QScriptClass::property(const QScriptValue&, const QScriptString&, uint)
	{8, 251, 214, 4, 0, 0, 7},	//18 QScriptClass::setProperty(QScriptValue&, const QScriptString&, uint, const QScriptValue&)
	{8, 219, 47, 3, 0, 71, 8},	//19 QScriptClass::propertyFlags(const QScriptValue&, const QScriptString&, uint)
	{8, 173, 42, 1, 0, 50, 9},	//20 QScriptClass::newIterator(const QScriptValue&)
	{8, 225, 0, 0, Smoke::mf_const, 67, 10},	//21 QScriptClass::prototype() const
	{8, 161, 0, 0, Smoke::mf_const, 80, 11},	//22 QScriptClass::name() const
	{8, 274, 171, 1, Smoke::mf_const, 121, 12},	//23 QScriptClass::supportsExtension(QScriptClass::Extension) const
	{8, 112, 173, 2, 0, 104, 13},	//24 QScriptClass::extension(QScriptClass::Extension, const QVariant&)
	{8, 112, 171, 1, 0, 104, 14},	//25 QScriptClass::extension(QScriptClass::Extension)
	{8, 18, 199, 2, Smoke::mf_ctor|Smoke::mf_protected, 45, 15},	//26 QScriptClass::QScriptClass(QScriptEngine*, QScriptClassPrivate&)
	{9, 310, 0, 0, Smoke::mf_dtor, 0, 5},	//27 QScriptClassPropertyIterator::~QScriptClassPropertyIterator()
	{9, 196, 0, 0, Smoke::mf_const, 67, 0},	//28 QScriptClassPropertyIterator::object() const
	{9, 128, 0, 0, Smoke::mf_const, 121, -1},	//29 QScriptClassPropertyIterator::hasNext() const [pure virtual]
	{9, 194, 0, 0, 0, 0, -1},	//30 QScriptClassPropertyIterator::next() [pure virtual]
	{9, 129, 0, 0, Smoke::mf_const, 121, -1},	//31 QScriptClassPropertyIterator::hasPrevious() const [pure virtual]
	{9, 211, 0, 0, 0, 0, -1},	//32 QScriptClassPropertyIterator::previous() [pure virtual]
	{9, 287, 0, 0, 0, 0, -1},	//33 QScriptClassPropertyIterator::toFront() [pure virtual]
	{9, 284, 0, 0, 0, 0, -1},	//34 QScriptClassPropertyIterator::toBack() [pure virtual]
	{9, 161, 0, 0, Smoke::mf_const, 64, -1},	//35 QScriptClassPropertyIterator::name() const [pure virtual]
	{9, 131, 0, 0, Smoke::mf_const, 141, 1},	//36 QScriptClassPropertyIterator::id() const
	{9, 116, 0, 0, Smoke::mf_const, 71, 2},	//37 QScriptClassPropertyIterator::flags() const
	{9, 21, 42, 1, Smoke::mf_ctor|Smoke::mf_protected, 50, 3},	//38 QScriptClassPropertyIterator::QScriptClassPropertyIterator(const QScriptValue&)
	{9, 21, 74, 2, Smoke::mf_ctor|Smoke::mf_protected, 50, 4},	//39 QScriptClassPropertyIterator::QScriptClassPropertyIterator(const QScriptValue&, QScriptClassPropertyIteratorPrivate&)
	{10, 12, 0, 0, Smoke::mf_static|Smoke::mf_enum, 54, 0},	//40 QScriptContext::NormalState (enum)
	{10, 4, 0, 0, Smoke::mf_static|Smoke::mf_enum, 54, 1},	//41 QScriptContext::ExceptionState (enum)
	{10, 57, 0, 0, Smoke::mf_static|Smoke::mf_enum, 53, 2},	//42 QScriptContext::UnknownError (enum)
	{10, 43, 0, 0, Smoke::mf_static|Smoke::mf_enum, 53, 3},	//43 QScriptContext::ReferenceError (enum)
	{10, 52, 0, 0, Smoke::mf_static|Smoke::mf_enum, 53, 4},	//44 QScriptContext::SyntaxError (enum)
	{10, 53, 0, 0, Smoke::mf_static|Smoke::mf_enum, 53, 5},	//45 QScriptContext::TypeError (enum)
	{10, 41, 0, 0, Smoke::mf_static|Smoke::mf_enum, 53, 6},	//46 QScriptContext::RangeError (enum)
	{10, 54, 0, 0, Smoke::mf_static|Smoke::mf_enum, 53, 7},	//47 QScriptContext::URIError (enum)
	{10, 207, 0, 0, Smoke::mf_const, 52, 8},	//48 QScriptContext::parentContext() const
	{10, 97, 0, 0, Smoke::mf_const, 58, 9},	//49 QScriptContext::engine() const
	{10, 271, 0, 0, Smoke::mf_const, 54, 10},	//50 QScriptContext::state() const
	{10, 73, 0, 0, Smoke::mf_const, 67, 11},	//51 QScriptContext::callee() const
	{10, 65, 0, 0, Smoke::mf_const, 139, 12},	//52 QScriptContext::argumentCount() const
	{10, 63, 108, 1, Smoke::mf_const, 67, 13},	//53 QScriptContext::argument(int) const
	{10, 66, 0, 0, Smoke::mf_const, 67, 14},	//54 QScriptContext::argumentsObject() const
	{10, 232, 0, 0, Smoke::mf_const, 67, 15},	//55 QScriptContext::returnValue() const
	{10, 259, 42, 1, 0, 0, 16},	//56 QScriptContext::setReturnValue(const QScriptValue&)
	{10, 61, 0, 0, Smoke::mf_const, 67, 17},	//57 QScriptContext::activationObject() const
	{10, 241, 42, 1, 0, 0, 18},	//58 QScriptContext::setActivationObject(const QScriptValue&)
	{10, 276, 0, 0, Smoke::mf_const, 67, 19},	//59 QScriptContext::thisObject() const
	{10, 265, 42, 1, 0, 0, 20},	//60 QScriptContext::setThisObject(const QScriptValue&)
	{10, 141, 0, 0, Smoke::mf_const, 121, 21},	//61 QScriptContext::isCalledAsConstructor() const
	{10, 280, 42, 1, 0, 67, 22},	//62 QScriptContext::throwValue(const QScriptValue&)
	{10, 277, 176, 2, 0, 67, 23},	//63 QScriptContext::throwError(QScriptContext::Error, const QString&)
	{10, 277, 77, 1, 0, 67, 24},	//64 QScriptContext::throwError(const QString&)
	{10, 68, 0, 0, Smoke::mf_const, 82, 25},	//65 QScriptContext::backtrace() const
	{10, 295, 0, 0, Smoke::mf_const, 80, 26},	//66 QScriptContext::toString() const
	{11, 48, 0, 0, Smoke::mf_static|Smoke::mf_enum, 57, 0},	//67 QScriptContextInfo::ScriptFunction (enum)
	{11, 38, 0, 0, Smoke::mf_static|Smoke::mf_enum, 57, 1},	//68 QScriptContextInfo::QtFunction (enum)
	{11, 40, 0, 0, Smoke::mf_static|Smoke::mf_enum, 57, 2},	//69 QScriptContextInfo::QtPropertyFunction (enum)
	{11, 11, 0, 0, Smoke::mf_static|Smoke::mf_enum, 57, 3},	//70 QScriptContextInfo::NativeFunction (enum)
	{11, 24, 26, 1, Smoke::mf_ctor, 56, 4},	//71 QScriptContextInfo::QScriptContextInfo(const QScriptContext*)
	{11, 24, 28, 1, Smoke::mf_copyctor|Smoke::mf_ctor, 56, 5},	//72 QScriptContextInfo::QScriptContextInfo(const QScriptContextInfo&)
	{11, 24, 0, 0, Smoke::mf_ctor, 56, 6},	//73 QScriptContextInfo::QScriptContextInfo()
	{11, 312, 0, 0, Smoke::mf_dtor, 0, 21},	//74 QScriptContextInfo::~QScriptContextInfo()
	{11, 203, 28, 1, 0, 55, 7},	//75 QScriptContextInfo::operator=(const QScriptContextInfo&)
	{11, 146, 0, 0, Smoke::mf_const, 121, 8},	//76 QScriptContextInfo::isNull() const
	{11, 235, 0, 0, Smoke::mf_const, 140, 9},	//77 QScriptContextInfo::scriptId() const
	{11, 115, 0, 0, Smoke::mf_const, 80, 10},	//78 QScriptContextInfo::fileName() const
	{11, 159, 0, 0, Smoke::mf_const, 139, 11},	//79 QScriptContextInfo::lineNumber() const
	{11, 80, 0, 0, Smoke::mf_const, 139, 12},	//80 QScriptContextInfo::columnNumber() const
	{11, 123, 0, 0, Smoke::mf_const, 80, 13},	//81 QScriptContextInfo::functionName() const
	{11, 126, 0, 0, Smoke::mf_const, 57, 14},	//82 QScriptContextInfo::functionType() const
	{11, 124, 0, 0, Smoke::mf_const, 82, 15},	//83 QScriptContextInfo::functionParameterNames() const
	{11, 125, 0, 0, Smoke::mf_const, 139, 16},	//84 QScriptContextInfo::functionStartLineNumber() const
	{11, 117, 0, 0, Smoke::mf_const, 139, 17},	//85 QScriptContextInfo::functionEndLineNumber() const
	{11, 122, 0, 0, Smoke::mf_const, 139, 18},	//86 QScriptContextInfo::functionMetaIndex() const
	{11, 205, 28, 1, Smoke::mf_const, 121, 19},	//87 QScriptContextInfo::operator==(const QScriptContextInfo&) const
	{11, 201, 28, 1, Smoke::mf_const, 121, 20},	//88 QScriptContextInfo::operator!=(const QScriptContextInfo&) const
	{12, 39, 0, 0, Smoke::mf_static|Smoke::mf_enum, 61, 0},	//89 QScriptEngine::QtOwnership (enum)
	{12, 49, 0, 0, Smoke::mf_static|Smoke::mf_enum, 61, 1},	//90 QScriptEngine::ScriptOwnership (enum)
	{12, 2, 0, 0, Smoke::mf_static|Smoke::mf_enum, 61, 2},	//91 QScriptEngine::AutoOwnership (enum)
	{12, 5, 0, 0, Smoke::mf_static|Smoke::mf_enum, 59, 3},	//92 QScriptEngine::ExcludeChildObjects (enum)
	{12, 6, 0, 0, Smoke::mf_static|Smoke::mf_enum, 59, 4},	//93 QScriptEngine::ExcludeSuperClassMethods (enum)
	{12, 7, 0, 0, Smoke::mf_static|Smoke::mf_enum, 59, 5},	//94 QScriptEngine::ExcludeSuperClassProperties (enum)
	{12, 51, 0, 0, Smoke::mf_static|Smoke::mf_enum, 59, 6},	//95 QScriptEngine::SkipMethodsInEnumeration (enum)
	{12, 1, 0, 0, Smoke::mf_static|Smoke::mf_enum, 59, 7},	//96 QScriptEngine::AutoCreateDynamicProperties (enum)
	{12, 14, 0, 0, Smoke::mf_static|Smoke::mf_enum, 59, 8},	//97 QScriptEngine::PreferExistingWrapperObject (enum)
	{12, 160, 0, 0, Smoke::mf_const, 126, 9},	//98 QScriptEngine::metaObject() const
	{12, 227, 150, 3, 0, 139, 10},	//99 QScriptEngine::qt_metacall(QMetaObject::Call, int, void**)
	{12, 26, 0, 0, Smoke::mf_ctor, 58, 11},	//100 QScriptEngine::QScriptEngine()
	{12, 26, 154, 1, Smoke::mf_ctor, 58, 12},	//101 QScriptEngine::QScriptEngine(QObject*)
	{12, 313, 0, 0, Smoke::mf_dtor, 0, 71},	//102 QScriptEngine::~QScriptEngine()
	{12, 127, 0, 0, Smoke::mf_const, 67, 13},	//103 QScriptEngine::globalObject() const
	{12, 89, 0, 0, Smoke::mf_const, 52, 14},	//104 QScriptEngine::currentContext() const
	{12, 226, 0, 0, 0, 52, 15},	//105 QScriptEngine::pushContext()
	{12, 208, 0, 0, 0, 0, 16},	//106 QScriptEngine::popContext()
	{12, 74, 77, 1, Smoke::mf_const, 121, 17},	//107 QScriptEngine::canEvaluate(const QString&) const
	{12, 100, 92, 3, 0, 67, 18},	//108 QScriptEngine::evaluate(const QString&, const QString&, int)
	{12, 100, 89, 2, 0, 67, 19},	//109 QScriptEngine::evaluate(const QString&, const QString&)
	{12, 100, 77, 1, 0, 67, 20},	//110 QScriptEngine::evaluate(const QString&)
	{12, 144, 0, 0, Smoke::mf_const, 121, 21},	//111 QScriptEngine::isEvaluating() const
	{12, 59, 42, 1, 0, 0, 22},	//112 QScriptEngine::abortEvaluation(const QScriptValue&)
	{12, 59, 0, 0, 0, 0, 23},	//113 QScriptEngine::abortEvaluation()
	{12, 130, 0, 0, Smoke::mf_const, 121, 24},	//114 QScriptEngine::hasUncaughtException() const
	{12, 304, 0, 0, Smoke::mf_const, 67, 25},	//115 QScriptEngine::uncaughtException() const
	{12, 306, 0, 0, Smoke::mf_const, 139, 26},	//116 QScriptEngine::uncaughtExceptionLineNumber() const
	{12, 305, 0, 0, Smoke::mf_const, 82, 27},	//117 QScriptEngine::uncaughtExceptionBacktrace() const
	{12, 78, 0, 0, 0, 0, 28},	//118 QScriptEngine::clearExceptions()
	{12, 195, 0, 0, 0, 67, 29},	//119 QScriptEngine::nullValue()
	{12, 307, 0, 0, 0, 67, 30},	//120 QScriptEngine::undefinedValue()
	{12, 168, 10, 2, 0, 67, 31},	//121 QScriptEngine::newFunction(FunctionSignature, int)
	{12, 168, 1, 1, 0, 67, 32},	//122 QScriptEngine::newFunction(FunctionSignature)
	{12, 168, 6, 3, 0, 67, 33},	//123 QScriptEngine::newFunction(FunctionSignature, const QScriptValue&, int)
	{12, 168, 3, 2, 0, 67, 34},	//124 QScriptEngine::newFunction(FunctionSignature, const QScriptValue&)
	{12, 168, 147, 2, 0, 67, 35},	//125 QScriptEngine::newFunction(FunctionWithArgSignature, void*)
	{12, 191, 99, 1, 0, 67, 36},	//126 QScriptEngine::newVariant(const QVariant&)
	{12, 191, 59, 2, 0, 67, 37},	//127 QScriptEngine::newVariant(const QScriptValue&, const QVariant&)
	{12, 188, 24, 1, 0, 67, 38},	//128 QScriptEngine::newRegExp(const QRegExp&)
	{12, 175, 0, 0, 0, 67, 39},	//129 QScriptEngine::newObject()
	{12, 175, 168, 2, 0, 67, 40},	//130 QScriptEngine::newObject(QScriptClass*, const QScriptValue&)
	{12, 175, 166, 1, 0, 67, 41},	//131 QScriptEngine::newObject(QScriptClass*)
	{12, 163, 131, 1, 0, 67, 42},	//132 QScriptEngine::newArray(uint)
	{12, 163, 0, 0, 0, 67, 43},	//133 QScriptEngine::newArray()
	{12, 188, 89, 2, 0, 67, 44},	//134 QScriptEngine::newRegExp(const QString&, const QString&)
	{12, 165, 106, 1, 0, 67, 45},	//135 QScriptEngine::newDate(double)
	{12, 165, 15, 1, 0, 67, 46},	//136 QScriptEngine::newDate(const QDateTime&)
	{12, 162, 0, 0, 0, 67, 47},	//137 QScriptEngine::newActivationObject()
	{12, 181, 162, 3, 0, 67, 48},	//138 QScriptEngine::newQObject(QObject*, QScriptEngine::ValueOwnership, const QScriptEngine::QObjectWrapOptions&)
	{12, 181, 159, 2, 0, 67, 49},	//139 QScriptEngine::newQObject(QObject*, QScriptEngine::ValueOwnership)
	{12, 181, 154, 1, 0, 67, 50},	//140 QScriptEngine::newQObject(QObject*)
	{12, 181, 69, 4, 0, 67, 51},	//141 QScriptEngine::newQObject(const QScriptValue&, QObject*, QScriptEngine::ValueOwnership, const QScriptEngine::QObjectWrapOptions&)
	{12, 181, 65, 3, 0, 67, 52},	//142 QScriptEngine::newQObject(const QScriptValue&, QObject*, QScriptEngine::ValueOwnership)
	{12, 181, 62, 2, 0, 67, 53},	//143 QScriptEngine::newQObject(const QScriptValue&, QObject*)
	{12, 178, 21, 2, 0, 67, 54},	//144 QScriptEngine::newQMetaObject(const QMetaObject*, const QScriptValue&)
	{12, 178, 19, 1, 0, 67, 55},	//145 QScriptEngine::newQMetaObject(const QMetaObject*)
	{12, 93, 108, 1, Smoke::mf_const, 67, 56},	//146 QScriptEngine::defaultPrototype(int) const
	{12, 247, 110, 2, 0, 0, 57},	//147 QScriptEngine::setDefaultPrototype(int, const QScriptValue&)
	{12, 132, 77, 1, 0, 67, 58},	//148 QScriptEngine::importExtension(const QString&)
	{12, 67, 0, 0, Smoke::mf_const, 82, 59},	//149 QScriptEngine::availableExtensions() const
	{12, 134, 0, 0, Smoke::mf_const, 82, 60},	//150 QScriptEngine::importedExtensions() const
	{12, 79, 0, 0, 0, 0, 61},	//151 QScriptEngine::collectGarbage()
	{12, 249, 108, 1, 0, 0, 62},	//152 QScriptEngine::setProcessEventsInterval(int)
	{12, 212, 0, 0, Smoke::mf_const, 139, 63},	//153 QScriptEngine::processEventsInterval() const
	{12, 243, 205, 1, 0, 0, 64},	//154 QScriptEngine::setAgent(QScriptEngineAgent*)
	{12, 62, 0, 0, Smoke::mf_const, 62, 65},	//155 QScriptEngine::agent() const
	{12, 296, 77, 1, 0, 64, 66},	//156 QScriptEngine::toStringHandle(const QString&)
	{12, 197, 113, 1, Smoke::mf_const, 67, 67},	//157 QScriptEngine::objectById(qint64) const
	{12, 269, 42, 1, 0, 0, 68},	//158 QScriptEngine::signalHandlerException(const QScriptValue&)
	{12, 301, 103, 2, Smoke::mf_static, 80, 69},	//159 QScriptEngine::tr(const char*, const char*)
	{12, 301, 101, 1, Smoke::mf_static, 80, 70},	//160 QScriptEngine::tr(const char*)
	{13, 28, 179, 1, Smoke::mf_ctor, 62, 0},	//161 QScriptEngineAgent::QScriptEngineAgent(QScriptEngine*)
	{13, 314, 0, 0, Smoke::mf_dtor, 0, 14},	//162 QScriptEngineAgent::~QScriptEngineAgent()
	{13, 236, 122, 4, 0, 0, 1},	//163 QScriptEngineAgent::scriptLoad(qint64, const QString&, const QString&, int)
	{13, 239, 113, 1, 0, 0, 2},	//164 QScriptEngineAgent::scriptUnload(qint64)
	{13, 88, 0, 0, 0, 0, 3},	//165 QScriptEngineAgent::contextPush()
	{13, 87, 0, 0, 0, 0, 4},	//166 QScriptEngineAgent::contextPop()
	{13, 118, 113, 1, 0, 0, 5},	//167 QScriptEngineAgent::functionEntry(qint64)
	{13, 120, 115, 2, 0, 0, 6},	//168 QScriptEngineAgent::functionExit(qint64, const QScriptValue&)
	{13, 209, 127, 3, 0, 0, 7},	//169 QScriptEngineAgent::positionChange(qint64, int, int)
	{13, 110, 118, 3, 0, 0, 8},	//170 QScriptEngineAgent::exceptionThrow(qint64, const QScriptValue&, bool)
	{13, 108, 115, 2, 0, 0, 9},	//171 QScriptEngineAgent::exceptionCatch(qint64, const QScriptValue&)
	{13, 274, 207, 1, Smoke::mf_const, 121, 10},	//172 QScriptEngineAgent::supportsExtension(QScriptEngineAgent::Extension) const
	{13, 112, 209, 2, 0, 104, 11},	//173 QScriptEngineAgent::extension(QScriptEngineAgent::Extension, const QVariant&)
	{13, 112, 207, 1, 0, 104, 12},	//174 QScriptEngineAgent::extension(QScriptEngineAgent::Extension)
	{13, 97, 0, 0, Smoke::mf_const, 58, 13},	//175 QScriptEngineAgent::engine() const
	{14, 135, 96, 2, 0, 0, -1},	//176 QScriptExtensionInterface::initialize(const QString&, QScriptEngine*) [pure virtual]
	{15, 160, 0, 0, Smoke::mf_const, 126, 0},	//177 QScriptExtensionPlugin::metaObject() const
	{15, 227, 150, 3, 0, 139, 1},	//178 QScriptExtensionPlugin::qt_metacall(QMetaObject::Call, int, void**)
	{15, 301, 103, 2, Smoke::mf_static, 80, 2},	//179 QScriptExtensionPlugin::tr(const char*, const char*)
	{15, 301, 101, 1, Smoke::mf_static, 80, 3},	//180 QScriptExtensionPlugin::tr(const char*)
	{16, 30, 0, 0, Smoke::mf_ctor, 66, 0},	//181 QScriptString::QScriptString()
	{16, 30, 30, 1, Smoke::mf_copyctor|Smoke::mf_ctor, 66, 1},	//182 QScriptString::QScriptString(const QScriptString&)
	{16, 315, 0, 0, Smoke::mf_dtor, 0, 8},	//183 QScriptString::~QScriptString()
	{16, 203, 30, 1, 0, 65, 2},	//184 QScriptString::operator=(const QScriptString&)
	{16, 154, 0, 0, Smoke::mf_const, 121, 3},	//185 QScriptString::isValid() const
	{16, 205, 30, 1, Smoke::mf_const, 121, 4},	//186 QScriptString::operator==(const QScriptString&) const
	{16, 201, 30, 1, Smoke::mf_const, 121, 5},	//187 QScriptString::operator!=(const QScriptString&) const
	{16, 295, 0, 0, Smoke::mf_const, 80, 6},	//188 QScriptString::toString() const
	{16, 200, 0, 0, Smoke::mf_const, 0, 7},	//189 QScriptString::operator QString() const
	{17, 45, 0, 0, Smoke::mf_static|Smoke::mf_enum, 72, 0},	//190 QScriptValue::ResolveLocal (enum)
	{17, 46, 0, 0, Smoke::mf_static|Smoke::mf_enum, 72, 1},	//191 QScriptValue::ResolvePrototype (enum)
	{17, 47, 0, 0, Smoke::mf_static|Smoke::mf_enum, 72, 2},	//192 QScriptValue::ResolveScope (enum)
	{17, 44, 0, 0, Smoke::mf_static|Smoke::mf_enum, 72, 3},	//193 QScriptValue::ResolveFull (enum)
	{17, 42, 0, 0, Smoke::mf_static|Smoke::mf_enum, 70, 4},	//194 QScriptValue::ReadOnly (enum)
	{17, 56, 0, 0, Smoke::mf_static|Smoke::mf_enum, 70, 5},	//195 QScriptValue::Undeletable (enum)
	{17, 50, 0, 0, Smoke::mf_static|Smoke::mf_enum, 70, 6},	//196 QScriptValue::SkipInEnumeration (enum)
	{17, 15, 0, 0, Smoke::mf_static|Smoke::mf_enum, 70, 7},	//197 QScriptValue::PropertyGetter (enum)
	{17, 16, 0, 0, Smoke::mf_static|Smoke::mf_enum, 70, 8},	//198 QScriptValue::PropertySetter (enum)
	{17, 17, 0, 0, Smoke::mf_static|Smoke::mf_enum, 70, 9},	//199 QScriptValue::QObjectMember (enum)
	{17, 10, 0, 0, Smoke::mf_static|Smoke::mf_enum, 70, 10},	//200 QScriptValue::KeepExistingFlags (enum)
	{17, 58, 0, 0, Smoke::mf_static|Smoke::mf_enum, 70, 11},	//201 QScriptValue::UserRange (enum)
	{17, 13, 0, 0, Smoke::mf_static|Smoke::mf_enum, 74, 12},	//202 QScriptValue::NullValue (enum)
	{17, 55, 0, 0, Smoke::mf_static|Smoke::mf_enum, 74, 13},	//203 QScriptValue::UndefinedValue (enum)
	{17, 32, 0, 0, Smoke::mf_ctor, 69, 14},	//204 QScriptValue::QScriptValue()
	{17, 316, 0, 0, Smoke::mf_dtor, 0, 89},	//205 QScriptValue::~QScriptValue()
	{17, 32, 42, 1, Smoke::mf_copyctor|Smoke::mf_ctor, 69, 15},	//206 QScriptValue::QScriptValue(const QScriptValue&)
	{17, 32, 202, 2, Smoke::mf_ctor, 69, 16},	//207 QScriptValue::QScriptValue(QScriptEngine*, QScriptValue::SpecialValue)
	{17, 32, 181, 2, Smoke::mf_ctor, 69, 17},	//208 QScriptValue::QScriptValue(QScriptEngine*, bool)
	{17, 32, 193, 2, Smoke::mf_ctor, 69, 18},	//209 QScriptValue::QScriptValue(QScriptEngine*, int)
	{17, 32, 196, 2, Smoke::mf_ctor, 69, 19},	//210 QScriptValue::QScriptValue(QScriptEngine*, uint)
	{17, 32, 190, 2, Smoke::mf_ctor, 69, 20},	//211 QScriptValue::QScriptValue(QScriptEngine*, double)
	{17, 32, 184, 2, Smoke::mf_ctor, 69, 21},	//212 QScriptValue::QScriptValue(QScriptEngine*, const QString&)
	{17, 32, 187, 2, Smoke::mf_ctor, 69, 22},	//213 QScriptValue::QScriptValue(QScriptEngine*, const char*)
	{17, 203, 42, 1, 0, 68, 23},	//214 QScriptValue::operator=(const QScriptValue&)
	{17, 97, 0, 0, Smoke::mf_const, 58, 24},	//215 QScriptValue::engine() const
	{17, 154, 0, 0, Smoke::mf_const, 121, 25},	//216 QScriptValue::isValid() const
	{17, 140, 0, 0, Smoke::mf_const, 121, 26},	//217 QScriptValue::isBoolean() const
	{17, 147, 0, 0, Smoke::mf_const, 121, 27},	//218 QScriptValue::isNumber() const
	{17, 145, 0, 0, Smoke::mf_const, 121, 28},	//219 QScriptValue::isFunction() const
	{17, 146, 0, 0, Smoke::mf_const, 121, 29},	//220 QScriptValue::isNull() const
	{17, 152, 0, 0, Smoke::mf_const, 121, 30},	//221 QScriptValue::isString() const
	{17, 153, 0, 0, Smoke::mf_const, 121, 31},	//222 QScriptValue::isUndefined() const
	{17, 155, 0, 0, Smoke::mf_const, 121, 32},	//223 QScriptValue::isVariant() const
	{17, 150, 0, 0, Smoke::mf_const, 121, 33},	//224 QScriptValue::isQObject() const
	{17, 149, 0, 0, Smoke::mf_const, 121, 34},	//225 QScriptValue::isQMetaObject() const
	{17, 148, 0, 0, Smoke::mf_const, 121, 35},	//226 QScriptValue::isObject() const
	{17, 142, 0, 0, Smoke::mf_const, 121, 36},	//227 QScriptValue::isDate() const
	{17, 151, 0, 0, Smoke::mf_const, 121, 37},	//228 QScriptValue::isRegExp() const
	{17, 139, 0, 0, Smoke::mf_const, 121, 38},	//229 QScriptValue::isArray() const
	{17, 143, 0, 0, Smoke::mf_const, 121, 39},	//230 QScriptValue::isError() const
	{17, 295, 0, 0, Smoke::mf_const, 80, 40},	//231 QScriptValue::toString() const
	{17, 290, 0, 0, Smoke::mf_const, 138, 41},	//232 QScriptValue::toNumber() const
	{17, 285, 0, 0, Smoke::mf_const, 121, 42},	//233 QScriptValue::toBoolean() const
	{17, 289, 0, 0, Smoke::mf_const, 138, 43},	//234 QScriptValue::toInteger() const
	{17, 288, 0, 0, Smoke::mf_const, 139, 44},	//235 QScriptValue::toInt32() const
	{17, 299, 0, 0, Smoke::mf_const, 143, 45},	//236 QScriptValue::toUInt32() const
	{17, 298, 0, 0, Smoke::mf_const, 144, 46},	//237 QScriptValue::toUInt16() const
	{17, 300, 0, 0, Smoke::mf_const, 104, 47},	//238 QScriptValue::toVariant() const
	{17, 293, 0, 0, Smoke::mf_const, 39, 48},	//239 QScriptValue::toQObject() const
	{17, 292, 0, 0, Smoke::mf_const, 126, 49},	//240 QScriptValue::toQMetaObject() const
	{17, 291, 0, 0, Smoke::mf_const, 67, 50},	//241 QScriptValue::toObject() const
	{17, 286, 0, 0, Smoke::mf_const, 11, 51},	//242 QScriptValue::toDateTime() const
	{17, 294, 0, 0, Smoke::mf_const, 44, 52},	//243 QScriptValue::toRegExp() const
	{17, 137, 42, 1, Smoke::mf_const, 121, 53},	//244 QScriptValue::instanceOf(const QScriptValue&) const
	{17, 157, 42, 1, Smoke::mf_const, 121, 54},	//245 QScriptValue::lessThan(const QScriptValue&) const
	{17, 98, 42, 1, Smoke::mf_const, 121, 55},	//246 QScriptValue::equals(const QScriptValue&) const
	{17, 272, 42, 1, Smoke::mf_const, 121, 56},	//247 QScriptValue::strictlyEquals(const QScriptValue&) const
	{17, 225, 0, 0, Smoke::mf_const, 67, 57},	//248 QScriptValue::prototype() const
	{17, 257, 42, 1, 0, 0, 58},	//249 QScriptValue::setPrototype(const QScriptValue&)
	{17, 233, 0, 0, Smoke::mf_const, 67, 59},	//250 QScriptValue::scope() const
	{17, 261, 42, 1, 0, 0, 60},	//251 QScriptValue::setScope(const QScriptValue&)
	{17, 213, 86, 2, Smoke::mf_const, 67, 61},	//252 QScriptValue::property(const QString&, const QScriptValue::ResolveFlags&) const
	{17, 213, 77, 1, Smoke::mf_const, 67, 62},	//253 QScriptValue::property(const QString&) const
	{17, 251, 82, 3, 0, 0, 63},	//254 QScriptValue::setProperty(const QString&, const QScriptValue&, const QScriptValue::PropertyFlags&)
	{17, 251, 79, 2, 0, 0, 64},	//255 QScriptValue::setProperty(const QString&, const QScriptValue&)
	{17, 213, 142, 2, Smoke::mf_const, 67, 65},	//256 QScriptValue::property(unsigned int, const QScriptValue::ResolveFlags&) const
	{17, 213, 133, 1, Smoke::mf_const, 67, 66},	//257 QScriptValue::property(unsigned int) const
	{17, 251, 138, 3, 0, 0, 67},	//258 QScriptValue::setProperty(unsigned int, const QScriptValue&, const QScriptValue::PropertyFlags&)
	{17, 251, 135, 2, 0, 0, 68},	//259 QScriptValue::setProperty(unsigned int, const QScriptValue&)
	{17, 213, 39, 2, Smoke::mf_const, 67, 69},	//260 QScriptValue::property(const QScriptString&, const QScriptValue::ResolveFlags&) const
	{17, 213, 30, 1, Smoke::mf_const, 67, 70},	//261 QScriptValue::property(const QScriptString&) const
	{17, 251, 35, 3, 0, 0, 71},	//262 QScriptValue::setProperty(const QScriptString&, const QScriptValue&, const QScriptValue::PropertyFlags&)
	{17, 251, 32, 2, 0, 0, 72},	//263 QScriptValue::setProperty(const QScriptString&, const QScriptValue&)
	{17, 219, 86, 2, Smoke::mf_const, 71, 73},	//264 QScriptValue::propertyFlags(const QString&, const QScriptValue::ResolveFlags&) const
	{17, 219, 77, 1, Smoke::mf_const, 71, 74},	//265 QScriptValue::propertyFlags(const QString&) const
	{17, 219, 39, 2, Smoke::mf_const, 71, 75},	//266 QScriptValue::propertyFlags(const QScriptString&, const QScriptValue::ResolveFlags&) const
	{17, 219, 30, 1, Smoke::mf_const, 71, 76},	//267 QScriptValue::propertyFlags(const QScriptString&) const
	{17, 69, 44, 2, 0, 67, 77},	//268 QScriptValue::call(const QScriptValue&, const QList<QScriptValue>&)
	{17, 69, 42, 1, 0, 67, 78},	//269 QScriptValue::call(const QScriptValue&)
	{17, 69, 0, 0, 0, 67, 79},	//270 QScriptValue::call()
	{17, 69, 56, 2, 0, 67, 80},	//271 QScriptValue::call(const QScriptValue&, const QScriptValue&)
	{17, 83, 17, 1, 0, 67, 81},	//272 QScriptValue::construct(const QList<QScriptValue>&)
	{17, 83, 0, 0, 0, 67, 82},	//273 QScriptValue::construct()
	{17, 83, 42, 1, 0, 67, 83},	//274 QScriptValue::construct(const QScriptValue&)
	{17, 92, 0, 0, Smoke::mf_const, 67, 84},	//275 QScriptValue::data() const
	{17, 245, 42, 1, 0, 0, 85},	//276 QScriptValue::setData(const QScriptValue&)
	{17, 234, 0, 0, Smoke::mf_const, 45, 86},	//277 QScriptValue::scriptClass() const
	{17, 263, 166, 1, 0, 0, 87},	//278 QScriptValue::setScriptClass(QScriptClass*)
	{17, 199, 0, 0, Smoke::mf_const, 140, 88},	//279 QScriptValue::objectId() const
	{18, 35, 42, 1, Smoke::mf_ctor, 76, 0},	//280 QScriptValueIterator::QScriptValueIterator(const QScriptValue&)
	{18, 317, 0, 0, Smoke::mf_dtor, 0, 14},	//281 QScriptValueIterator::~QScriptValueIterator()
	{18, 128, 0, 0, Smoke::mf_const, 121, 1},	//282 QScriptValueIterator::hasNext() const
	{18, 194, 0, 0, 0, 0, 2},	//283 QScriptValueIterator::next()
	{18, 129, 0, 0, Smoke::mf_const, 121, 3},	//284 QScriptValueIterator::hasPrevious() const
	{18, 211, 0, 0, 0, 0, 4},	//285 QScriptValueIterator::previous()
	{18, 161, 0, 0, Smoke::mf_const, 80, 5},	//286 QScriptValueIterator::name() const
	{18, 238, 0, 0, Smoke::mf_const, 64, 6},	//287 QScriptValueIterator::scriptName() const
	{18, 308, 0, 0, Smoke::mf_const, 67, 7},	//288 QScriptValueIterator::value() const
	{18, 267, 42, 1, 0, 0, 8},	//289 QScriptValueIterator::setValue(const QScriptValue&)
	{18, 116, 0, 0, Smoke::mf_const, 71, 9},	//290 QScriptValueIterator::flags() const
	{18, 231, 0, 0, 0, 0, 10},	//291 QScriptValueIterator::remove()
	{18, 287, 0, 0, 0, 0, 11},	//292 QScriptValueIterator::toFront()
	{18, 284, 0, 0, 0, 0, 12},	//293 QScriptValueIterator::toBack()
	{18, 203, 212, 1, 0, 75, 13},	//294 QScriptValueIterator::operator=(QScriptValue&)
	{19, 37, 0, 0, Smoke::mf_ctor, 77, 0},	//295 QScriptable::QScriptable()
	{19, 318, 0, 0, Smoke::mf_dtor, 0, 6},	//296 QScriptable::~QScriptable()
	{19, 97, 0, 0, Smoke::mf_const, 58, 1},	//297 QScriptable::engine() const
	{19, 86, 0, 0, Smoke::mf_const, 52, 2},	//298 QScriptable::context() const
	{19, 276, 0, 0, Smoke::mf_const, 67, 3},	//299 QScriptable::thisObject() const
	{19, 65, 0, 0, Smoke::mf_const, 139, 4},	//300 QScriptable::argumentCount() const
	{19, 63, 108, 1, Smoke::mf_const, 67, 5},	//301 QScriptable::argument(int) const
};

// Class ID, munged name ID (index into methodNames), method def (see methods) if >0 or number of overloads if <0
static Smoke::MethodMap qtscript_methodMaps[] = {
	{ 0, 0, 0 },	//0 (no method)
	{8, 3, 12},	//1 QScriptClass::Callable
	{8, 8, 10},	//2 QScriptClass::HandlesReadAccess
	{8, 9, 11},	//3 QScriptClass::HandlesWriteAccess
	{8, 19, 13},	//4 QScriptClass::QScriptClass#
	{8, 20, 26},	//5 QScriptClass::QScriptClass#?
	{8, 97, 15},	//6 QScriptClass::engine
	{8, 113, 25},	//7 QScriptClass::extension$
	{8, 114, 24},	//8 QScriptClass::extension$#
	{8, 161, 22},	//9 QScriptClass::name
	{8, 174, 20},	//10 QScriptClass::newIterator#
	{8, 215, 17},	//11 QScriptClass::property##$
	{8, 221, 19},	//12 QScriptClass::propertyFlags##$
	{8, 225, 21},	//13 QScriptClass::prototype
	{8, 230, 16},	//14 QScriptClass::queryProperty##$$
	{8, 254, 18},	//15 QScriptClass::setProperty##$#
	{8, 275, 23},	//16 QScriptClass::supportsExtension$
	{8, 309, 14},	//17 QScriptClass::~QScriptClass
	{9, 22, 38},	//18 QScriptClassPropertyIterator::QScriptClassPropertyIterator#
	{9, 23, 39},	//19 QScriptClassPropertyIterator::QScriptClassPropertyIterator#?
	{9, 116, 37},	//20 QScriptClassPropertyIterator::flags
	{9, 128, 29},	//21 QScriptClassPropertyIterator::hasNext
	{9, 129, 31},	//22 QScriptClassPropertyIterator::hasPrevious
	{9, 131, 36},	//23 QScriptClassPropertyIterator::id
	{9, 161, 35},	//24 QScriptClassPropertyIterator::name
	{9, 194, 30},	//25 QScriptClassPropertyIterator::next
	{9, 196, 28},	//26 QScriptClassPropertyIterator::object
	{9, 211, 32},	//27 QScriptClassPropertyIterator::previous
	{9, 284, 34},	//28 QScriptClassPropertyIterator::toBack
	{9, 287, 33},	//29 QScriptClassPropertyIterator::toFront
	{9, 310, 27},	//30 QScriptClassPropertyIterator::~QScriptClassPropertyIterator
	{10, 4, 41},	//31 QScriptContext::ExceptionState
	{10, 12, 40},	//32 QScriptContext::NormalState
	{10, 41, 46},	//33 QScriptContext::RangeError
	{10, 43, 43},	//34 QScriptContext::ReferenceError
	{10, 52, 44},	//35 QScriptContext::SyntaxError
	{10, 53, 45},	//36 QScriptContext::TypeError
	{10, 54, 47},	//37 QScriptContext::URIError
	{10, 57, 42},	//38 QScriptContext::UnknownError
	{10, 61, 57},	//39 QScriptContext::activationObject
	{10, 64, 53},	//40 QScriptContext::argument$
	{10, 65, 52},	//41 QScriptContext::argumentCount
	{10, 66, 54},	//42 QScriptContext::argumentsObject
	{10, 68, 65},	//43 QScriptContext::backtrace
	{10, 73, 51},	//44 QScriptContext::callee
	{10, 97, 49},	//45 QScriptContext::engine
	{10, 141, 61},	//46 QScriptContext::isCalledAsConstructor
	{10, 207, 48},	//47 QScriptContext::parentContext
	{10, 232, 55},	//48 QScriptContext::returnValue
	{10, 242, 58},	//49 QScriptContext::setActivationObject#
	{10, 260, 56},	//50 QScriptContext::setReturnValue#
	{10, 266, 60},	//51 QScriptContext::setThisObject#
	{10, 271, 50},	//52 QScriptContext::state
	{10, 276, 59},	//53 QScriptContext::thisObject
	{10, 278, 64},	//54 QScriptContext::throwError$
	{10, 279, 63},	//55 QScriptContext::throwError$$
	{10, 281, 62},	//56 QScriptContext::throwValue#
	{10, 295, 66},	//57 QScriptContext::toString
	{11, 11, 70},	//58 QScriptContextInfo::NativeFunction
	{11, 24, 73},	//59 QScriptContextInfo::QScriptContextInfo
	{11, 25, -1},	//60 QScriptContextInfo::QScriptContextInfo#
	{11, 38, 68},	//61 QScriptContextInfo::QtFunction
	{11, 40, 69},	//62 QScriptContextInfo::QtPropertyFunction
	{11, 48, 67},	//63 QScriptContextInfo::ScriptFunction
	{11, 80, 80},	//64 QScriptContextInfo::columnNumber
	{11, 115, 78},	//65 QScriptContextInfo::fileName
	{11, 117, 85},	//66 QScriptContextInfo::functionEndLineNumber
	{11, 122, 86},	//67 QScriptContextInfo::functionMetaIndex
	{11, 123, 81},	//68 QScriptContextInfo::functionName
	{11, 124, 83},	//69 QScriptContextInfo::functionParameterNames
	{11, 125, 84},	//70 QScriptContextInfo::functionStartLineNumber
	{11, 126, 82},	//71 QScriptContextInfo::functionType
	{11, 146, 76},	//72 QScriptContextInfo::isNull
	{11, 159, 79},	//73 QScriptContextInfo::lineNumber
	{11, 202, 88},	//74 QScriptContextInfo::operator!=#
	{11, 204, 75},	//75 QScriptContextInfo::operator=#
	{11, 206, 87},	//76 QScriptContextInfo::operator==#
	{11, 235, 77},	//77 QScriptContextInfo::scriptId
	{11, 312, 74},	//78 QScriptContextInfo::~QScriptContextInfo
	{12, 1, 96},	//79 QScriptEngine::AutoCreateDynamicProperties
	{12, 2, 91},	//80 QScriptEngine::AutoOwnership
	{12, 5, 92},	//81 QScriptEngine::ExcludeChildObjects
	{12, 6, 93},	//82 QScriptEngine::ExcludeSuperClassMethods
	{12, 7, 94},	//83 QScriptEngine::ExcludeSuperClassProperties
	{12, 14, 97},	//84 QScriptEngine::PreferExistingWrapperObject
	{12, 26, 100},	//85 QScriptEngine::QScriptEngine
	{12, 27, 101},	//86 QScriptEngine::QScriptEngine#
	{12, 39, 89},	//87 QScriptEngine::QtOwnership
	{12, 49, 90},	//88 QScriptEngine::ScriptOwnership
	{12, 51, 95},	//89 QScriptEngine::SkipMethodsInEnumeration
	{12, 59, 113},	//90 QScriptEngine::abortEvaluation
	{12, 60, 112},	//91 QScriptEngine::abortEvaluation#
	{12, 62, 155},	//92 QScriptEngine::agent
	{12, 67, 149},	//93 QScriptEngine::availableExtensions
	{12, 75, 107},	//94 QScriptEngine::canEvaluate$
	{12, 78, 118},	//95 QScriptEngine::clearExceptions
	{12, 79, 151},	//96 QScriptEngine::collectGarbage
	{12, 89, 104},	//97 QScriptEngine::currentContext
	{12, 94, 146},	//98 QScriptEngine::defaultPrototype$
	{12, 101, 110},	//99 QScriptEngine::evaluate$
	{12, 102, 109},	//100 QScriptEngine::evaluate$$
	{12, 103, 108},	//101 QScriptEngine::evaluate$$$
	{12, 127, 103},	//102 QScriptEngine::globalObject
	{12, 130, 114},	//103 QScriptEngine::hasUncaughtException
	{12, 133, 148},	//104 QScriptEngine::importExtension$
	{12, 134, 150},	//105 QScriptEngine::importedExtensions
	{12, 144, 111},	//106 QScriptEngine::isEvaluating
	{12, 160, 98},	//107 QScriptEngine::metaObject
	{12, 162, 137},	//108 QScriptEngine::newActivationObject
	{12, 163, 133},	//109 QScriptEngine::newArray
	{12, 164, 132},	//110 QScriptEngine::newArray$
	{12, 166, 136},	//111 QScriptEngine::newDate#
	{12, 167, 135},	//112 QScriptEngine::newDate$
	{12, 169, 122},	//113 QScriptEngine::newFunction?
	{12, 170, 124},	//114 QScriptEngine::newFunction?#
	{12, 171, 123},	//115 QScriptEngine::newFunction?#$
	{12, 172, -4},	//116 QScriptEngine::newFunction?$
	{12, 175, 129},	//117 QScriptEngine::newObject
	{12, 176, 131},	//118 QScriptEngine::newObject#
	{12, 177, 130},	//119 QScriptEngine::newObject##
	{12, 179, 145},	//120 QScriptEngine::newQMetaObject#
	{12, 180, 144},	//121 QScriptEngine::newQMetaObject##
	{12, 182, 140},	//122 QScriptEngine::newQObject#
	{12, 183, 143},	//123 QScriptEngine::newQObject##
	{12, 184, 142},	//124 QScriptEngine::newQObject##$
	{12, 185, 141},	//125 QScriptEngine::newQObject##$$
	{12, 186, 139},	//126 QScriptEngine::newQObject#$
	{12, 187, 138},	//127 QScriptEngine::newQObject#$$
	{12, 189, 128},	//128 QScriptEngine::newRegExp#
	{12, 190, 134},	//129 QScriptEngine::newRegExp$$
	{12, 192, 126},	//130 QScriptEngine::newVariant#
	{12, 193, 127},	//131 QScriptEngine::newVariant##
	{12, 195, 119},	//132 QScriptEngine::nullValue
	{12, 198, 157},	//133 QScriptEngine::objectById$
	{12, 208, 106},	//134 QScriptEngine::popContext
	{12, 212, 153},	//135 QScriptEngine::processEventsInterval
	{12, 226, 105},	//136 QScriptEngine::pushContext
	{12, 228, 99},	//137 QScriptEngine::qt_metacall$$?
	{12, 244, 154},	//138 QScriptEngine::setAgent#
	{12, 248, 147},	//139 QScriptEngine::setDefaultPrototype$#
	{12, 250, 152},	//140 QScriptEngine::setProcessEventsInterval$
	{12, 270, 158},	//141 QScriptEngine::signalHandlerException#
	{12, 297, 156},	//142 QScriptEngine::toStringHandle$
	{12, 302, 160},	//143 QScriptEngine::tr$
	{12, 303, 159},	//144 QScriptEngine::tr$$
	{12, 304, 115},	//145 QScriptEngine::uncaughtException
	{12, 305, 117},	//146 QScriptEngine::uncaughtExceptionBacktrace
	{12, 306, 116},	//147 QScriptEngine::uncaughtExceptionLineNumber
	{12, 307, 120},	//148 QScriptEngine::undefinedValue
	{12, 313, 102},	//149 QScriptEngine::~QScriptEngine
	{13, 29, 161},	//150 QScriptEngineAgent::QScriptEngineAgent#
	{13, 87, 166},	//151 QScriptEngineAgent::contextPop
	{13, 88, 165},	//152 QScriptEngineAgent::contextPush
	{13, 97, 175},	//153 QScriptEngineAgent::engine
	{13, 109, 171},	//154 QScriptEngineAgent::exceptionCatch$#
	{13, 111, 170},	//155 QScriptEngineAgent::exceptionThrow$#$
	{13, 113, 174},	//156 QScriptEngineAgent::extension$
	{13, 114, 173},	//157 QScriptEngineAgent::extension$#
	{13, 119, 167},	//158 QScriptEngineAgent::functionEntry$
	{13, 121, 168},	//159 QScriptEngineAgent::functionExit$#
	{13, 210, 169},	//160 QScriptEngineAgent::positionChange$$$
	{13, 237, 163},	//161 QScriptEngineAgent::scriptLoad$$$$
	{13, 240, 164},	//162 QScriptEngineAgent::scriptUnload$
	{13, 275, 172},	//163 QScriptEngineAgent::supportsExtension$
	{13, 314, 162},	//164 QScriptEngineAgent::~QScriptEngineAgent
	{15, 160, 177},	//165 QScriptExtensionPlugin::metaObject
	{15, 228, 178},	//166 QScriptExtensionPlugin::qt_metacall$$?
	{15, 302, 180},	//167 QScriptExtensionPlugin::tr$
	{15, 303, 179},	//168 QScriptExtensionPlugin::tr$$
	{16, 30, 181},	//169 QScriptString::QScriptString
	{16, 31, 182},	//170 QScriptString::QScriptString#
	{16, 154, 185},	//171 QScriptString::isValid
	{16, 200, 189},	//172 QScriptString::operator QString
	{16, 202, 187},	//173 QScriptString::operator!=#
	{16, 204, 184},	//174 QScriptString::operator=#
	{16, 206, 186},	//175 QScriptString::operator==#
	{16, 295, 188},	//176 QScriptString::toString
	{16, 315, 183},	//177 QScriptString::~QScriptString
	{17, 10, 200},	//178 QScriptValue::KeepExistingFlags
	{17, 13, 202},	//179 QScriptValue::NullValue
	{17, 15, 197},	//180 QScriptValue::PropertyGetter
	{17, 16, 198},	//181 QScriptValue::PropertySetter
	{17, 17, 199},	//182 QScriptValue::QObjectMember
	{17, 32, 204},	//183 QScriptValue::QScriptValue
	{17, 33, 206},	//184 QScriptValue::QScriptValue#
	{17, 34, -7},	//185 QScriptValue::QScriptValue#$
	{17, 42, 194},	//186 QScriptValue::ReadOnly
	{17, 44, 193},	//187 QScriptValue::ResolveFull
	{17, 45, 190},	//188 QScriptValue::ResolveLocal
	{17, 46, 191},	//189 QScriptValue::ResolvePrototype
	{17, 47, 192},	//190 QScriptValue::ResolveScope
	{17, 50, 196},	//191 QScriptValue::SkipInEnumeration
	{17, 55, 203},	//192 QScriptValue::UndefinedValue
	{17, 56, 195},	//193 QScriptValue::Undeletable
	{17, 58, 201},	//194 QScriptValue::UserRange
	{17, 69, 270},	//195 QScriptValue::call
	{17, 70, 269},	//196 QScriptValue::call#
	{17, 71, 271},	//197 QScriptValue::call##
	{17, 72, 268},	//198 QScriptValue::call#?
	{17, 83, 273},	//199 QScriptValue::construct
	{17, 84, 274},	//200 QScriptValue::construct#
	{17, 85, 272},	//201 QScriptValue::construct?
	{17, 92, 275},	//202 QScriptValue::data
	{17, 97, 215},	//203 QScriptValue::engine
	{17, 99, 246},	//204 QScriptValue::equals#
	{17, 138, 244},	//205 QScriptValue::instanceOf#
	{17, 139, 229},	//206 QScriptValue::isArray
	{17, 140, 217},	//207 QScriptValue::isBoolean
	{17, 142, 227},	//208 QScriptValue::isDate
	{17, 143, 230},	//209 QScriptValue::isError
	{17, 145, 219},	//210 QScriptValue::isFunction
	{17, 146, 220},	//211 QScriptValue::isNull
	{17, 147, 218},	//212 QScriptValue::isNumber
	{17, 148, 226},	//213 QScriptValue::isObject
	{17, 149, 225},	//214 QScriptValue::isQMetaObject
	{17, 150, 224},	//215 QScriptValue::isQObject
	{17, 151, 228},	//216 QScriptValue::isRegExp
	{17, 152, 221},	//217 QScriptValue::isString
	{17, 153, 222},	//218 QScriptValue::isUndefined
	{17, 154, 216},	//219 QScriptValue::isValid
	{17, 155, 223},	//220 QScriptValue::isVariant
	{17, 158, 245},	//221 QScriptValue::lessThan#
	{17, 199, 279},	//222 QScriptValue::objectId
	{17, 204, 214},	//223 QScriptValue::operator=#
	{17, 214, 261},	//224 QScriptValue::property#
	{17, 216, 260},	//225 QScriptValue::property#$
	{17, 217, -15},	//226 QScriptValue::property$
	{17, 218, -18},	//227 QScriptValue::property$$
	{17, 220, 267},	//228 QScriptValue::propertyFlags#
	{17, 222, 266},	//229 QScriptValue::propertyFlags#$
	{17, 223, 265},	//230 QScriptValue::propertyFlags$
	{17, 224, 264},	//231 QScriptValue::propertyFlags$$
	{17, 225, 248},	//232 QScriptValue::prototype
	{17, 233, 250},	//233 QScriptValue::scope
	{17, 234, 277},	//234 QScriptValue::scriptClass
	{17, 246, 276},	//235 QScriptValue::setData#
	{17, 252, 263},	//236 QScriptValue::setProperty##
	{17, 253, 262},	//237 QScriptValue::setProperty##$
	{17, 255, -21},	//238 QScriptValue::setProperty$#
	{17, 256, -24},	//239 QScriptValue::setProperty$#$
	{17, 258, 249},	//240 QScriptValue::setPrototype#
	{17, 262, 251},	//241 QScriptValue::setScope#
	{17, 264, 278},	//242 QScriptValue::setScriptClass#
	{17, 273, 247},	//243 QScriptValue::strictlyEquals#
	{17, 285, 233},	//244 QScriptValue::toBoolean
	{17, 286, 242},	//245 QScriptValue::toDateTime
	{17, 288, 235},	//246 QScriptValue::toInt32
	{17, 289, 234},	//247 QScriptValue::toInteger
	{17, 290, 232},	//248 QScriptValue::toNumber
	{17, 291, 241},	//249 QScriptValue::toObject
	{17, 292, 240},	//250 QScriptValue::toQMetaObject
	{17, 293, 239},	//251 QScriptValue::toQObject
	{17, 294, 243},	//252 QScriptValue::toRegExp
	{17, 295, 231},	//253 QScriptValue::toString
	{17, 298, 237},	//254 QScriptValue::toUInt16
	{17, 299, 236},	//255 QScriptValue::toUInt32
	{17, 300, 238},	//256 QScriptValue::toVariant
	{17, 316, 205},	//257 QScriptValue::~QScriptValue
	{18, 36, 280},	//258 QScriptValueIterator::QScriptValueIterator#
	{18, 116, 290},	//259 QScriptValueIterator::flags
	{18, 128, 282},	//260 QScriptValueIterator::hasNext
	{18, 129, 284},	//261 QScriptValueIterator::hasPrevious
	{18, 161, 286},	//262 QScriptValueIterator::name
	{18, 194, 283},	//263 QScriptValueIterator::next
	{18, 204, 294},	//264 QScriptValueIterator::operator=#
	{18, 211, 285},	//265 QScriptValueIterator::previous
	{18, 231, 291},	//266 QScriptValueIterator::remove
	{18, 238, 287},	//267 QScriptValueIterator::scriptName
	{18, 268, 289},	//268 QScriptValueIterator::setValue#
	{18, 284, 293},	//269 QScriptValueIterator::toBack
	{18, 287, 292},	//270 QScriptValueIterator::toFront
	{18, 308, 288},	//271 QScriptValueIterator::value
	{18, 317, 281},	//272 QScriptValueIterator::~QScriptValueIterator
	{19, 37, 295},	//273 QScriptable::QScriptable
	{19, 64, 301},	//274 QScriptable::argument$
	{19, 65, 300},	//275 QScriptable::argumentCount
	{19, 86, 298},	//276 QScriptable::context
	{19, 97, 297},	//277 QScriptable::engine
	{19, 276, 299},	//278 QScriptable::thisObject
	{19, 318, 296},	//279 QScriptable::~QScriptable
};

static Smoke::Index qtscript_ambiguousMethodList[] = {
    0,
    71,  // QScriptContextInfo::QScriptContextInfo(const QScriptContext*)
    72,  // QScriptContextInfo::QScriptContextInfo(const QScriptContextInfo&)
    0,
    125,  // QScriptEngine::newFunction(FunctionWithArgSignature, void*)
    121,  // QScriptEngine::newFunction(FunctionSignature, int)
    0,
    211,  // QScriptValue::QScriptValue(QScriptEngine*, double)
    208,  // QScriptValue::QScriptValue(QScriptEngine*, bool)
    209,  // QScriptValue::QScriptValue(QScriptEngine*, int)
    213,  // QScriptValue::QScriptValue(QScriptEngine*, const char*)
    212,  // QScriptValue::QScriptValue(QScriptEngine*, const QString&)
    210,  // QScriptValue::QScriptValue(QScriptEngine*, uint)
    207,  // QScriptValue::QScriptValue(QScriptEngine*, QScriptValue::SpecialValue)
    0,
    257,  // QScriptValue::property(unsigned int) const
    253,  // QScriptValue::property(const QString&) const
    0,
    256,  // QScriptValue::property(unsigned int, const QScriptValue::ResolveFlags&) const
    252,  // QScriptValue::property(const QString&, const QScriptValue::ResolveFlags&) const
    0,
    255,  // QScriptValue::setProperty(const QString&, const QScriptValue&)
    259,  // QScriptValue::setProperty(unsigned int, const QScriptValue&)
    0,
    258,  // QScriptValue::setProperty(unsigned int, const QScriptValue&, const QScriptValue::PropertyFlags&)
    254,  // QScriptValue::setProperty(const QString&, const QScriptValue&, const QScriptValue::PropertyFlags&)
    0,
};


extern "C" void init_qt_Smoke();

bool initialized = false;
Smoke *qtscript_Smoke = 0;

// Create the Smoke instance encapsulating all the above.
void init_qtscript_Smoke() {
    if (initialized) return;
    init_qt_Smoke();
    qtscript_Smoke = new Smoke(
        "qtscript",
        qtscript_classes, 22,
        qtscript_methods, 302,
        qtscript_methodMaps, 280,
        qtscript_methodNames, 318,
        qtscript_types, 147,
        qtscript_inheritanceList,
        qtscript_argumentList,
        qtscript_ambiguousMethodList,
        qtscript_cast );
    initialized = true;
}
