/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Lesser General Public License as        *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 ***************************************************************************/

#ifndef MARSHALL_COMPLEX_H
#define MARSHALL_COMPLEX_H

#include <QtCore/qlist.h>
#include <QtCore/qlinkedlist.h>
#include <QtCore/qvector.h>

template <>
void marshall_from_ruby<long long>(Marshall *m) 
{
	VALUE obj = *(m->var());
	m->item().s_voidp = new long long;
	*(long long *)m->item().s_voidp = ruby_to_primitive<long long>(obj);
	
	m->next();
	
	if(m->cleanup() && m->type().isConst()) {
		delete (long long int *) m->item().s_voidp;
	}	
}

template <>
void marshall_from_ruby<unsigned long long>(Marshall *m) 
{
	VALUE obj = *(m->var());
	m->item().s_voidp = new unsigned long long;
	*(long long *)m->item().s_voidp = ruby_to_primitive<unsigned long long>(obj);

	m->next();
	
	if(m->cleanup() && m->type().isConst()) {
		delete (long long int *) m->item().s_voidp;
	}	
}

template <>
void marshall_from_ruby<int *>(Marshall *m) 
{
	VALUE rv = *(m->var());
	int *i = new int;
	
	if (rv == Qnil) {
		m->item().s_voidp = 0;
		return;
	} else if (TYPE(rv) == T_OBJECT) {
		// A Qt::Integer has been passed as an integer value
		VALUE temp = rb_funcall(qt_internal_module, rb_intern("get_qinteger"), 1, rv);
		*i = NUM2INT(temp);
		m->item().s_voidp = i;
		m->next();
		rb_funcall(qt_internal_module, rb_intern("set_qinteger"), 2, rv, INT2NUM(*i));
		rv = temp;
	} else {
		*i = NUM2INT(rv);
		m->item().s_voidp = i;
		m->next();
	}

	if(m->cleanup() && m->type().isConst()) {
		delete i;
	} else {
		m->item().s_voidp = new int((int)NUM2INT(rv));
	}
}

template <>
void marshall_to_ruby<int *>(Marshall *m)
{
	int *ip = (int*)m->item().s_voidp;
	VALUE rv = *(m->var());
	if(!ip) {
		rv = Qnil;
		return;
	}
	
	*(m->var()) = INT2NUM(*ip);
	m->next();
	if(!m->type().isConst())
		*ip = NUM2INT(*(m->var()));
}

template <>
void marshall_from_ruby<unsigned int *>(Marshall *m) 
{
	VALUE rv = *(m->var());
	unsigned int *i = new unsigned int;
	
	if (rv == Qnil) {
		m->item().s_voidp = 0;
		return;
	} else if (TYPE(rv) == T_OBJECT) {
		// A Qt::Integer has been passed as an integer value
		VALUE temp = rb_funcall(qt_internal_module, rb_intern("get_qinteger"), 1, rv);
		*i = NUM2INT(temp);
		m->item().s_voidp = i;
		m->next();
		rb_funcall(qt_internal_module, rb_intern("set_qinteger"), 2, rv, INT2NUM(*i));
		rv = temp;
	} else {
		*i = NUM2UINT(rv);
		m->item().s_voidp = i;
		m->next();
	}

	if(m->cleanup() && m->type().isConst()) {
		delete i;
	} else {
		m->item().s_voidp = new int((int)NUM2UINT(rv));
	}
}

template <>
void marshall_to_ruby<unsigned int *>(Marshall *m)
{
	unsigned int *ip = (unsigned int*) m->item().s_voidp;
	VALUE rv = *(m->var());
	if (ip == 0) {
		rv = Qnil;
		return;
	}
	
	*(m->var()) = UINT2NUM(*ip);
	m->next();
	if(!m->type().isConst())
		*ip = NUM2UINT(*(m->var()));
}

template <>
void marshall_from_ruby<bool *>(Marshall *m) 
{
   VALUE rv = *(m->var());
	bool * b = new bool;

	if (TYPE(rv) == T_OBJECT) {
		// A Qt::Boolean has been passed as a value
		VALUE temp = rb_funcall(qt_internal_module, rb_intern("get_qboolean"), 1, rv);
		*b = (temp == Qtrue ? true : false);
		m->item().s_voidp = b;
		m->next();
		rb_funcall(qt_internal_module, rb_intern("set_qboolean"), 2, rv, (*b ? Qtrue : Qfalse));
	} else {
		*b = (rv == Qtrue ? true : false);
		m->item().s_voidp = b;
		m->next();
	}

	if(m->cleanup() && m->type().isConst()) {
		delete b;
	}
}

template <>
void marshall_to_ruby<bool *>(Marshall *m)
{
	bool *ip = (bool*)m->item().s_voidp;
	if(!ip) {
		*(m->var()) = Qnil;
		return;
	}
	*(m->var()) = (*ip?Qtrue:Qfalse);
	m->next();
	if(!m->type().isConst())
	*ip = *(m->var()) == Qtrue ? true : false;
}

#endif
