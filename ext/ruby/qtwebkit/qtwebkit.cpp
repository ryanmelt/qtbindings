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

#include <smoke/qtwebkit_smoke.h>

#include <qtruby.h>

#include <iostream>

static VALUE getClassList(VALUE /*self*/)
{
    VALUE classList = rb_ary_new();
    for (int i = 1; i <= qtwebkit_Smoke->numClasses; i++) {
        if (qtwebkit_Smoke->classes[i].className && !qtwebkit_Smoke->classes[i].external) {
            rb_ary_push(classList, rb_str_new2(qtwebkit_Smoke->classes[i].className));
        }
    }
    return classList;
}

const char*
resolve_classname_qtwebkit(smokeruby_object * o)
{
    return qtruby_modules[o->smoke].binding->className(o->classId);
}

extern TypeHandler QtWebKit_handlers[];

extern "C" {

VALUE qtwebkit_module;
VALUE qtwebkit_internal_module;

static QtRuby::Binding binding;

Q_DECL_EXPORT void
Init_qtwebkit()
{
    init_qtwebkit_Smoke();

    binding = QtRuby::Binding(qtwebkit_Smoke);

    smokeList << qtwebkit_Smoke;

    QtRubyModule module = { "QtWebKit", resolve_classname_qtwebkit, 0, &binding };
    qtruby_modules[qtwebkit_Smoke] = module;

    install_handlers(QtWebKit_handlers);

    qtwebkit_module = rb_define_module("QtWebKit");
    qtwebkit_internal_module = rb_define_module_under(qtwebkit_module, "Internal");

    rb_define_singleton_method(qtwebkit_internal_module, "getClassList", (VALUE (*) (...)) getClassList, 0);

    rb_require("qtwebkit/qtwebkit.rb");
    rb_funcall(qtwebkit_internal_module, rb_intern("init_all_classes"), 0);
}

}
