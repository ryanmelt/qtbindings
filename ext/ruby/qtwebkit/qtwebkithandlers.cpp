/***************************************************************************
                          qtwebkithandlers.cpp  -  QtWebKit specific marshallers
                             -------------------
    begin                : Sun Sep 28 2003
    copyright            : (C) 2003 by Richard Dale
    email                : Richard_Dale@tipitina.demon.co.uk
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
#undef truncate

#include <qtruby.h>
#include <smokeruby.h>
#include <marshall_macros.h>

#include <QtWebKit/qwebframe.h>
#include <QtWebKit/qwebhistory.h>

DEF_LIST_MARSHALLER( QWebFrameList, QList<QWebFrame*>, QWebFrame )

DEF_VALUELIST_MARSHALLER( QWebHistoryItemList, QList<QWebHistoryItem>, QWebHistoryItem )

TypeHandler QtWebKit_handlers[] = {
    { "QList<QWebFrame*>", marshall_QWebFrameList },
    { "QList<QWebHistoryItem>", marshall_QWebHistoryItemList },
    { 0, 0 }
};
