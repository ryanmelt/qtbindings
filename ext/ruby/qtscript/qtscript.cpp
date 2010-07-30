/***************************************************************************
                          qtscript.cpp  -  QtScript ruby extension
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

#include <QHash>
#include <QList>
#include <QtDebug>

#include <smoke/qtscript_smoke.h>

#include <qtruby.h>

#include <iostream>

static VALUE getClassList(VALUE /*self*/)
{
    VALUE classList = rb_ary_new();
    for (int i = 1; i <= qtscript_Smoke->numClasses; i++) {
        if (qtscript_Smoke->classes[i].className && !qtscript_Smoke->classes[i].external)
            rb_ary_push(classList, rb_str_new2(qtscript_Smoke->classes[i].className));
    }
    return classList;
}

const char*
resolve_classname_qtscript(smokeruby_object * o)
{
    return qtruby_modules[o->smoke].binding->className(o->classId);
}

extern TypeHandler QtScript_handlers[];

extern "C" {

VALUE qtscript_module;
VALUE qtscript_internal_module;

static QtRuby::Binding binding;

Q_DECL_EXPORT void
Init_qtscript()
{
    init_qtscript_Smoke();

    binding = QtRuby::Binding(qtscript_Smoke);

    smokeList << qtscript_Smoke;

    QtRubyModule module = { "QtScript", resolve_classname_qtscript, 0, &binding };
    qtruby_modules[qtscript_Smoke] = module;

    install_handlers(QtScript_handlers);

    qtscript_module = rb_define_module("QtScript");
    qtscript_internal_module = rb_define_module_under(qtscript_module, "Internal");

    rb_define_singleton_method(qtscript_internal_module, "getClassList", (VALUE (*) (...)) getClassList, 0);

    rb_require("qtscript/qtscript.rb");
    rb_funcall(qtscript_internal_module, rb_intern("init_all_classes"), 0);
}

}
