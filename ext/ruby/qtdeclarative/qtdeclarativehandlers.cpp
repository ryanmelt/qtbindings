/***************************************************************************
                          qtdeclarativehandlers.cpp  -  QtDeclarative specific marshallers
                             -------------------
    begin                : Thurs Aug 12 2010
    copyright            : (C) 2010 by Richard Dale
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

#include <QtDeclarative/QDeclarativeError>

DEF_VALUELIST_MARSHALLER( QDeclarativeErrorList, QList<QDeclarativeError>, QDeclarativeError )

TypeHandler QtDeclarative_handlers[] = {
    { "QList<QDeclarativeError>", marshall_QDeclarativeErrorList },
    { 0, 0 }
};
