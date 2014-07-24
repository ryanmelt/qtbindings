/*
    Generator for the SMOKE sources
    Copyright (C) 2009 Arno Rehn <arno@arnorehn.de>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#include <QFileInfo>
#include <QHash>
#include <QList>
#include <QLibrary>
#include <QStack>
#include <QDir>

#include <type.h>
#include <smoke.h>

#include "globals.h"
#include "../../options.h"

//typedef void (*InitSmokeFn)();

QHash<QString, QString> Util::typeMap;
QHash<const Method*, const Function*> Util::globalFunctionMap;
QHash<const Method*, const Field*> Util::fieldAccessors;

// looks up the inheritance path from desc to super and sets 'virt' to true if it encounters a virtual base
static bool isVirtualInheritancePathPrivate(const Class* desc, const Class* super, bool *virt)
{
    foreach (const Class::BaseClassSpecifier bspec, desc->baseClasses()) {
        if (bspec.baseClass == super || isVirtualInheritancePathPrivate(bspec.baseClass, super, virt)) {
            if (bspec.isVirtual)
                *virt = true;
            return true;
        }
    }
    return false;
}

bool Util::isVirtualInheritancePath(const Class* desc, const Class* super)
{
    bool isVirtual = false;
    isVirtualInheritancePathPrivate(desc, super, &isVirtual);
    return isVirtual;
}

QList<const Class*> Util::superClassList(const Class* klass)
{
    static QHash<const Class*, QList<const Class*> > superClassCache;

    QList<const Class*> ret;
    if (superClassCache.contains(klass))
        return superClassCache[klass];
    foreach (const Class::BaseClassSpecifier& base, klass->baseClasses()) {
        ret << base.baseClass;
        ret += superClassList(base.baseClass);
    }
    // cache
    superClassCache[klass] = ret;
    return ret;
}

QList<const Class*> Util::descendantsList(const Class* klass)
{
    static QHash<const Class*, QList<const Class*> > descendantsClassCache;

    QList<const Class*> ret;
    if (descendantsClassCache.contains(klass))
        return descendantsClassCache[klass];
    for (QHash<QString, Class>::const_iterator iter = classes.constBegin(); iter != classes.constEnd(); iter++) {
        if (superClassList(&iter.value()).contains(klass))
            ret << &iter.value();
    }
    // cache
    descendantsClassCache[klass] = ret;
    return ret;
}

bool operator==(const Field& lhs, const Field& rhs)
{
    return (lhs.name() == rhs.name() && lhs.declaringType() == rhs.declaringType() && lhs.type() == rhs.type());
}

bool operator==(const EnumMember& lhs, const EnumMember& rhs)
{
    return (lhs.name() == rhs.name() && lhs.declaringType() == rhs.declaringType() && lhs.type() == rhs.type());
}

//static Smoke* loadSmokeModule(QString moduleName) {
//    QLibrary lib;
//#if defined(Q_OS_WIN32)
//    QString libName = QLatin1String("smoke") + moduleName;
//#else
//    QString libName = QLatin1String("libsmoke") + moduleName;
//#endif
//
//    // first, try <libdir>/moduleName/libsmokemoduleName
//    lib.setFileName(Options::libDir.filePath(moduleName + '/' + libName));
//
//    // then <libdir>/libsmokemoduleName
//    if (!lib.load()) {
//        lib.setFileName(Options::libDir.filePath(libName));
//    }
//
//    // use the plain library name if everything else fails
//    if (!lib.load()) {
//        lib.setFileName(libName);
//    }
//
//    lib.load();
//
//    QString init_name = "init_" + moduleName + "_Smoke";
//    InitSmokeFn init = (InitSmokeFn) lib.resolve(init_name.toLatin1());
//
//    if (!init) {
//        qWarning("Couldn't resolve %s: %s", qPrintable(init_name), qPrintable(lib.errorString()));
//        return 0;
//    }
//
//    (*init)();
//
//    QString smoke_name = moduleName + "_Smoke";
//    Smoke** smoke = (Smoke**) lib.resolve(smoke_name.toLatin1());
//    if (!smoke) {
//        qWarning("Couldn't resolve %s: %s", qPrintable(smoke_name), qPrintable(lib.errorString()));
//        return 0;
//    }
//
//    return *smoke;
//}
//
//static bool compareArgs(const Method& method, const Smoke::Method& smokeMethod, Smoke* smoke) {
//    if (method.parameters().count() != smokeMethod.numArgs) {
//        return false;
//    }
//    for (int i = 0; i < method.parameters().count(); i++) {
//        const Parameter& p = method.parameters()[i];
//        if (p.type()->toString() != QLatin1String(smoke->types[smoke->argumentList[smokeMethod.args + i]].name)) {
//            return false;
//        }
//    }
//    return true;
//}
//
//static bool isRepeating(const QList<Smoke*>& parentModules, const char* className, const Method& method) {
//    QString mungedName = Util::mungedName(method).toLatin1();
//    foreach (Smoke* smoke, parentModules) {
//        Smoke::ModuleIndex methodIndex = smoke->findMethod(className, mungedName.toLatin1().constData());
//        if (methodIndex.index) {
//            Smoke::Index index = methodIndex.smoke->methodMaps[methodIndex.index].method;
//            if (index >= 0) {
//                if (compareArgs(method, methodIndex.smoke->methods[index], methodIndex.smoke)) {
//                    return true;
//                }
//                continue;
//            }
//            index = -index;
//            Smoke::Index i;
//            while ((i = methodIndex.smoke->ambiguousMethodList[index++]) != 0) {
//                if (compareArgs(method, methodIndex.smoke->methods[i], methodIndex.smoke)) {
//                    return true;
//                }
//            }
//        }
//    }
//    return false;
//}
//
//// assuming that enums don't change between modules, checking for the first member only is sufficient
//static bool isRepeating(const QList<Smoke*>& parentModules, const char* className, const Enum& eNum) {
//    if (eNum.members().isEmpty())
//        return false;
//
//    const EnumMember& firstMember = eNum.members().first();
//
//    foreach(Smoke *smoke, parentModules) {
//        Smoke::ModuleIndex methodIndex = smoke->findMethod(className, firstMember.name().toLatin1().constData());
//        if (methodIndex.index)
//            return true;
//    }
//    return false;
//}

void Util::preparse(QSet<Type*> *usedTypes, QSet<const Class*> *superClasses, const QList<QString>& keys)
{
    Class& globalSpace = classes["QGlobalSpace"];
    globalSpace.setName("QGlobalSpace");
    globalSpace.setKind(Class::Kind_Class);
    globalSpace.setIsNameSpace(true);

    //QList<Smoke*> parentModules;
    //foreach (QString module, Options::parentModules) {
    //    Smoke *smoke = loadSmokeModule(module);
    //    if (smoke) {
    //        parentModules << smoke;
    //    }
    //}

    // add all functions as methods to a class called 'QGlobalSpace' or a class that represents a namespace
    for (QHash<QString, Function>::const_iterator it = functions.constBegin(); it != functions.constEnd(); it++) {
        const Function& fn = it.value();

        QString fnString = fn.toString();

        // gcc doesn't like this function... for whatever reason
        if (fn.name() == "_IO_ftrylockfile"
            // functions in named namespaces are covered by the class list - only check for top-level functions here
            || (fn.nameSpace().isEmpty() && !Options::functionNameIncluded(fn.qualifiedName()) && !Options::functionSignatureIncluded(fnString))
            || Options::typeExcluded(fnString))
        {
            // we don't want that function...
            continue;
        }

        Class* parent = &globalSpace;
        if (!fn.nameSpace().isEmpty()) {
            parent = &classes[fn.nameSpace()];
            if (parent->name().isEmpty()) {
                parent->setName(fn.nameSpace());
                parent->setKind(Class::Kind_Class);
                parent->setIsNameSpace(true);
            }
        }

        Method meth = Method(parent, fn.name(), fn.type(), Access_public, fn.parameters());
        meth.setFlag(Method::Static);
        //if (isRepeating(parentModules, parent->name().toLatin1(), meth)) {
        //    continue;
        //}
        parent->appendMethod(meth);
        // map this method to the function, so we can later retrieve the header it was defined in
        globalFunctionMap[&parent->methods().last()] = &fn;

        int methIndex = parent->methods().size() - 1;
        addOverloads(meth);
        // handle the methods appended by addOverloads()
        for (int i = parent->methods().size() - 1; i > methIndex; --i)
            globalFunctionMap[&parent->methods()[i]] = &fn;

        (*usedTypes) << meth.type();
        foreach (const Parameter& param, meth.parameters())
            (*usedTypes) << param.type();
    }

    // all enums that don't have a parent are put under QGlobalSpace, too
    for (QHash<QString, Enum>::iterator it = enums.begin(); it != enums.end(); it++) {
        Enum& e = it.value();
        if (!e.parent()) {
            Class* parent = &globalSpace;
            // if the enum is defined in a namespace, make that the enum's parent
            if (!e.nameSpace().isEmpty()) {
                parent = &classes[e.nameSpace()];
                if (parent->name().isEmpty()) {
                    parent->setName(e.nameSpace());
                    parent->setKind(Class::Kind_Class);
                    parent->setIsNameSpace(true);
                }
            // else, see if it is already defined in a parent module
            //} else if (isRepeating(parentModules, parent->name().toLatin1(), e)) {
            //    continue;
            }

            Type *t = 0;
            if (e.name().isEmpty()) {
                // unnamed enum
                Type longType = Type("long");
                longType.setIsIntegral(true);
                t = Type::registerType(longType);
            } else {
                t = Type::registerType(Type(&e));
            }
            (*usedTypes) << t;
            parent->appendChild(&e);
        }
    }

    //foreach (Smoke* smoke, parentModules) {
    //    delete smoke;
    //}

    foreach (const QString& key, keys) {
        Class& klass = classes[key];
        foreach (const Class::BaseClassSpecifier base, klass.baseClasses()) {
            superClasses->insert(base.baseClass);
        }
        if (!klass.isNameSpace()) {
            addDefaultConstructor(&klass);
            addCopyConstructor(&klass);
            addDestructor(&klass);
            checkForAbstractClass(&klass);
            foreach (const Method& m, klass.methods()) {
                if (m.access() == Access_private)
                    continue;
                if (hasTypeNonPublicParts(*m.type())
                    || Options::typeExcluded(m.toString(false, true)))
                {
                    klass.methodsRef().removeOne(m);
                    continue;
                }
                addOverloads(m);
                (*usedTypes) << m.type();
                foreach (const Parameter& param, m.parameters()) {
                    (*usedTypes) << param.type();

                    if (m.isSlot() || m.isSignal() || m.isQPropertyAccessor()) {
                        (*usedTypes) << Util::normalizeType(param.type());
                    }
                }
            }
            foreach (const Field& f, klass.fields()) {
                if (f.access() == Access_private)
                    continue;
                if (Options::typeExcluded(f.toString(false, true))) {
                    klass.fieldsRef().removeOne(f);
                    continue;
                }
            }
            foreach (const Field& f, klass.fields()) {
                if (f.access() == Access_private)
                    continue;
                addAccessorMethods(f, usedTypes);
            }
        }
        foreach (BasicTypeDeclaration* decl, klass.children()) {
            Enum* e = 0;
            if ((e = dynamic_cast<Enum*>(decl))) {
                Type *t = 0;
                if (e->name().isEmpty()) {
                    // unnamed enum
                    Type longType = Type("long");
                    longType.setIsIntegral(true);
                    t = Type::registerType(longType);
                } else {
                    t = Type::registerType(Type(e));
                }
                (*usedTypes) << t;
                foreach (const EnumMember& member, e->members()) {
                    if (Options::typeExcluded(member.toString())) {
                        e->membersRef().removeOne(member);
                    }
                }
            }

        }

    }
}

bool Util::canClassBeInstanciated(const Class* klass)
{
    static QHash<const Class*, bool> cache;
    if (cache.contains(klass))
        return cache[klass];

    bool ctorFound = false, publicCtorFound = false, privatePureVirtualsFound = false;
    foreach (const Method& meth, klass->methods()) {
        if (meth.isConstructor()) {
            ctorFound = true;
            if (meth.access() != Access_private) {
                // this class can be instanstiated
                publicCtorFound = true;
            }
        } else if ((meth.flags() & Method::PureVirtual) && meth.access() == Access_private) {
            privatePureVirtualsFound = true;
        }
    }

    // The class can be instanstiated if it has a public constructor or no constructor at all
    // because then it has a default one generated by the compiler.
    // If it has private pure virtuals, then it can't be instanstiated either.
    bool ret = ((publicCtorFound || !ctorFound) && !privatePureVirtualsFound);
    cache[klass] = ret;
    return ret;
}

bool Util::canClassBeCopied(const Class* klass)
{
    static QHash<const Class*, bool> cache;
    if (cache.contains(klass))
        return cache[klass];

    bool privateCopyCtorFound = false;
    foreach (const Method& meth, klass->methods()) {
        if (meth.access() != Access_private)
            continue;
        if (meth.isConstructor() && meth.parameters().count() == 1) {
            const Type* type = meth.parameters()[0].type();
            // c'tor should be Foo(const Foo& copy)
            if (type->isConst() && type->isRef() && type->getClass() == klass) {
                privateCopyCtorFound = true;
                break;
            }
        }
    }

    bool parentCanBeCopied = true;
    foreach (const Class::BaseClassSpecifier& base, klass->baseClasses()) {
        if (!canClassBeCopied(base.baseClass)) {
            parentCanBeCopied = false;
            break;
        }
    }

    // if the parent can be copied and we didn't find a private copy c'tor, the class is copiable
    bool ret = (parentCanBeCopied && !privateCopyCtorFound);
    cache[klass] = ret;
    return ret;
}

bool Util::hasClassVirtualDestructor(const Class* klass)
{
    static QHash<const Class*, bool> cache;
    if (cache.contains(klass))
        return cache[klass];

    bool virtualDtorFound = false;
    foreach (const Method& meth, klass->methods()) {
        if (meth.isDestructor() && meth.flags() & Method::Virtual) {
            virtualDtorFound = true;
            break;
        }
    }

    bool superClassHasVirtualDtor = false;
    foreach (const Class::BaseClassSpecifier& bspec, klass->baseClasses()) {
        if (hasClassVirtualDestructor(bspec.baseClass)) {
            superClassHasVirtualDtor = true;
            break;
        }
    }

    // if the superclass has a virtual d'tor, then the descendants have one automatically, too
    bool ret = (virtualDtorFound || superClassHasVirtualDtor);
    cache[klass] = ret;
    return ret;
}

bool Util::hasClassPublicDestructor(const Class* klass)
{
    static QHash<const Class*, bool> cache;
    if (cache.contains(klass))
        return cache[klass];

    if (klass->isNameSpace()) {
        cache[klass] = false;
        return false;
    }

    bool publicDtorFound = true;
    foreach (const Method& meth, klass->methods()) {
        if (meth.isDestructor()) {
            if (meth.access() != Access_public)
                publicDtorFound = false;
            // a class has only one destructor, so break here
            break;
        }
    }

    cache[klass] = publicDtorFound;
    return publicDtorFound;
}

const Method* Util::findDestructor(const Class* klass)
{
    foreach (const Method& meth, klass->methods()) {
        if (meth.isDestructor()) {
            return &meth;
        }
    }
    const Method* dtor = 0;
    foreach (const Class::BaseClassSpecifier& bspec, klass->baseClasses()) {
        if ((dtor = findDestructor(bspec.baseClass))) {
            return dtor;
        }
    }
    return 0;
}

void Util::checkForAbstractClass(Class* klass)
{
    QList<const Method*> list;

    bool hasPrivatePureVirtuals = false;
    foreach (const Method& meth, klass->methods()) {
        if ((meth.flags() & Method::PureVirtual) && meth.access() == Access_private)
            hasPrivatePureVirtuals = true;
        if (meth.isConstructor())
            list << &meth;
    }

    // abstract classes can't be instanstiated - remove the constructors
    if (hasPrivatePureVirtuals) {
        foreach (const Method* ctor, list) {
            klass->methodsRef().removeOne(*ctor);
        }
    }
}

void Util::addDefaultConstructor(Class* klass)
{
    foreach (const Method& meth, klass->methods()) {
        // if the class already has a constructor or if it has pure virtuals, there's nothing to do for us
        if (meth.isConstructor())
            return;
        else if (meth.isDestructor() && meth.access() == Access_private)
            return;
    }

    Type t = Type(klass);
    t.setPointerDepth(1);
    Method meth = Method(klass, klass->name(), Type::registerType(t));
    meth.setIsConstructor(true);
    klass->appendMethod(meth);
}

void Util::addCopyConstructor(Class* klass)
{
    foreach (const Method& meth, klass->methods()) {
        if (meth.isConstructor() && meth.parameters().count() == 1) {
            const Type* type = meth.parameters()[0].type();
            // found a copy c'tor? then there's nothing to do
            if (type->isRef() && type->getClass() == klass)
                return;
        } else if (meth.isDestructor() && meth.access() == Access_private) {
            // private destructor, so we can't create instances of that class
            return;
        }
    }

    // if the parent can't be copied, a copy c'tor is of no use
    foreach (const Class::BaseClassSpecifier& base, klass->baseClasses()) {
        if (!canClassBeCopied(base.baseClass))
            return;
    }

    Type t = Type(klass);
    t.setPointerDepth(1);
    Method meth = Method(klass, klass->name(), Type::registerType(t));
    meth.setIsConstructor(true);
    // parameter is a constant reference to another object of the same types
    Type paramType = Type(klass, true); paramType.setIsRef(true);
    meth.appendParameter(Parameter("copy", Type::registerType(paramType)));
    klass->appendMethod(meth);
}

void Util::addDestructor(Class* klass)
{
    foreach (const Method& meth, klass->methods()) {
        // we already have a destructor
        if (meth.isDestructor())
            return;
    }

    Method meth = Method(klass, "~" + klass->name(), const_cast<Type*>(Type::Void));
    meth.setIsDestructor(true);

    const Method* dtor = findDestructor(klass);
    if (dtor && dtor->hasExceptionSpec()) {
        meth.setHasExceptionSpec(true);
        foreach (const Type& t, dtor->exceptionTypes()) {
            meth.appendExceptionType(t);
        }
    }

    klass->appendMethod(meth);
}

QChar Util::munge(const Type *type) {
    if (type->getTypedef()) {
        Type resolved = type->getTypedef()->resolve();
        return munge(&resolved);
    }

    if (type->pointerDepth() > 1 || (type->getClass() && type->getClass()->isTemplate() && (!Options::qtMode || (Options::qtMode && type->getClass()->name() != "QFlags"))) ||
        (Options::voidpTypes.contains(type->name()) && !Options::scalarTypes.contains(type->name())) )
    {
        // QString and QStringList are both mapped to Smoke::t_voidp, but QString is a scalar as well
        // TODO: fix this - neither QStringList nor QString should be mapped to Smoke::t_voidp or munged as ? or $

        // reference to array or hash or unknown
        return '?';
    } else if (type->isIntegral() || type->getEnum() || Options::scalarTypes.contains(type->name()) ||
                (Options::qtMode && !type->isRef() && type->pointerDepth() == 0 &&
                (type->getClass() && type->getClass()->isTemplate() && type->getClass()->name() == "QFlags")))
    {
        // plain scalar
        return '$';
    } else if (type->getClass()) {
        // object
        return '#';
    } else {
        // unknown
        return '?';
    }
}

QString Util::mungedName(const Method& meth) {
    QString ret = meth.name();
    foreach (const Parameter& param, meth.parameters()) {
        const Type* type = param.type();
        ret += munge(type);
   }
    return ret;
}

Type* Util::normalizeType(const Type* type) {
    Type normalizedType = *type;
    if (normalizedType.isConst() && normalizedType.isRef()) {
        normalizedType.setIsConst(false);
        normalizedType.setIsRef(false);
    }

    if (normalizedType.pointerDepth() == 0) {
        normalizedType.setIsConst(false);
    }

    return Type::registerType(normalizedType);
}

bool Util::hasTypeNonPublicParts(const Type& type)
{
    if (type.getClass() && type.getClass()->access() != Access_public) {
        return true;
    }

    foreach (const Type& t, type.templateArguments()) {
        if (hasTypeNonPublicParts(t)) {
            return true;
        }
    }

    return false;
}

QString Util::stackItemField(const Type* type)
{
    if (type->getTypedef()) {
        Type resolved = type->getTypedef()->resolve();
        return stackItemField(&resolved);
    }

    if (Options::qtMode && !type->isRef() && type->pointerDepth() == 0 &&
        type->getClass() && type->getClass()->isTemplate() && type->getClass()->name() == "QFlags")
    {
        return "s_uint";
    }

    if (type->pointerDepth() > 0 || type->isRef() || type->isFunctionPointer() || type->isArray() || Options::voidpTypes.contains(type->name())
        || (!type->isIntegral() && !type->getEnum()))
    {
        return "s_class";
    }

    if (type->getEnum())
        return "s_enum";

    QString typeName = type->name();
    // replace the unsigned stuff, look the type up in Util::typeMap and if
    // necessary, add a 'u' for unsigned types at the beginning again
    bool _unsigned = false;
    if (typeName.startsWith("unsigned ")) {
        typeName.replace("unsigned ", "");
        _unsigned = true;
    }
    typeName.replace("signed ", "");
    typeName = Util::typeMap.value(typeName, typeName);
    if (_unsigned)
        typeName.prepend('u');
    return "s_" + typeName;
}

QString Util::assignmentString(const Type* type, const QString& var)
{
    if (type->getTypedef()) {
        Type resolved = type->getTypedef()->resolve();
        return assignmentString(&resolved, var);
    }

    if (type->pointerDepth() > 0 || type->isFunctionPointer()) {
        return "(void*)" + var;
    } else if (type->isRef()) {
        return "(void*)&" + var;
    } else if (type->isIntegral() && !Options::voidpTypes.contains(type->name())) {
        return var;
    } else if (type->getEnum()) {
        return var;
    } else if (Options::qtMode && type->getClass() && type->getClass()->isTemplate() && type->getClass()->name() == "QFlags")
    {
        return "(uint)" + var;
    } else {
        QString ret = "(void*)new " + type->toString();
        ret += '(' + var + ')';
        return ret;
    }
    return QString();
}

QList<const Method*> Util::collectVirtualMethods(const Class* klass)
{
    QList<const Method*> methods;
    foreach (const Method& meth, klass->methods()) {
        if ((meth.flags() & Method::Virtual || meth.flags() & Method::PureVirtual)
            && !meth.isDestructor() && meth.access() != Access_private)
        {
            methods << &meth;
        }
    }
    foreach (const Class::BaseClassSpecifier& baseClass, klass->baseClasses()) {
        methods += collectVirtualMethods(baseClass.baseClass);
    }
    return methods;
}

// don't make this public - it's just a utility function for the next method and probably not what you would expect it to be
static bool operator==(const Method& rhs, const Method& lhs)
{
    // These have to be equal for methods to be the same. Return types don't have an effect, ignore them.
    bool ok = (rhs.name() == lhs.name() && rhs.isConst() == lhs.isConst() && rhs.parameters().count() == lhs.parameters().count());
    if (!ok)
        return false;

    // now check the parameter types for equality
    for (int i = 0; i < rhs.parameters().count(); i++) {
        if (rhs.parameters()[i].type() != lhs.parameters()[i].type())
            return false;
    }

    return true;
}

void Util::addAccessorMethods(const Field& field, QSet<Type*> *usedTypes)
{
    Class* klass = field.getClass();
    Type* type = field.type();
    if (type->getClass() && type->pointerDepth() == 0 && !(ParserOptions::qtMode && type->getClass()->name() == "QFlags")) {
        Type newType = *type;
        newType.setIsRef(true);
        type = Type::registerType(newType);
    }
    (*usedTypes) << type;
    Method getter = Method(klass, field.name(), type, field.access());
    getter.setIsConst(true);
    if (field.flags() & Field::Static)
        getter.setFlag(Method::Static);
    klass->appendMethod(getter);
    fieldAccessors[&klass->methods().last()] = &field;

    // constant field? (i.e. no setter method)
    if (field.type()->isConst() && field.type()->pointerDepth() == 0)
        return;

    // foo => setFoo
    QString newName = field.name();
    newName[0] = newName[0].toUpper();
    Method setter = Method(klass, "set" + newName, const_cast<Type*>(Type::Void), field.access());
    if (field.flags() & Field::Static)
        setter.setFlag(Method::Static);

    // reset
    type = field.type();
    // to avoid copying around more stuff than necessary, convert setFoo(Bar) to setFoo(const Bar&)
    if (type->pointerDepth() == 0 && type->getClass() && !(ParserOptions::qtMode && type->getClass()->name() == "QFlags")) {
        Type newType = *type;
        newType.setIsRef(true);
        newType.setIsConst(true);
        type = Type::registerType(newType);
    }

    (*usedTypes) << type;
    setter.appendParameter(Parameter(QString(), type));
    if (klass->methods().contains(setter))
        return;
    klass->appendMethod(setter);
    fieldAccessors[&klass->methods().last()] = &field;
}

void Util::addOverloads(const Method& meth)
{
    ParameterList params;
    Class* klass = meth.getClass();

    for (int i = 0; i < meth.parameters().count(); i++) {
        const Parameter& param = meth.parameters()[i];
        if (!param.isDefault()) {
            params << param;
            continue;
        }
        Method overload = meth;
        if (meth.flags() & Method::PureVirtual) {
            overload.setFlag(Method::DynamicDispatch);
        }
        overload.removeFlag(Method::Virtual);
        overload.removeFlag(Method::PureVirtual);
        overload.setParameterList(params);
        if (klass->methods().contains(overload)) {
            // we already have that, skip it
            params << param;
            continue;
        }

        QStringList remainingDefaultValues;
        for (int j = i; j < meth.parameters().count(); j++) {
            const Parameter defParam = meth.parameters()[j];
            QString cast = "(";
            cast += defParam.type()->toString() + ')';
            cast += defParam.defaultValue();
            remainingDefaultValues << cast;
        }
        overload.setRemainingDefaultValues(remainingDefaultValues);
        klass->appendMethod(overload);

        params << param;
    }
}

// checks if method meth is overriden in class klass or any of its superclasses
const Method* Util::isVirtualOverriden(const Method& meth, const Class* klass)
{
    // is the method virtual at all?
    if (!(meth.flags() & Method::Virtual) && !(meth.flags() & Method::PureVirtual))
        return 0;

    // if the method is defined in klass, it can't be overriden there or in any parent class
    if (meth.getClass() == klass)
        return 0;

    foreach (const Method& m, klass->methods()) {
        if (!(m.flags() & Method::Static) && m == meth)
            // the method m overrides meth
            return &m;
    }

    foreach (const Class::BaseClassSpecifier& base, klass->baseClasses()) {
        // we reached the class in which meth was defined and we still didn't find any overrides => return
        if (base.baseClass == meth.getClass())
            return 0;

        // recurse into the base classes
        const Method* m = 0;
        if ((m = isVirtualOverriden(meth, base.baseClass)))
            return m;
    }

    return 0;
}

static bool qListContainsMethodPointer(const QList<const Method*> list, const Method* ptr) {
    foreach (const Method* meth, list) {
        if (*meth == *ptr)
            return true;
    }
    return false;
}

QList<const Method*> Util::virtualMethodsForClass(const Class* klass)
{
    static QHash<const Class*, QList<const Method*> > cache;

    // virtual method callbacks for classes that can't be instanstiated aren't useful
    if (!Util::canClassBeInstanciated(klass))
        return QList<const Method*>();

    if (cache.contains(klass))
        return cache[klass];

    QList<const Method*> ret;

    foreach (const Method* meth, Util::collectVirtualMethods(klass)) {
        // this is a synthesized overload, skip it.
        if (!meth->remainingDefaultValues().isEmpty())
            continue;
        if (meth->getClass() == klass) {
            // this method can't be overriden, because it's defined in the class for which this method was called
            ret << meth;
            continue;
        }
        // Check if the method is overriden, so the callback will always point to the latest definition of the virtual method.
        const Method* override = 0;
        if ((override = Util::isVirtualOverriden(*meth, klass))) {
            // If the method was overriden and put under private access, skip it. If we already have the method, skip it as well.
            if (override->access() == Access_private || qListContainsMethodPointer(ret, override))
                continue;
            ret << override;
        } else if (!qListContainsMethodPointer(ret, meth)) {
            ret << meth;
        }
    }

    cache[klass] = ret;
    return ret;
}

bool Options::typeExcluded(const QString& typeName)
{
    foreach (const QRegExp& exp, Options::excludeExpressions) {
        if (exp.exactMatch(typeName))
            return true;
    }
    return false;
}

bool Options::functionNameIncluded(const QString& fnName) {
    foreach (const QRegExp& exp, Options::includeFunctionNames) {
        if (exp.exactMatch(fnName))
            return true;
    }
    return false;
}

bool Options::functionSignatureIncluded(const QString& sig) {
    foreach (const QRegExp& exp, Options::includeFunctionNames) {
        if (exp.exactMatch(sig))
            return true;
    }
    return false;
}
