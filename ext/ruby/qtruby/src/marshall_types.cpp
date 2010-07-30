/***************************************************************************
    marshall_types.cpp - Derived from the PerlQt sources, see AUTHORS
                         for details
                             -------------------
    begin                : Fri Jul 4 2003
    copyright            : (C) 2003-2006 by Richard Dale
    email                : Richard_Dale@tipitina.demon.co.uk
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Lesser General Public License as        *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 ***************************************************************************/

#include "marshall_types.h"
#include <smoke/qtcore_smoke.h>

#include <QtCore/qvector.h>
#include <QtCore/qlist.h>
#include <QtCore/qhash.h>
#include <QtCore/qmap.h>

#ifdef QT_QTDBUS
#include <QtDBus>
#endif

static bool qtruby_embedded = false;

extern "C" {

Q_DECL_EXPORT void 
set_qtruby_embedded(bool yn) {
#if !defined(RUBY_INIT_STACK)
    if (yn) {
        qWarning("ERROR: set_qtruby_embedded(true) called but RUBY_INIT_STACK is undefined");
        qWarning("       Upgrade to Ruby 1.8.6 or greater");
	}
#endif
    qtruby_embedded = yn;
}

}

// This is based on the SWIG SWIG_INIT_STACK and SWIG_RELEASE_STACK macros.
// If RUBY_INIT_STACK is only called when an embedded extension such as, a
// Ruby Plasma plugin is loaded, then later the C++ stack can drop below where the 
// Ruby runtime thinks the stack should start (ie the stack position when the 
// plugin was loaded), and result in sys stackerror exceptions
//
// TODO: While constructing the main class of a plugin when it is being loaded, 
// there could be a problem when a custom virtual method is called or a slot is
// invoked, because RUBY_INIT_STACK will have aleady have been called from within 
// the krubypluginfactory code, and it shouldn't be called again.

#if defined(RUBY_INIT_STACK)
#  define QTRUBY_INIT_STACK                            \
      if ( qtruby_embedded && nested_callback_count == 0 ) { RUBY_INIT_STACK } \
      nested_callback_count++;
#  define QTRUBY_RELEASE_STACK nested_callback_count--;

static unsigned int nested_callback_count = 0;

#else  /* normal non-embedded extension */

#  define QTRUBY_INIT_STACK
#  define QTRUBY_RELEASE_STACK
#endif  /* RUBY_EMBEDDED */

//
// This function was borrowed from the kross code. It puts out
// an error message and stacktrace on stderr for the current exception.
//
static void
show_exception_message()
{
    VALUE info = rb_gv_get("$!");
    VALUE bt = rb_funcall(info, rb_intern("backtrace"), 0);
    VALUE message = RARRAY_PTR(bt)[0];
    VALUE message2 = rb_obj_as_string(info);

    QString errormessage = QString("%1: %2 (%3)")
                            .arg( StringValueCStr(message) )
                            .arg( StringValueCStr(message2) )
                            .arg( rb_class2name(CLASS_OF(info)) );
    fprintf(stderr, "%s\n", errormessage.toLatin1().data());

    QString tracemessage;
    for(int i = 1; i < RARRAY_LEN(bt); ++i) {
        if( TYPE(RARRAY_PTR(bt)[i]) == T_STRING ) {
            QString s = QString("%1\n").arg( StringValueCStr(RARRAY_PTR(bt)[i]) );
            Q_ASSERT( ! s.isNull() );
            tracemessage += s;
            fprintf(stderr, "\t%s", s.toLatin1().data());
        }
    }
}

static VALUE funcall2_protect_id = Qnil;
static int funcall2_protect_argc = 0;
static VALUE * funcall2_protect_args = 0;

static VALUE
funcall2_protect(VALUE obj)
{
	VALUE result = Qnil;
	result = rb_funcall2(obj, funcall2_protect_id, funcall2_protect_argc, funcall2_protect_args);
	return result;
}

#  define QTRUBY_FUNCALL2(result, obj, id, argc, args) \
      if (qtruby_embedded) { \
          int state = 0; \
          funcall2_protect_id = id; \
          funcall2_protect_argc = argc; \
          funcall2_protect_args = args; \
          result = rb_protect(funcall2_protect, obj, &state); \
          if (state != 0) { \
              show_exception_message(); \
              result = Qnil; \
          } \
      } else { \
          result = rb_funcall2(obj, id, argc, args); \
      }

void
smokeStackToQtStack(Smoke::Stack stack, void ** o, int start, int end, QList<MocArgument*> args)
{
	for (int i = start, j = 0; i < end; i++, j++) {
		Smoke::StackItem *si = stack + j;
		switch(args[i]->argType) {
		case xmoc_bool:
			o[j] = &si->s_bool;
			break;
		case xmoc_int:
			o[j] = &si->s_int;
			break;
		case xmoc_uint:
			o[j] = &si->s_uint;
			break;
		case xmoc_long:
			o[j] = &si->s_long;
			break;
		case xmoc_ulong:
			o[j] = &si->s_ulong;
			break;
		case xmoc_double:
			o[j] = &si->s_double;
			break;
		case xmoc_charstar:
			o[j] = &si->s_voidp;
			break;
		case xmoc_QString:
			o[j] = si->s_voidp;
			break;
		default:
		{
			const SmokeType &t = args[i]->st;
			void *p;
			switch(t.elem()) {
			case Smoke::t_bool:
				p = &si->s_bool;
				break;
			case Smoke::t_char:
				p = &si->s_char;
				break;
			case Smoke::t_uchar:
				p = &si->s_uchar;
				break;
			case Smoke::t_short:
				p = &si->s_short;
				break;
			case Smoke::t_ushort:
				p = &si->s_ushort;
				break;
			case Smoke::t_int:
				p = &si->s_int;
				break;
			case Smoke::t_uint:
				p = &si->s_uint;
				break;
			case Smoke::t_long:
				p = &si->s_long;
				break;
			case Smoke::t_ulong:
				p = &si->s_ulong;
				break;
			case Smoke::t_float:
				p = &si->s_float;
				break;
			case Smoke::t_double:
				p = &si->s_double;
				break;
			case Smoke::t_enum:
			{
				// allocate a new enum value
				Smoke::EnumFn fn = SmokeClass(t).enumFn();
				if (!fn) {
					rb_warning("Unknown enumeration %s\n", t.name());
					p = new int((int)si->s_enum);
					break;
				}
				Smoke::Index id = t.typeId();
				(*fn)(Smoke::EnumNew, id, p, si->s_enum);
				(*fn)(Smoke::EnumFromLong, id, p, si->s_enum);
				// FIXME: MEMORY LEAK
				break;
			}
			case Smoke::t_class:
			case Smoke::t_voidp:
				if (strchr(t.name(), '*') != 0) {
					p = &si->s_voidp;
				} else {
					p = si->s_voidp;
				}
				break;
			default:
				p = 0;
				break;
			}
			o[j] = p;
		}
		}
	}
}

void
smokeStackFromQtStack(Smoke::Stack stack, void ** _o, int start, int end, QList<MocArgument*> args)
{
	for (int i = start, j = 0; i < end; i++, j++) {
		void *o = _o[j];
		switch(args[i]->argType) {
		case xmoc_bool:
			stack[j].s_bool = *(bool*)o;
			break;
		case xmoc_int:
			stack[j].s_int = *(int*)o;
			break;
		case xmoc_uint:
			stack[j].s_uint = *(uint*)o;
			break;
		case xmoc_long:
			stack[j].s_long = *(long*)o;
			break;
		case xmoc_ulong:
			stack[j].s_ulong = *(ulong*)o;
			break;
		case xmoc_double:
			stack[j].s_double = *(double*)o;
			break;
		case xmoc_charstar:
			stack[j].s_voidp = o;
			break;
		case xmoc_QString:
			stack[j].s_voidp = o;
			break;
		default:	// case xmoc_ptr:
		{
			const SmokeType &t = args[i]->st;
			switch(t.elem()) {
			case Smoke::t_bool:
			stack[j].s_bool = *(bool*)o;
			break;
			case Smoke::t_char:
			stack[j].s_char = *(char*)o;
			break;
			case Smoke::t_uchar:
			stack[j].s_uchar = *(unsigned char*)o;
			break;
			case Smoke::t_short:
			stack[j].s_short = *(short*)o;
			break;
			case Smoke::t_ushort:
			stack[j].s_ushort = *(unsigned short*)o;
			break;
			case Smoke::t_int:
			stack[j].s_int = *(int*)o;
			break;
			case Smoke::t_uint:
			stack[j].s_uint = *(unsigned int*)o;
			break;
			case Smoke::t_long:
			stack[j].s_long = *(long*)o;
			break;
			case Smoke::t_ulong:
			stack[j].s_ulong = *(unsigned long*)o;
			break;
			case Smoke::t_float:
			stack[j].s_float = *(float*)o;
			break;
			case Smoke::t_double:
			stack[j].s_double = *(double*)o;
			break;
			case Smoke::t_enum:
			{
				Smoke::EnumFn fn = SmokeClass(t).enumFn();
				if (!fn) {
					rb_warning("Unknown enumeration %s\n", t.name());
					stack[j].s_enum = *(int*)o;
					break;
				}
				Smoke::Index id = t.typeId();
				(*fn)(Smoke::EnumToLong, id, o, stack[j].s_enum);
			}
			break;
			case Smoke::t_class:
			case Smoke::t_voidp:
				if (strchr(t.name(), '*') != 0) {
					stack[j].s_voidp = *(void **)o;
				} else {
					stack[j].s_voidp = o;
				}
			break;
			}
		}
		}
	}
}

namespace QtRuby {

MethodReturnValueBase::MethodReturnValueBase(Smoke *smoke, Smoke::Index meth, Smoke::Stack stack) :
	_smoke(smoke), _method(meth), _stack(stack) 
{ 
	_st.set(_smoke, method().ret);
}

const Smoke::Method&
MethodReturnValueBase::method() 
{ 
	return _smoke->methods[_method]; 
}

Smoke::StackItem&
MethodReturnValueBase::item() 
{ 
	return _stack[0]; 
}

Smoke *
MethodReturnValueBase::smoke() 
{ 
	return _smoke; 
}

SmokeType 
MethodReturnValueBase::type() 
{ 
	return _st; 
}

void 
MethodReturnValueBase::next() {}

bool 
MethodReturnValueBase::cleanup() 
{ 
	return false; 
}

void 
MethodReturnValueBase::unsupported() 
{
	rb_raise(rb_eArgError, "Cannot handle '%s' as return-type of %s::%s",
	type().name(),
	classname(),
	_smoke->methodNames[method().name]);	
}

VALUE * 
MethodReturnValueBase::var() 
{ 
	return _retval; 
}

const char *
MethodReturnValueBase::classname() 
{ 
	return _smoke->className(method().classId); 
}


VirtualMethodReturnValue::VirtualMethodReturnValue(Smoke *smoke, Smoke::Index meth, Smoke::Stack stack, VALUE retval) :
	MethodReturnValueBase(smoke,meth,stack), _retval2(retval) 
{
	_retval = &_retval2;
	Marshall::HandlerFn fn = getMarshallFn(type());
	(*fn)(this);
}

Marshall::Action 
VirtualMethodReturnValue::action() 
{ 
	return Marshall::FromVALUE; 
}

MethodReturnValue::MethodReturnValue(Smoke *smoke, Smoke::Index meth, Smoke::Stack stack, VALUE * retval) :
	MethodReturnValueBase(smoke,meth,stack) 
{
	_retval = retval;
	Marshall::HandlerFn fn = getMarshallFn(type());
	(*fn)(this);
}

Marshall::Action 
MethodReturnValue::action() 
{ 
	return Marshall::ToVALUE; 
}

const char *
MethodReturnValue::classname() 
{ 
	return qstrcmp(MethodReturnValueBase::classname(), "QGlobalSpace") == 0 ? "" : MethodReturnValueBase::classname(); 
}


MethodCallBase::MethodCallBase(Smoke *smoke, Smoke::Index meth) :
	_smoke(smoke), _method(meth), _cur(-1), _called(false), _sp(0)  
{  
}

MethodCallBase::MethodCallBase(Smoke *smoke, Smoke::Index meth, Smoke::Stack stack) :
	_smoke(smoke), _method(meth), _stack(stack), _cur(-1), _called(false), _sp(0) 
{  
}

Smoke *
MethodCallBase::smoke() 
{ 
	return _smoke; 
}

SmokeType 
MethodCallBase::type() 
{ 
	return SmokeType(_smoke, _args[_cur]); 
}

Smoke::StackItem &
MethodCallBase::item() 
{ 
	return _stack[_cur + 1]; 
}

const Smoke::Method &
MethodCallBase::method() 
{ 
	return _smoke->methods[_method]; 
}
	
void 
MethodCallBase::next() 
{
	int oldcur = _cur;
	_cur++;
	while(!_called && _cur < items() ) {
		Marshall::HandlerFn fn = getMarshallFn(type());
		(*fn)(this);
		_cur++;
	}

	callMethod();
	_cur = oldcur;
}

void 
MethodCallBase::unsupported() 
{
	rb_raise(rb_eArgError, "Cannot handle '%s' as argument of %s::%s",
		type().name(),
		classname(),
		_smoke->methodNames[method().name]);
}

const char* 
MethodCallBase::classname() 
{ 
	return _smoke->className(method().classId); 
}


VirtualMethodCall::VirtualMethodCall(Smoke *smoke, Smoke::Index meth, Smoke::Stack stack, VALUE obj, VALUE *sp) :
	MethodCallBase(smoke,meth,stack), _obj(obj)
{		
	_sp = sp;
	_args = _smoke->argumentList + method().args;
}

VirtualMethodCall::~VirtualMethodCall() 
{
}

Marshall::Action 
VirtualMethodCall::action() 
{ 
	return Marshall::ToVALUE; 
}

VALUE *
VirtualMethodCall::var() 
{ 
	return _sp + _cur; 
}
	
int 
VirtualMethodCall::items() 
{ 
	return method().numArgs; 
}

void 
VirtualMethodCall::callMethod() 
{
	if (_called) return;
	_called = true;

	VALUE _retval;
	QTRUBY_INIT_STACK
	QTRUBY_FUNCALL2(_retval, _obj, rb_intern(_smoke->methodNames[method().name]), method().numArgs, _sp)
	QTRUBY_RELEASE_STACK

	VirtualMethodReturnValue r(_smoke, _method, _stack, _retval);
}

bool 
VirtualMethodCall::cleanup() 
{ 
	return false; 
}

MethodCall::MethodCall(Smoke *smoke, Smoke::Index method, VALUE target, VALUE *sp, int items) :
	MethodCallBase(smoke,method), _target(target), _o(0), _sp(sp), _items(items)
{
	if (_target != Qnil) {
		smokeruby_object *o = value_obj_info(_target);
		if (o != 0 && o->ptr != 0) {
			_o = o;
		}
	}

	_args = _smoke->argumentList + _smoke->methods[_method].args;
	_items = _smoke->methods[_method].numArgs;
	_stack = new Smoke::StackItem[items + 1];
	_retval = Qnil;
}

MethodCall::~MethodCall() 
{
	delete[] _stack;
}

Marshall::Action 
MethodCall::action() 
{ 
	return Marshall::FromVALUE; 
}

VALUE * 
MethodCall::var() 
{
	if (_cur < 0) return &_retval;
	return _sp + _cur;
}

int 
MethodCall::items() 
{ 
	return _items; 
}

bool 
MethodCall::cleanup() 
{ 
	return true; 
}

const char *
MethodCall::classname() 
{ 
	return qstrcmp(MethodCallBase::classname(), "QGlobalSpace") == 0 ? "" : MethodCallBase::classname(); 
}

SigSlotBase::SigSlotBase(QList<MocArgument*> args) : _cur(-1), _called(false) 
{ 
	_items = args.count();
	_args = args;
	_stack = new Smoke::StackItem[_items - 1];
}

SigSlotBase::~SigSlotBase() 
{ 
	delete[] _stack; 
	foreach (MocArgument * arg, _args) {
		delete arg;
	}
}

const MocArgument &
SigSlotBase::arg() 
{ 
	return *(_args[_cur + 1]); 
}

SmokeType 
SigSlotBase::type() 
{ 
	return arg().st; 
}

Smoke::StackItem &
SigSlotBase::item() 
{ 
	return _stack[_cur]; 
}

VALUE * 
SigSlotBase::var() 
{ 
	return _sp + _cur; 
}

Smoke *
SigSlotBase::smoke() 
{ 
	return type().smoke(); 
}

void 
SigSlotBase::unsupported() 
{
	rb_raise(rb_eArgError, "Cannot handle '%s' as %s argument\n", type().name(), mytype() );
}

void
SigSlotBase::next() 
{
	int oldcur = _cur;
	_cur++;

	while(!_called && _cur < _items - 1) {
		Marshall::HandlerFn fn = getMarshallFn(type());
		(*fn)(this);
		_cur++;
	}

	mainfunction();
	_cur = oldcur;
}

void 
SigSlotBase::prepareReturnValue(void** o)
{
	if (_args[0]->argType == xmoc_ptr) {
		QByteArray type(_args[0]->st.name());
		type.replace("const ", "");
		if (!type.endsWith('*')) {  // a real pointer type, so a simple void* will do
			if (type.endsWith('&')) {
				type.resize(type.size() - 1);
			}
			if (type.startsWith("QList")) {
				o[0] = new QList<void*>;
			} else if (type.startsWith("QVector")) {
				o[0] = new QVector<void*>;
			} else if (type.startsWith("QHash")) {
				o[0] = new QHash<void*, void*>;
			} else if (type.startsWith("QMap")) {
				o[0] = new QMap<void*, void*>;
#ifdef QT_QTDBUS
			} else if (type == "QDBusVariant") {
				o[0] = new QDBusVariant;
#endif
			} else {
				Smoke::ModuleIndex ci = qtcore_Smoke->findClass(type);
				if (ci.index != 0) {
					Smoke::ModuleIndex mi = ci.smoke->findMethod(type, type);
					if (mi.index) {
						Smoke::Class& c = ci.smoke->classes[ci.index];
						Smoke::Method& meth = mi.smoke->methods[mi.smoke->methodMaps[mi.index].method];
						Smoke::StackItem _stack[1];
						c.classFn(meth.method, 0, _stack);
						o[0] = _stack[0].s_voidp;
					}
				}
			}
		}
	} else if (_args[0]->argType == xmoc_QString) {
		o[0] = new QString;
	}
}

/*
	Converts a ruby value returned by a slot invocation to a Qt slot 
	reply type
*/
class SlotReturnValue : public Marshall {
    QList<MocArgument*>	_replyType;
    Smoke::Stack _stack;
	VALUE * _result;
public:
	SlotReturnValue(void ** o, VALUE * result, QList<MocArgument*> replyType) 
	{
		_result = result;
		_replyType = replyType;
		_stack = new Smoke::StackItem[1];
		Marshall::HandlerFn fn = getMarshallFn(type());
		(*fn)(this);
		
		QByteArray t(type().name());
		t.replace("const ", "");
		t.replace("&", "");

		if (t == "QDBusVariant") {
#ifdef QT_QTDBUS
			*reinterpret_cast<QDBusVariant*>(o[0]) = *(QDBusVariant*) _stack[0].s_class;
#endif
		} else {
			// Save any address in zeroth element of the arrary of 'void*'s passed to 
			// qt_metacall()
			void * ptr = o[0];
			smokeStackToQtStack(_stack, o, 0, 1, _replyType);
			// Only if the zeroth element of the array of 'void*'s passed to qt_metacall()
			// contains an address, is the return value of the slot needed.
			if (ptr != 0) {
				*(void**)ptr = *(void**)(o[0]);
			}
		}
    }

    SmokeType type() { 
		return _replyType[0]->st; 
	}
    Marshall::Action action() { return Marshall::FromVALUE; }
    Smoke::StackItem &item() { return _stack[0]; }
    VALUE * var() {
    	return _result;
    }
	
	void unsupported() 
	{
		rb_raise(rb_eArgError, "Cannot handle '%s' as slot reply-type", type().name());
    }
	Smoke *smoke() { return type().smoke(); }
    
	void next() {}
    
	bool cleanup() { return false; }
	
	~SlotReturnValue() {
		delete[] _stack;
	}
};

InvokeSlot::InvokeSlot(VALUE obj, ID slotname, QList<MocArgument*> args, void ** o) : SigSlotBase(args),
    _obj(obj), _slotname(slotname), _o(o)
{
	_sp = (VALUE *) ALLOC_N(VALUE, _items - 1);
	copyArguments();
}

InvokeSlot::~InvokeSlot() 
{ 
	xfree(_sp);	
}

Marshall::Action 
InvokeSlot::action() 
{ 
	return Marshall::ToVALUE; 
}

const char *
InvokeSlot::mytype() 
{ 
	return "slot"; 
}

bool 
InvokeSlot::cleanup() 
{ 
	return false; 
}

void 
InvokeSlot::copyArguments() 
{
	smokeStackFromQtStack(_stack, _o + 1, 1, _items, _args);
}

void 
InvokeSlot::invokeSlot() 
{
	if (_called) return;
	_called = true;

    VALUE result;
	QTRUBY_INIT_STACK
	QTRUBY_FUNCALL2(result, _obj, _slotname, _items - 1, _sp)
	QTRUBY_RELEASE_STACK

	if (_args[0]->argType != xmoc_void) {
		SlotReturnValue r(_o, &result, _args);
	}
}

void 
InvokeSlot::mainfunction() 
{ 
	invokeSlot(); 
}

}
