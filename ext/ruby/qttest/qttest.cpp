/***************************************************************************
                          qttest.cpp  -  QtTest ruby extension
                             -------------------
    begin                : 29-10-2008
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

#include "time.h"
#define timespec ming_timespec
#define timezone ming_timezone
#include <ruby.h>
#undef timespec
#undef timezone
#undef read
#undef write
#undef connect
#undef accept
#undef truncate

#include <QHash>
#include <QList>
#include <QtDebug>

#include <smoke/qttest_smoke.h>

#include <qtruby.h>

#include <iostream>

static VALUE getClassList(VALUE /*self*/)
{
    VALUE classList = rb_ary_new();
    for (int i = 1; i <= qttest_Smoke->numClasses; i++) {
        if (qttest_Smoke->classes[i].className && !qttest_Smoke->classes[i].external)
            rb_ary_push(classList, rb_str_new2(qttest_Smoke->classes[i].className));
    }
    return classList;
}

const char*
resolve_classname_qttest(smokeruby_object * o)
{
    return qtruby_modules[o->smoke].binding->className(o->classId);
}

extern TypeHandler QtTest_handlers[];

extern "C" {

VALUE qttest_module;
VALUE qttest_internal_module;

static QtRuby::Binding binding;

Q_DECL_EXPORT void
Init_qttest()
{
    init_qttest_Smoke();

    binding = QtRuby::Binding(qttest_Smoke);

    smokeList << qttest_Smoke;

    QtRubyModule module = { "QtTest", resolve_classname_qttest, 0, &binding };
    qtruby_modules[qttest_Smoke] = module;

    install_handlers(QtTest_handlers);

    qttest_module = rb_define_module("QtTest");
    qttest_internal_module = rb_define_module_under(qttest_module, "Internal");

    rb_define_singleton_method(qttest_internal_module, "getClassList", (VALUE (*) (...)) getClassList, 0);

    rb_require("qttest/qttest.rb");
    rb_funcall(qttest_internal_module, rb_intern("init_all_classes"), 0);
}

}
