/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Lesser General Public License as        *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 ***************************************************************************/

#ifndef MARSHALL_H
#define MARSHALL_H

#include <smoke/smoke.h>
#include "time.h"
#define timespec ming_timespec
#define timezone ming_timezone
#include <ruby.h>
#undef timespec
#undef timezone

class SmokeType;

class Marshall {
public:
    /**
     * FromVALUE is used for virtual function return values and regular
     * method arguments.
     *
     * ToVALUE is used for method return-values and virtual function
     * arguments.
     */
    typedef void (*HandlerFn)(Marshall *);
    enum Action { FromVALUE, ToVALUE };
    virtual SmokeType type() = 0;
    virtual Action action() = 0;
    virtual Smoke::StackItem &item() = 0;
    virtual VALUE * var() = 0;
    virtual void unsupported() = 0;
    virtual Smoke *smoke() = 0;
    /**
     * For return-values, next() does nothing.
     * For FromRV, next() calls the method and returns.
     * For ToRV, next() calls the virtual function and returns.
     *
     * Required to reset Marshall object to the state it was
     * before being called when it returns.
     */
    virtual void next() = 0;
    /**
     * For FromSV, cleanup() returns false when the handler should free
     * any allocated memory after next().
     *
     * For ToSV, cleanup() returns true when the handler should delete
     * the pointer passed to it.
     */
    virtual bool cleanup() = 0;

    virtual ~Marshall() {}
};

class SmokeEnumWrapper {
public:
  Marshall *m;
};

class SmokeClassWrapper {
public:
  Marshall *m;
};

#endif
