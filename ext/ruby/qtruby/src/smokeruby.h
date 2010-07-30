/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Lesser General Public License as        *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 ***************************************************************************/

#ifndef SMOKERUBY_H
#define SMOKERUBY_H

#include <smoke/smoke.h>

#undef DEBUG
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#ifndef __USE_POSIX
#define __USE_POSIX
#endif
#ifndef __USE_XOPEN
#define __USE_XOPEN
#endif
#include "ruby.h"

#include <QtCore/qbytearray.h>

#include "qtruby.h"
#include "marshall.h"


class SmokeRuby;

class SmokeType {
    Smoke::Type *_t;		// derived from _smoke and _id, but cached

    Smoke *_smoke;
    Smoke::Index _id;
public:
    SmokeType() : _t(0), _smoke(0), _id(0) {}
    SmokeType(Smoke *s, Smoke::Index i) : _smoke(s), _id(i) {
	if(_id < 0 || _id > _smoke->numTypes) _id = 0;
	_t = _smoke->types + _id;
    }
    // default copy constructors are fine, this is a constant structure

    // mutators
    void set(Smoke *s, Smoke::Index i) {
	_smoke = s;
	_id = i;
	_t = _smoke->types + _id;
    }

    // accessors
    Smoke *smoke() const { return _smoke; }
    Smoke::Index typeId() const { return _id; }
    const Smoke::Type &type() const { return *_t; }
    unsigned short flags() const { return _t->flags; }
    unsigned short elem() const { return _t->flags & Smoke::tf_elem; }
    const char *name() const { return _t->name; }
    Smoke::Index classId() const { return _t->classId; }

    // tests
    bool isStack() const { return ((flags() & Smoke::tf_ref) == Smoke::tf_stack); }
    bool isPtr() const { return ((flags() & Smoke::tf_ref) == Smoke::tf_ptr); }
    bool isRef() const { return ((flags() & Smoke::tf_ref) == Smoke::tf_ref); }
    bool isConst() const { return (flags() & Smoke::tf_const); }
    bool isClass() const {
	if(elem() == Smoke::t_class)
	    return classId() ? true : false;
	return false;
    }

    bool operator ==(const SmokeType &b) const {
	const SmokeType &a = *this;
	if(a.name() == b.name()) return true;
	if(a.name() && b.name() && qstrcmp(a.name(), b.name()) == 0)
	    return true;
	return false;
    }
    bool operator !=(const SmokeType &b) const {
	const SmokeType &a = *this;
	return !(a == b);
    }

};

class SmokeClass {
    Smoke::Class *_c;
    Smoke *_smoke;
    Smoke::Index _id;
public:
    SmokeClass(const SmokeType &t) {
	_smoke = t.smoke();
	_id = t.classId();
	_c = _smoke->classes + _id;
    }
    SmokeClass(Smoke *smoke, Smoke::Index id) : _smoke(smoke), _id(id) {
	_c = _smoke->classes + _id;
    }

    Smoke *smoke() const { return _smoke; }
    const Smoke::Class &c() const { return *_c; }
    Smoke::Index classId() const { return _id; }
    const char *className() const { return _c->className; }
    Smoke::ClassFn classFn() const { return _c->classFn; }
    Smoke::EnumFn enumFn() const { return _c->enumFn; }
    bool operator ==(const SmokeClass &b) const {
	const SmokeClass &a = *this;
	if(a.className() == b.className()) return true;
	if(a.className() && b.className() && qstrcmp(a.className(), b.className()) == 0)
	    return true;
	return false;
    }
    bool operator !=(const SmokeClass &b) const {
	const SmokeClass &a = *this;
	return !(a == b);
    }
    bool isa(const SmokeClass &sc) const {
	// This is a sick function, if I do say so myself
	if(*this == sc) return true;
	Smoke::Index *parents = _smoke->inheritanceList + _c->parents;
	for(int i = 0; parents[i]; i++) {
	    if(SmokeClass(_smoke, parents[i]).isa(sc)) return true;
	}
	return false;
    }

    unsigned short flags() const { return _c->flags; }
    bool hasConstructor() const { return flags() & Smoke::cf_constructor; }
    bool hasCopy() const { return flags() & Smoke::cf_deepcopy; }
    bool hasVirtual() const { return flags() & Smoke::cf_virtual; }
    bool hasFire() const { return !(flags() & Smoke::cf_undefined); }
};

/*
 * Simply using typeids isn't enough for signals/slots. It will be possible
 * to declare signals and slots which use arguments which can't all be
 * found in a single smoke object. Instead, we need to store smoke => typeid
 * pairs. We also need additional informatation, such as whether we're passing
 * a pointer to the union element.
 */

enum MocArgumentType {
    xmoc_ptr,
    xmoc_bool,
    xmoc_int,
    xmoc_uint,
    xmoc_long,
    xmoc_ulong,
    xmoc_double,
    xmoc_charstar,
    xmoc_QString,
    xmoc_void
};

struct MocArgument {
    // smoke object and associated typeid
    SmokeType st;
    MocArgumentType argType;
};

#endif // SMOKERUBY_H
