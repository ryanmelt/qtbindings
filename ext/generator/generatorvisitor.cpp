/*
    Copyright (C) 2009  Arno Rehn <arno@arnorehn.de>

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

#include <ast.h>
#include <tokens.h>
#include "name_compiler.h"
#include "type_compiler.h"

#include "generatorvisitor.h"
#include "options.h"

#include <QtDebug>

GeneratorVisitor::GeneratorVisitor(ParseSession *session, const QString& header) 
    : m_session(session), m_header(header), createType(false), createTypedef(false),
      inClass(0), inTemplate(false), isStatic(false), isVirtual(false), isExplicit(false), hasInitializer(false), currentTypeRef(0), inMethod(false)
{
    nc = new NameCompiler(m_session, this);
    tc = new TypeCompiler(m_session, this);
    
    usingTypes.push(QStringList());
    usingNamespaces.push(QStringList());
}

GeneratorVisitor::~GeneratorVisitor()
{
    delete nc;
    delete tc;
}

QPair<bool, bool> GeneratorVisitor::parseCv(const ListNode<std::size_t> *cv)
{
    QPair<bool, bool> ret(false, false);
    if (!cv) return ret;
    const ListNode<std::size_t> *it = cv->toFront(), *end = it;
    do {
        if (it->element) {
            int _kind = m_session->token_stream->kind(it->element);
            if (_kind == Token_const)
                ret.first = true;
            else if (_kind == Token_volatile)
                ret.second = true;
        }
        it = it->next;
    } while (end != it);
    return ret;
}

#define returnOnExistence(name) \
        if (classes.contains(name)) { \
            return &classes[name]; \
        } else if (typedefs.contains(name)) { \
            return &typedefs[name]; \
        } else if (enums.contains(name)) { \
            return &enums[name]; \
        }

BasicTypeDeclaration* GeneratorVisitor::resolveTypeInSuperClasses(const Class* klass, const QString& name)
{
    foreach (const Class::BaseClassSpecifier& bclass, klass->baseClasses()) {
        QString _name = bclass.baseClass->toString() + "::" + name;
        returnOnExistence(_name);
        QStringList nspace = klass->nameSpace().split("::");
        if (!klass->nameSpace().isEmpty() && nspace != this->nspace) {
            do {
                nspace.push_back(name);
                QString n = nspace.join("::");
                returnOnExistence(n);
                nspace.pop_back();
                if (!nspace.isEmpty())
                    nspace.pop_back();
            } while (!nspace.isEmpty());
        }
        if (!bclass.baseClass->baseClasses().count())
            continue;
        BasicTypeDeclaration* decl = resolveTypeInSuperClasses(bclass.baseClass, name);
        if (decl)
            return decl;
    }
    return 0;
}

BasicTypeDeclaration* GeneratorVisitor::resolveType(const QString & name)
{
    QString _name = name;
    return resolveType(_name);
}

// TODO: this might have to be improved for cases like 'Typedef::Nested foo'
BasicTypeDeclaration* GeneratorVisitor::resolveType(QString & name)
{
    if (ParserOptions::qtMode && name.endsWith("::enum_type")) {
        // strip off "::enum_type"
        QString flags = name.left(name.length() - 11);
        QHash<QString, Typedef>::iterator it = typedefs.find(flags);
        if (it != typedefs.end()) {
            QString enumType = it.value().resolve().toString().replace(QRegExp("QFlags<(.*)>"), "\\1");
            QHash<QString, Enum>::iterator it = enums.find(enumType);
            if (it != enums.end()) {
                return &it.value();
            }
        }
    }

    // check for 'using type;'
    // if we use 'type', we can also access type::nested, take care of that
    int index = name.indexOf("::");
    QString first = name, rest;
    if (index > -1) {
        first = name.mid(0, index);
        rest = name.mid(index);
    }
    foreach (const QStringList& list, usingTypes) {
        foreach (const QString& string, list) {
            QString complete = string + rest;
            if (string.endsWith(first)) {
                returnOnExistence(complete);
            }
        }
    }

    // check for the name in parent namespaces
    QStringList nspace = this->nspace;
    do {
        nspace.push_back(name);
        QString n = nspace.join("::");
        returnOnExistence(n);
        nspace.pop_back();
        if (!nspace.isEmpty())
            nspace.pop_back();
    } while (!nspace.isEmpty());

    // check for nested classes
    for (int i = klass.count() - 1; i >= 0; i--) {
        QString _name = klass[i]->toString() + "::" + name;
        returnOnExistence(_name);
        BasicTypeDeclaration* decl = resolveTypeInSuperClasses(klass[i], name);
        if (decl)
            return decl;
    }

    // maybe it's just 'there'
    returnOnExistence(name);

    // check for the name in any of the namespaces included by 'using namespace'
    foreach (const QStringList& list, usingNamespaces) {
        foreach (const QString& string, list) {
            QString cname = string + "::" + name;
            returnOnExistence(cname);
        }
    }

    QStringList parts = name.split("::");
    if (parts.count() > 1) {
        // try to resolve the first part - if that works simply append the last part.
        BasicTypeDeclaration* decl = resolveType(parts.takeFirst());
        if (!decl)
            return 0;
        parts.prepend(decl->toString());
        name = parts.join("::");
        returnOnExistence(name);
    } else {
        // maybe it's an enum value (as used for template args in phonon)
        
        // look through all the enums of the parent classes
        if (!klass.isEmpty()) {
            const Class* clazz = klass.top();
            while (clazz) {
                foreach (BasicTypeDeclaration* decl, klass.top()->children()) {
                    Enum* e = 0;
                    if (!(e = dynamic_cast<Enum*>(decl)))
                        continue;
                    foreach (const EnumMember& member, e->members()) {
                        if (member.name() == name) {
                            name.prepend(klass.top()->toString() + "::");
                            return 0;
                        }
                    }
                }
                clazz = clazz->parent();
            }
        }
        
        // look through all global enums in our namespace
        QStringList nspace = this->nspace;
        do {
            QString n = nspace.join("::");
            foreach (const Enum& e, enums.values()) {
                if (e.parent())
                    continue;
                
                if (e.nameSpace() == n) {
                    foreach (const EnumMember& member, e.members()) {
                        if (member.name() == name) {
                            name.prepend(n + "::");
                            return 0;
                        }
                    }
                }
            }
            if (!nspace.isEmpty())
                nspace.pop_back();
        } while (!nspace.isEmpty());
    }

    return 0;
}

QString GeneratorVisitor::resolveEnumMember(const QString& name)
{
    QString parent, member;
    int idx = -1;
    if ((idx = name.lastIndexOf("::")) != -1) {
        parent = name.mid(0, idx);
        member = name.mid(idx + 2);
    } else {
        member = name;
    }
    return resolveEnumMember(parent, member);
}

// TODO: This doesn't look for the enum in superclasses and parent classes yet - but it suffices for the moment.
QString GeneratorVisitor::resolveEnumMember(const QString& parent, const QString& name)
{
    // is 'parent' a know class?
    if (!parent.isEmpty()) {
        BasicTypeDeclaration* decl = resolveType(parent);
        if (decl)
            return decl->toString() + "::" + name;
    }
    
    // doesn't seem to be a class, so it's probably a part of a namespace name
    QStringList nspace = this->nspace;
    do {
        QString n = nspace.join("::");
        if (!n.isEmpty() && !parent.isEmpty()) n += "::";
        n += parent;
        
        foreach (const Enum& e, enums.values()) {
            if (e.parent())
                continue;
            
            if (e.nameSpace() == n) {
                foreach (const EnumMember& member, e.members()) {
                    if (member.name() == name) {
                        QString ret = n;
                        if (!ret.isEmpty())
                            ret += "::";
                        return ret + name;
                    }
                }
            }
        }
        
        if (!nspace.isEmpty())
            nspace.pop_back();
    } while (!nspace.isEmpty());

    QStack<Class*> parentStack = klass;
    while (!parentStack.isEmpty()) {
        const Class* clazz = parentStack.pop();
        foreach (const BasicTypeDeclaration* decl, clazz->children()) {
            const Enum *e = 0;
            if (!(e = dynamic_cast<const Enum*>(decl)))
                continue;
            foreach (const EnumMember& member, e->members()) {
                if (member.name() == name) {
                    return clazz->toString() + "::" + name;
                }
            }
        }
    }

    return QString();
}

#undef returnOnExistence

void GeneratorVisitor::visitAccessSpecifier(AccessSpecifierAST* node)
{
    static bool oldResolveTypedefs = ParserOptions::resolveTypedefs;

    if (!inClass) {
        DefaultVisitor::visitAccessSpecifier(node);
        return;
    }

    inSignals.top() = false;
    inSlots.top() = false;
    ParserOptions::resolveTypedefs = oldResolveTypedefs;

    const ListNode<std::size_t> *it = node->specs->toFront(), *end = it;
    do {
        if (it->element) {
            const Token& t = token(it->element);
            if (t.kind == Token_public)
                access.top() = Access_public;
            else if (t.kind == Token_protected)
                access.top() = Access_protected;
            else if (t.kind == Token_private)
                access.top() = Access_private;

            // signal/slot handling; don't resolve typedefs in signals and slots
            if (t.kind == Token_signals) {
                access.top() = Access_protected;
                inSignals.top() = true;
                ParserOptions::resolveTypedefs = false;
            } else if (t.kind == Token_slots) {
                inSlots.top() = true;
                ParserOptions::resolveTypedefs = false;
            }
        }
        it = it->next;
    } while (end != it);
    DefaultVisitor::visitAccessSpecifier(node);
}

void GeneratorVisitor::visitBaseSpecifier(BaseSpecifierAST* node)
{
    Class::BaseClassSpecifier baseClass;
    int _kind = token(node->access_specifier).kind;
    if (_kind == Token_public) {
        baseClass.access = Access_public;
    } else if (_kind == Token_protected) {
        baseClass.access = Access_protected;
    } else {
        baseClass.access = Access_private;
    }
    baseClass.isVirtual = (node->virt > 0);
    nc->run(node->name);
    BasicTypeDeclaration* base = resolveType(nc->qualifiedName().join("::"));
    if (!base)
        return;
    Class* bptr = dynamic_cast<Class*>(base);
    if (!bptr) {
        Typedef* tdef = dynamic_cast<Typedef*>(base);
        if (!tdef)
            return;
        bptr = tdef->resolve().getClass();
        if (!bptr)
            return;
    }
    baseClass.baseClass = bptr;
    klass.top()->appendBaseClass(baseClass);
}

void GeneratorVisitor::visitClassSpecifier(ClassSpecifierAST* node)
{
    if (klass.isEmpty())
        return;
    
    if (kind == Class::Kind_Class)
        access.push(Access_private);
    else
        access.push(Access_public);
    inSignals.push(false);
    inSlots.push(false);
    inClass++;
    q_properties.push(QList<QProperty>());
    
    klass.top()->setFileName(m_header);
    klass.top()->setIsForwardDecl(false);
    if (klass.count() > 1) {
        // get the element before the last element, which is the parent
        Class* parent = klass[klass.count() - 2];
        parent->appendChild(klass.top());
    }
    DefaultVisitor::visitClassSpecifier(node);
    q_properties.pop();
    access.pop();
    inSignals.pop();
    inSlots.pop();
    inClass--;
}

// defined later on
static bool operator==(const Method& rhs, const Method& lhs);

void GeneratorVisitor::visitDeclarator(DeclaratorAST* node)
{
    // TODO: get rid of this and add a proper typdef
    bool typeCreated = false;
    if (createType) {
        // run it again on the list of pointer operators to add them to the type
        tc->run(node);
        currentType = tc->type();
        currentTypeRef = Type::registerType(currentType);
        createType = false;
        typeCreated = true;
    }
    
    if (currentType.isFunctionPointer() && node->sub_declarator)
        nc->run(node->sub_declarator->id);
    else
        nc->run(node->id);
    const QString declName = nc->name();

    if (createTypedef) {
        if (!typeCreated)
            return;
        // we've just created the type that the typedef points to
        // so we just need to get the new name and store it
        Class* parent = klass.isEmpty() ? 0 : klass.top();
        Typedef tdef = Typedef(currentTypeRef, declName, nspace.join("::"), parent);
        tdef.setFileName(m_header);
        QString name = tdef.toString();
        if (!typedefs.contains(name)) {
            QHash<QString, Typedef>::iterator it = typedefs.insert(name, tdef);
            if (parent)
                parent->appendChild(&it.value());
        }
        createTypedef = false;
        return;
    }

    // we don't care about methods with ellipsis paramaters (i.e. 'foo(const char*, ...)') for now..
    if (node->parameter_declaration_clause && node->parameter_declaration_clause->ellipsis)
        return;

    // only run this if we're not in a method. only checking for parameter_declaration_clause
    // won't be enough because function pointer types also have that.
    if (node->parameter_declaration_clause && !inMethod && inClass) {
        // detect Q_PROPERTIES
        if (ParserOptions::qtMode && declName == "__q_property") {
            // this should _always_ work
            PrimaryExpressionAST* primary = ast_cast<PrimaryExpressionAST*>(node->parameter_declaration_clause->parameter_declarations->at(0)->element->expression);
            QByteArray literals;
            const ListNode<std::size_t> *it = primary->literal->literals->toFront(), *end = it;
            do {
                if (it->element) {
                    literals.append(token(it->element).symbolByteArray());
                }
                it = it->next;
            } while (end != it);
            literals.replace("\"", "");
            // this monster only matches "type name READ getMethod WRITE setMethod"
            static QRegExp regexp("^([\\w:<>\\*]+)\\s+(\\w+)\\s+READ\\s+(\\w+)(\\s+WRITE\\s+\\w+)?");
            static QRegExp typePtr(".*\\*$");
            if (regexp.indexIn(literals) != -1) {
                QProperty prop = { QMetaObject::normalizedType(regexp.cap(1).toLatin1()), (typePtr.indexIn(regexp.cap(1)) !=  -1), regexp.cap(2),
                                   regexp.cap(3), regexp.cap(4).replace(QRegExp("\\s+WRITE\\s+"), QString()) };
                q_properties.top().append(prop);
            }
            return;
        }

        bool isConstructor = (declName == klass.top()->name());
        bool isDestructor = (declName == "~" + klass.top()->name());
        Type* returnType = currentTypeRef;
        if (isConstructor) {
            // constructors return a pointer to the class they create
            Type t(klass.top()); t.setPointerDepth(1);
            returnType = Type::registerType(t);
        } else if (isDestructor) {
            // destructors don't have a return type.. so return void
            returnType = const_cast<Type*>(Type::Void);
        } else if (nc->isCastOperator()) {
            returnType = Type::registerType(nc->castType());
        }
        currentMethod = Method(klass.top(), declName, returnType, access.top());
        currentMethod.setIsConstructor(isConstructor);
        currentMethod.setIsDestructor(isDestructor);
        currentMethod.setIsSignal(inSignals.top());
        currentMethod.setIsSlot(inSlots.top());
        // build parameter list
        inMethod = true;
        visit(node->parameter_declaration_clause);
        inMethod = false;
        QPair<bool, bool> cv = parseCv(node->fun_cv);
        // const & volatile modifiers
        currentMethod.setIsConst(cv.first);
        
        if (isVirtual) currentMethod.setFlag(Method::Virtual);
        if (hasInitializer) currentMethod.setFlag(Method::PureVirtual);
        if (isStatic) currentMethod.setFlag(Method::Static);
        if (isExplicit) currentMethod.setFlag(Method::Explicit);

        // the class already contains the method (probably imported by a 'using' statement)
        if (klass.top()->methods().contains(currentMethod)) {
            return;
        }

        // Q_PROPERTY accessor?
        if (ParserOptions::qtMode) {
            foreach (const QProperty& prop, q_properties.top()) {
                if (   (currentMethod.parameters().count() == 0 && prop.read == currentMethod.name() && currentMethod.type()->toString().endsWith(prop.type)
                       && (currentMethod.type()->pointerDepth() == 1) == prop.isPtr)    // READ accessor?
                    || (currentMethod.parameters().count() == 1 && prop.write == currentMethod.name()
                       && currentMethod.parameters()[0].type()->toString().remove(QRegExp("^const ")).remove(QRegExp("\\&$")).endsWith(prop.type)
                       && (currentMethod.parameters()[0].type()->pointerDepth() == 1) == prop.isPtr))   // or WRITE accessor?
                {
                    currentMethod.setIsQPropertyAccessor(true);
                }
            }
        }

        if (node->exception_spec) {
            currentMethod.setHasExceptionSpec(true);
            if (node->exception_spec->type_ids) {
                const ListNode<TypeIdAST*>* it = node->exception_spec->type_ids->toFront(), *end = it;
                do {
                    tc->run(it->element->type_specifier, it->element->declarator);
                    currentMethod.appendExceptionType(tc->type());
                    it = it->next;
                } while (it != end);
            }
        }

        klass.top()->appendMethod(currentMethod);
        return;
    }
    
    // global function
    if (node->parameter_declaration_clause && !inMethod && !inClass) {
        if (!declName.contains("::")) {
            Type* returnType = currentTypeRef;
            currentFunction = Function(declName, nspace.join("::"), returnType);
            currentFunction.setFileName(m_header);
            // build parameter list
            inMethod = true;
            visit(node->parameter_declaration_clause);
            inMethod = false;
            QString name = currentFunction.toString();
            if (!functions.contains(name)) {
                functions[name] = currentFunction;
            }
        }
        return;
    }
    
    // field
    if (!inMethod && !klass.isEmpty() && inClass) {
        Field field = Field(klass.top(), declName, currentTypeRef, access.top());
        if (isStatic) field.setFlag(Field::Static);
        klass.top()->appendField(field);
        return;
    } else if (!inMethod && !inClass) {
        // global variable
        if (!globals.contains(declName)) {
            GlobalVar var = GlobalVar(declName, nspace.join("::"), currentTypeRef);
            var.setFileName(m_header);
            globals[var.name()] = var;
        }
        return;
    }
}

void GeneratorVisitor::visitElaboratedTypeSpecifier(ElaboratedTypeSpecifierAST* node)
{
    tc->run(node);
    createType = true;
    DefaultVisitor::visitElaboratedTypeSpecifier(node);
}

void GeneratorVisitor::visitEnumSpecifier(EnumSpecifierAST* node)
{
    nc->run(node->name);
    Class* parent = klass.isEmpty() ? 0 : klass.top();
    currentEnum = Enum(nc->name(), nspace.join("::"), parent);
    Access a = (access.isEmpty() ? Access_public : access.top());
    currentEnum.setAccess(a);
    currentEnum.setFileName(m_header);
    QHash<QString, Enum>::iterator it = enums.insert(currentEnum.toString(), currentEnum);
    currentEnumRef = &it.value();
    visitNodes(this, node->enumerators);
    if (parent)
        parent->appendChild(currentEnumRef);
}

void GeneratorVisitor::visitEnumerator(EnumeratorAST* node)
{
    currentEnumRef->appendMember(EnumMember(currentEnumRef, token(node->id).symbolString(), QString()));
//     DefaultVisitor::visitEnumerator(node);
}

void GeneratorVisitor::visitFunctionDefinition(FunctionDefinitionAST* node)
{
    visit(node->type_specifier);
    if (node->function_specifiers) {
        const ListNode<std::size_t> *it = node->function_specifiers->toFront(), *end = it;
        do {
            if (it->element && m_session->token_stream->kind(it->element) == Token_virtual) {
                // found virtual token
                isVirtual = true;
            } else if (it->element && m_session->token_stream->kind(it->element) == Token_explicit) {
                isExplicit = true;
            }
            it = it->next;
        } while (end != it);
    }
    if (node->storage_specifiers) {
        const ListNode<std::size_t> *it = node->storage_specifiers->toFront(), *end = it;
        do {
            if (it->element && m_session->token_stream->kind(it->element) == Token_static) {
                isStatic = true;
            } else if (it->element && m_session->token_stream->kind(it->element) == Token_friend) {
                // we're not interested in who's the friend of whom ;)
                return;
            }
            it = it->next;
        } while (end != it);
    }
    visit(node->init_declarator);
    isStatic = isVirtual = isExplicit = hasInitializer = false;
}

void GeneratorVisitor::visitInitializerClause(InitializerClauseAST *)
{
    // we don't care about initializers
    return;
}

void GeneratorVisitor::visitNamespace(NamespaceAST* node)
{
    usingTypes.push(QStringList());
    usingNamespaces.push(QStringList());

    QString name = token(node->namespace_name).symbolString();
    nspace.push_back(name);
    DefaultVisitor::visitNamespace(node);
    nspace.pop_back();
    // using directives in that namespace aren't interesting anymore :)
    usingTypes.pop();
    usingNamespaces.pop();
}

void GeneratorVisitor::visitParameterDeclaration(ParameterDeclarationAST* node)
{
    tc->run(node->type_specifier);
    QString name;
    if (node->declarator) {
        tc->run(node->declarator);
        if (currentType.isFunctionPointer() && node->declarator->sub_declarator)
            nc->run(node->declarator->sub_declarator->id);
        else
            nc->run(node->declarator->id);
        name = nc->name();
    }
    currentType = tc->type();
    currentTypeRef = Type::registerType(currentType);
    
    // foo(void) is the same as foo()
    if (currentTypeRef == Type::Void)
        return;
    
    QString defaultValue;
    if (node->expression) {
        // this parameter has a default value
        ExpressionAST* expression = node->expression;
        
        PostfixExpressionAST* postfix = 0;
        PrimaryExpressionAST* primary = 0;
        if ((postfix = ast_cast<PostfixExpressionAST*>(node->expression))
             && (postfix->sub_expressions->count() == 1
             && postfix->sub_expressions->at(0)->element->kind == AST::Kind_FunctionCall))
        {
            // We have a function call expression as default value, most probably something like 'const QString& foo = QString()'.
            // Try to resolve the classname if it's a constructor call.
            PrimaryExpressionAST* primary = ast_cast<PrimaryExpressionAST*>(postfix->expression);
            expression = postfix->sub_expressions->at(0)->element;
            
            nc->run(primary->name);
            QStringList className = nc->qualifiedName();
            BasicTypeDeclaration* decl = resolveType(className.join("::"));
            if (decl)
                className = decl->toString().split("::");

            if (!decl && className.count() > 1) {
                // Resolving failed, so this might also be a some static method (like Cursor::start() in KTextEditor).
                // Pop the last element (probably the method name) and resolve the rest.
                QString last = className.takeLast();
                BasicTypeDeclaration* decl = resolveType(className.join("::"));
                if (decl)
                    className = decl->toString().split("::");
                className.append(last);
            }

            QMap<int, QList<Type> > map = nc->templateArguments();
            for (QMap<int, QList<Type> >::const_iterator it = map.begin(); it != map.end(); it++) {
                QString str("< ");
                for (int i = 0; i < it.value().count(); i++) {
                    if (i > 0) str.append(',');
                    str.append(it.value()[i].toString());
                }
                str.append(" >");
                className[it.key()].append(str);
            }
            defaultValue.append(className.join("::"));
        } else if ((primary = ast_cast<PrimaryExpressionAST*>(node->expression))) {
            if (primary->name) {
                // don't build the default value twice
                expression = 0;
                // enum - try to resolve that
                nc->run(primary->name);
                
                QString name;
                // build the name of the containing class/namespace
                for (int i = 0; i < nc->qualifiedName().count() - 1; i++) {
                    if (i > 0) name.append("::");
                    name.append(nc->qualifiedName()[i]);
                }
                
                defaultValue = resolveEnumMember(name, nc->qualifiedName().last());
                if (defaultValue.isEmpty()) {
                    defaultValue = nc->qualifiedName().join("::");
                }
            }
        }
        
        if (expression) {
            for (int i = expression->start_token; i < expression->end_token; i++)
                defaultValue.append(token(i).symbolByteArray());
        }
    }
    if (inClass)
        currentMethod.appendParameter(Parameter(name, currentTypeRef, defaultValue));
    else
        currentFunction.appendParameter(Parameter(name, currentTypeRef, defaultValue));
}

void GeneratorVisitor::visitSimpleDeclaration(SimpleDeclarationAST* node)
{
    bool popKlass = false;
    int _kind = token(node->start_token).kind;
    if (_kind == Token_class) {
        kind = Class::Kind_Class;
    } else if (_kind == Token_struct) {
        kind = Class::Kind_Struct;
    }
    if (_kind == Token_class || _kind == Token_struct) {
        tc->run(node->type_specifier);
        if (tc->qualifiedName().isEmpty()) return;
        // for nested classes
        Class* parent = klass.isEmpty() ? 0 : klass.top();
        Class _class = Class(tc->qualifiedName().last(), nspace.join("::"), parent, kind);
        Access a = (access.isEmpty() ? Access_public : access.top());
        _class.setAccess(a);
        QString name = _class.toString();
        // This class has already been parsed.
        if (classes.contains(name) && !classes[name].isForwardDecl())
            return;
        QHash<QString, Class>::iterator item = classes.insert(name, _class);
        if (inTemplate) {
            item.value().setIsTemplate(true);
            return;
        }
        klass.push(&item.value());
        popKlass = true;
    }
    
    if (node->function_specifiers) {
        const ListNode<std::size_t> *it = node->function_specifiers->toFront(), *end = it;
        do {
            if (it->element && m_session->token_stream->kind(it->element) == Token_virtual) {
                // found virtual token
                isVirtual = true;
                break;
            }
            it = it->next;
        } while (end != it);
    }
    // look for initializers - if we find one, the method is pure virtual
    if (node->init_declarators) {
        const ListNode<InitDeclaratorAST*> *it = node->init_declarators->toFront(), *end = it;
        do {
            if (it->element && it->element->initializer) {
                hasInitializer = true;
            }
            if (it->element && it->element->declarator && it->element->declarator->parameter_declaration_clause) {
                if (popKlass) {
                    // This method return type has 'class' or 'struct' prepended to avoid a forward declaration.
                    // example: 'class KMultiTabBarTab *tab(...)'
                    QString oldClass = klass.top()->toString();
                    klass.top()->setParent(0);
                    klass.top()->setNameSpace(QString());
                    classes.insert(klass.top()->toString(), *klass.top());
                    classes.remove(oldClass);
                    klass.pop();
                    popKlass = false;
                }
            }
            it = it->next;
        } while (end != it);
    }
    if (node->storage_specifiers) {
        const ListNode<std::size_t> *it = node->storage_specifiers->toFront(), *end = it;
        do {
            if (it->element && m_session->token_stream->kind(it->element) == Token_static) {
                isStatic = true;
            } else if (it->element && m_session->token_stream->kind(it->element) == Token_friend) {
                // we're not interested in who's the friend of whom ;)
                if (popKlass)
                    klass.pop();
                isStatic = isVirtual = hasInitializer = false;
                return;
            }
            it = it->next;
        } while (end != it);
    }
    DefaultVisitor::visitSimpleDeclaration(node);
    if (popKlass)
        klass.pop();
    isStatic = isVirtual = hasInitializer = false;
}

void GeneratorVisitor::visitSimpleTypeSpecifier(SimpleTypeSpecifierAST* node)
{
    // first run on the type specifier to get the name of the type
    tc->run(node);
    createType = true;
    DefaultVisitor::visitSimpleTypeSpecifier(node);
}

void GeneratorVisitor::visitTemplateDeclaration(TemplateDeclarationAST* node)
{
    if (!node->declaration)
        return;
    int kind = token(node->declaration->start_token).kind;
    if (kind == Token_class || kind == Token_struct) {
        inTemplate = true;
        visit(node->declaration);
        inTemplate = false;
    }
    // skip template declarations
    return;
}

void GeneratorVisitor::visitTemplateArgument(TemplateArgumentAST* node)
{
    // skip template arguments - they're handled by TypeCompiler
    return;
}

void GeneratorVisitor::visitTypedef(TypedefAST* node)
{
    createTypedef = true;
    DefaultVisitor::visitTypedef(node);

    // TODO: probably has to be extended to cover structs and classes, too
    // makes something like 'typedef enum { Bar } Foo;' look like a proper enum.
    if (ast_cast<EnumSpecifierAST*>(node->type_specifier)) {
        nc->run(node->init_declarators->at(0)->element->declarator->id);
        currentEnumRef->setName(nc->name());
    }
}

// don't make this public - it's just a utility function for the next method and probably not what you would expect it to be
static bool operator==(const Method& rhs, const Method& lhs)
{
    // these have to be equal for methods to be the same
    bool ok = (rhs.name() == lhs.name() && rhs.isConst() == lhs.isConst() &&
               rhs.parameters().count() == lhs.parameters().count() && rhs.type() == lhs.type());
    if (!ok)
        return false;
    
    // now check the parameter types for equality
    for (int i = 0; i < rhs.parameters().count(); i++) {
        if (rhs.parameters()[i].type() != lhs.parameters()[i].type())
            return false;
    }
    
    return true;
}

void GeneratorVisitor::visitUsing(UsingAST* node)
{
    nc->run(node->name);
    if (inClass) {
        // if we encounter 'using' in a class, it means we should import methods from another class
        QStringList tmp = nc->qualifiedName();
        const QString methodName = tmp.takeLast();
        const QString className = tmp.join("::");
        const BasicTypeDeclaration* decl = resolveType(className);
        const Class* clazz = dynamic_cast<const Class*>(decl);
        if (!clazz) {
            const Typedef* tdef = dynamic_cast<const Typedef*>(decl);
            if (tdef) {
                clazz = tdef->resolve().getClass();
            }
        }
        if (!clazz)
            return;
        
        foreach (const Method& meth, clazz->methods()) {
            if (meth.name() != methodName)
                continue;
            
            // prevent importing of already overridden (pure) virtuals
            if (klass.top()->methods().contains(meth))
                continue;
            
            Method copy = meth;
            copy.setDeclaringType(klass.top());
            copy.setAccess(access.top());
            klass.top()->appendMethod(copy);
        }
    } else {
        usingTypes.top() << nc->qualifiedName().join("::");
    }
}

void GeneratorVisitor::visitUsingDirective(UsingDirectiveAST* node)
{
    nc->run(node->name);
    usingNamespaces.top() << nc->qualifiedName().join("::");
    DefaultVisitor::visitUsingDirective(node);
}
