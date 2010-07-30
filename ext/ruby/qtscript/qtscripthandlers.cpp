/***************************************************************************
                          qtscripthandlers.cpp  -  QtScript specific marshallers
                             -------------------
    begin                : 11-07-2008
    copyright            : (C) 2008 by Richard Dale
    email                : richard.j.dale@gmail.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

#include <ruby.h>
#undef read
#undef write
#undef connect
#undef accept

#include <qtruby.h>
#include <smokeruby.h>
#include <marshall_macros.h>

#include <qscriptvalue.h>


DEF_VALUELIST_MARSHALLER( QScriptValueList, QList<QScriptValue>, QScriptValue )

TypeHandler QtScript_handlers[] = {
    { "QList<QScriptValue>&", marshall_QScriptValueList },
    { 0, 0 }
};
