#include <ruby.h>
#undef read
#undef write
#undef connect
#undef accept

#include <QHash>
#include <QList>
#include <QtDebug>

#include <smoke/qtdeclarative_smoke.h>

#include <qtruby.h>

#include <iostream>

static VALUE getClassList(VALUE /*self*/)
{
    VALUE classList = rb_ary_new();
    for (int i = 1; i <= qtdeclarative_Smoke->numClasses; i++) {
        if (qtdeclarative_Smoke->classes[i].className && !qtdeclarative_Smoke->classes[i].external) {
            rb_ary_push(classList, rb_str_new2(qtdeclarative_Smoke->classes[i].className));
        }
    }
    return classList;
}

const char*
resolve_classname_qtdeclarative(smokeruby_object * o)
{
    return qtruby_modules[o->smoke].binding->className(o->classId);
}

extern TypeHandler QtDeclarative_handlers[];

extern "C" {

VALUE qtdeclarative_module;
VALUE qtdeclarative_internal_module;

static QtRuby::Binding binding;

Q_DECL_EXPORT void
Init_qtdeclarative()
{
    init_qtdeclarative_Smoke();

    binding = QtRuby::Binding(qtdeclarative_Smoke);

    smokeList << qtdeclarative_Smoke;

    QtRubyModule module = { "QtDeclarative", resolve_classname_qtdeclarative, 0, &binding };
    qtruby_modules[qtdeclarative_Smoke] = module;

    install_handlers(QtDeclarative_handlers);

    qtdeclarative_module = rb_define_module("QtDeclarative");
    qtdeclarative_internal_module = rb_define_module_under(qtdeclarative_module, "Internal");

    rb_define_singleton_method(qtdeclarative_internal_module, "getClassList", (VALUE (*) (...)) getClassList, 0);

    rb_require("qtdeclarative/qtdeclarative.rb");
    rb_funcall(qtdeclarative_internal_module, rb_intern("init_all_classes"), 0);
}

}
