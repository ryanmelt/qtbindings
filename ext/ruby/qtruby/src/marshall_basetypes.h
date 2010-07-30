/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Lesser General Public License as        *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 ***************************************************************************/

#ifndef MARSHALL_BASETYPES_H
#define MARSHALL_BASETYPES_H

template <class T> T* smoke_ptr(Marshall *m) { return (T*) m->item().s_voidp; }

template<> bool* smoke_ptr<bool>(Marshall *m) { return &m->item().s_bool; }
template<> signed char* smoke_ptr<signed char>(Marshall *m) { return &m->item().s_char; }
template<> unsigned char* smoke_ptr<unsigned char>(Marshall *m) { return &m->item().s_uchar; }
template<> short* smoke_ptr<short>(Marshall *m) { return &m->item().s_short; }
template<> unsigned short* smoke_ptr<unsigned short>(Marshall *m) { return &m->item().s_ushort; }
template<> int* smoke_ptr<int>(Marshall *m) { return &m->item().s_int; }
template<> unsigned int* smoke_ptr<unsigned int>(Marshall *m) { return &m->item().s_uint; }
template<> long* smoke_ptr<long>(Marshall *m) { 	return &m->item().s_long; }
template<> unsigned long* smoke_ptr<unsigned long>(Marshall *m) { return &m->item().s_ulong; }
template<> float* smoke_ptr<float>(Marshall *m) { return &m->item().s_float; }
template<> double* smoke_ptr<double>(Marshall *m) { return &m->item().s_double; }
template<> void* smoke_ptr<void>(Marshall *m) { return m->item().s_voidp; }

template <class T> T ruby_to_primitive(VALUE);
template <class T> VALUE primitive_to_ruby(T);

template <class T> 
static void marshall_from_ruby(Marshall *m) 
{
	VALUE obj = *(m->var());
	(*smoke_ptr<T>(m)) = ruby_to_primitive<T>(obj);
}

template <class T>
static void marshall_to_ruby(Marshall *m)
{
	*(m->var()) = primitive_to_ruby<T>( *smoke_ptr<T>(m) ); 
}

#include "marshall_primitives.h"
#include "marshall_complex.h"

// Special case marshallers

template <> 
void marshall_from_ruby<char *>(Marshall *m) 
{
	m->item().s_voidp = ruby_to_primitive<char*>(*(m->var()));
}

template <>
void marshall_from_ruby<unsigned char *>(Marshall *m)
{
	m->item().s_voidp = ruby_to_primitive<unsigned char*>(*(m->var()));
}

template <>
void marshall_from_ruby<SmokeEnumWrapper>(Marshall *m)
{
	VALUE v = *(m->var());

	if (v == Qnil) {
		m->item().s_enum = 0;
	} else if (TYPE(v) == T_OBJECT) {
		// Both Qt::Enum and Qt::Integer have a value() method, so 'get_qinteger()' can be called ok
		VALUE temp = rb_funcall(qt_internal_module, rb_intern("get_qinteger"), 1, v);
		m->item().s_enum = (long) NUM2LONG(temp);
	} else {
		m->item().s_enum = (long) NUM2LONG(v);
	}

}

template <>
void marshall_to_ruby<SmokeEnumWrapper>(Marshall *m)
{
	long val = m->item().s_enum;
    *(m->var()) = rb_funcall(qt_internal_module, rb_intern("create_qenum"),
                             2, LONG2NUM(val), rb_str_new2( m->type().name()) );
}

extern QHash<QByteArray, TypeHandler*> type_handlers;

template <>
void marshall_from_ruby<SmokeClassWrapper>(Marshall *m)
{
	VALUE v = *(m->var());

	if (v == Qnil) {
		m->item().s_class = 0;
		return;
	}

	smokeruby_object *o = value_obj_info(v);
	if (o == 0 || o->ptr == 0) {
		if(m->type().isRef()) {
			rb_warning("References can't be nil\n");
			m->unsupported();
		}
					
		m->item().s_class = 0;
		return;
	}
		
	void *ptr = o->ptr;
	if (!m->cleanup() && m->type().isStack()) {
		ptr = construct_copy(o);
		if (do_debug & qtdb_gc) {
			qWarning("copying %s %p to %p\n", resolve_classname(o), o->ptr, ptr);
		}
	}


	const Smoke::Class &cl = m->smoke()->classes[m->type().classId()];
	
	ptr = o->smoke->cast(
		ptr,				// pointer
		o->classId,				// from
		o->smoke->idClass(cl.className, true).index	// to
		);

	m->item().s_class = ptr;
	return;
}

template <>
void marshall_to_ruby<SmokeClassWrapper>(Marshall *m)
{
	if (m->item().s_voidp == 0) {
		*(m->var()) = Qnil;
		return;
	}
	void *p = m->item().s_voidp;
	VALUE obj = getPointerObject(p);
	if (obj != Qnil) {
    const char* ruby_class  = RSTRING_PTR(rb_funcall(rb_funcall(obj, rb_intern("class"), 0), rb_intern("to_s"), 0));
    const char* smoke_class = m->type().name();
    
    if ((strcmp(ruby_class, "Qt::TextEdit::ExtraSelection") == 0) && (strcmp(smoke_class, "QTextCursor&") == 0))
    {
      /* Intentional Fall Through for ExtraSelection returning a cursor */
    }
    else
    {
		  *(m->var()) = obj;
		  return ;
    }
	}

	smokeruby_object  * o = alloc_smokeruby_object(false, m->smoke(), m->type().classId(), p);

	const char * classname = resolve_classname(o);
	if (m->type().isConst() && m->type().isRef()) {
		p = construct_copy( o );
		if (do_debug & qtdb_gc) {
			qWarning("copying %s %p to %p\n", classname, o->ptr, p);
		}

		if (p) {
			o->ptr = p;
			o->allocated = true;
		}
	}
		
	obj = set_obj_info(classname, o);
	if (do_debug & qtdb_gc) {
		qWarning("allocating %s %p -> %p\n", classname, o->ptr, (void*)obj);
	}

/*
	if(m->type().isStack()) {
		o->allocated = true;
		// Keep a mapping of the pointer so that it is only wrapped once as a ruby VALUE
		mapPointer(obj, o, o->classId, 0);
	}
*/			

	*(m->var()) = obj;
}

template <>
void marshall_to_ruby<char *>(Marshall *m)
{
	char *sv = (char*)m->item().s_voidp;
	VALUE obj;
	if(sv)
		obj = rb_str_new2(sv);
	else
		obj = Qnil;

	if(m->cleanup())
		delete[] sv;

	*(m->var()) = obj;
}

template <>
void marshall_to_ruby<unsigned char *>(Marshall *m)
{
	m->unsupported();
}

#endif
// kate: space-indent false;
