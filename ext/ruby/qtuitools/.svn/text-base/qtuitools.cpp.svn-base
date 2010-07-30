/***************************************************************************
                          qtuitoolshandlers.cpp  -  QtUiTools specific marshallers
                             -------------------
    begin                : Sat Jun 28 2008
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

#include <QHash>
#include <QList>
#include <QtDebug>

#include <smoke/qtuitools_smoke.h>

#include <qtruby.h>

#include <iostream>

static VALUE getClassList(VALUE /*self*/)
{
    VALUE classList = rb_ary_new();
    for (int i = 1; i <= qtuitools_Smoke->numClasses; i++) {
        if (qtuitools_Smoke->classes[i].className && !qtuitools_Smoke->classes[i].external)
            rb_ary_push(classList, rb_str_new2(qtuitools_Smoke->classes[i].className));
    }
    return classList;
}

const char*
resolve_classname_qtuitools(smokeruby_object * o)
{
    return qtruby_modules[o->smoke].binding->className(o->classId);
}

extern TypeHandler QtUiTools_handlers[];

extern "C" {

VALUE qtuitools_module;
VALUE qtuitools_internal_module;

static QtRuby::Binding binding;

Q_DECL_EXPORT void
Init_qtuitools()
{
    init_qtuitools_Smoke();

    binding = QtRuby::Binding(qtuitools_Smoke);

    smokeList << qtuitools_Smoke;

    QtRubyModule module = { "QtUiTools", resolve_classname_qtuitools, 0, &binding };
    qtruby_modules[qtuitools_Smoke] = module;

    install_handlers(QtUiTools_handlers);

    qtuitools_module = rb_define_module("QtUiTools");
    qtuitools_internal_module = rb_define_module_under(qtuitools_module, "Internal");

    rb_define_singleton_method(qtuitools_internal_module, "getClassList", (VALUE (*) (...)) getClassList, 0);

    rb_require("qtuitools/qtuitools.rb");
    rb_funcall(qtuitools_internal_module, rb_intern("init_all_classes"), 0);
}

}
