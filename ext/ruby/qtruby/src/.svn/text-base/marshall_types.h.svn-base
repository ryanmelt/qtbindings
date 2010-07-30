/***************************************************************************
    marshall_types.h - Derived from the PerlQt sources, see AUTHORS 
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

#ifndef MARSHALL_TYPES_H
#define MARSHALL_TYPES_H

#include <QtCore/qstring.h>
#include <QtCore/qobject.h>
#include <QtCore/qmetaobject.h>

#include <smoke/smoke.h>

#include "marshall.h"
#include "qtruby.h"
#include "smokeruby.h"

Marshall::HandlerFn getMarshallFn(const SmokeType &type);

extern void smokeStackToQtStack(Smoke::Stack stack, void ** o, int start, int end, QList<MocArgument*> args);
extern void smokeStackFromQtStack(Smoke::Stack stack, void ** _o, int start, int end, QList<MocArgument*> args);

namespace QtRuby {

class Q_DECL_EXPORT MethodReturnValueBase : public Marshall 
{
public:
	MethodReturnValueBase(Smoke *smoke, Smoke::Index meth, Smoke::Stack stack);
	const Smoke::Method &method();
	Smoke::StackItem &item();
	Smoke *smoke();
	SmokeType type();
	void next();
	bool cleanup();
	void unsupported();
    VALUE * var();
protected:
	Smoke *_smoke;
	Smoke::Index _method;
	Smoke::Stack _stack;
	SmokeType _st;
	VALUE *_retval;
	virtual const char *classname();
};


class Q_DECL_EXPORT VirtualMethodReturnValue : public MethodReturnValueBase {
public:
	VirtualMethodReturnValue(Smoke *smoke, Smoke::Index meth, Smoke::Stack stack, VALUE retval);
	Marshall::Action action();

private:
	VALUE _retval2;
};


class Q_DECL_EXPORT MethodReturnValue : public MethodReturnValueBase {
public:
	MethodReturnValue(Smoke *smoke, Smoke::Index meth, Smoke::Stack stack, VALUE * retval);
    Marshall::Action action();

private:
	const char *classname();
};

class Q_DECL_EXPORT MethodCallBase : public Marshall
{
public:
	MethodCallBase(Smoke *smoke, Smoke::Index meth);
	MethodCallBase(Smoke *smoke, Smoke::Index meth, Smoke::Stack stack);
	Smoke *smoke();
	SmokeType type();
	Smoke::StackItem &item();
	const Smoke::Method &method();
	virtual int items() = 0;
	virtual void callMethod() = 0;	
	void next();
	void unsupported();

protected:
	Smoke *_smoke;
	Smoke::Index _method;
	Smoke::Stack _stack;
	int _cur;
	Smoke::Index *_args;
	bool _called;
	VALUE *_sp;
	virtual const char* classname();
};


class Q_DECL_EXPORT VirtualMethodCall : public MethodCallBase {
public:
	VirtualMethodCall(Smoke *smoke, Smoke::Index meth, Smoke::Stack stack, VALUE obj, VALUE *sp);
	~VirtualMethodCall();
	Marshall::Action action();
	VALUE * var();
	int items();
	void callMethod();
	bool cleanup();
 
private:
	VALUE _obj;
};


class Q_DECL_EXPORT MethodCall : public MethodCallBase {
public:
	MethodCall(Smoke *smoke, Smoke::Index method, VALUE target, VALUE *sp, int items);
	~MethodCall();
	Marshall::Action action();
	VALUE * var();

	inline void callMethod() {
		if(_called) return;
		_called = true;

		if (_target == Qnil && !(method().flags & Smoke::mf_static)) {
			rb_raise(rb_eArgError, "%s is not a class method\n", _smoke->methodNames[method().name]);
		}
	
		Smoke::ClassFn fn = _smoke->classes[method().classId].classFn;
		void * ptr = 0;

		if (_o != 0) {
			const Smoke::Class &cl = _smoke->classes[method().classId];

			ptr = _o->smoke->cast(	_o->ptr,
									_o->classId,
									_o->smoke->idClass(cl.className, true).index );
		}

		_items = -1;
		(*fn)(method().method, ptr, _stack);
		if (method().flags & Smoke::mf_ctor) {
			Smoke::StackItem s[2];
			s[1].s_voidp = qtruby_modules[_smoke].binding;
			(*fn)(0, _stack[0].s_voidp, s);
		}
		MethodReturnValue r(_smoke, _method, _stack, &_retval);
	}

	int items();
	bool cleanup();
private:
	VALUE _target;
	smokeruby_object * _o;
	VALUE *_sp;
	int _items;
	VALUE _retval;
	const char *classname();
};


class Q_DECL_EXPORT SigSlotBase : public Marshall {
public:
	SigSlotBase(QList<MocArgument*> args);
	~SigSlotBase();
	const MocArgument &arg();
	SmokeType type();
	Smoke::StackItem &item();
	VALUE * var();
	Smoke *smoke();
	virtual const char *mytype() = 0;
	virtual void mainfunction() = 0;
	void unsupported();
	void next(); 
	void prepareReturnValue(void** o);

protected:
	QList<MocArgument*> _args;
	int _cur;
	bool _called;
	Smoke::Stack _stack;
	int _items;
	VALUE *_sp;
};


class Q_DECL_EXPORT EmitSignal : public SigSlotBase {
    QObject *_obj;
    int _id;
	VALUE * _result;
 public:
    EmitSignal(QObject *obj, int id, int items, QList<MocArgument*> args, VALUE * sp, VALUE * result);
    Marshall::Action action();
    Smoke::StackItem &item();
	const char *mytype();
	void emitSignal();
	void mainfunction();
	bool cleanup();

};

class Q_DECL_EXPORT InvokeNativeSlot : public SigSlotBase {
    QObject *_obj;
    int _id;
	VALUE * _result;
 public:
    InvokeNativeSlot(QObject *obj, int id, int items, QList<MocArgument*> args, VALUE * sp, VALUE * result);
    Marshall::Action action();
    Smoke::StackItem &item();
	const char *mytype();
	void invokeSlot();
	void mainfunction();
	bool cleanup();
};

class Q_DECL_EXPORT InvokeSlot : public SigSlotBase {
    VALUE _obj;
    ID _slotname;
    void **_o;
public:
    InvokeSlot(VALUE obj, ID slotname, QList<MocArgument*> args, void ** o);
	~InvokeSlot();
    Marshall::Action action();
	const char *mytype();
    bool cleanup();
	void copyArguments();
	void invokeSlot(); 
	void mainfunction();
};

}

#endif
