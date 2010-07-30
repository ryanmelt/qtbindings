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

#ifndef PARSERVISITOR_H
#define PARSERVISITOR_H

#include <QStringList>
#include <QStack>

#include <default_visitor.h>
#include <parsesession.h>
#include <lexer.h>

#include "type.h"

class NameCompiler;
class TypeCompiler;

struct QProperty
{
    QString type;
    bool isPtr;
    QString name;
    QString read;
    QString write;
};

class GeneratorVisitor : public DefaultVisitor
{
public:
    GeneratorVisitor(ParseSession *session, const QString& header = QString());
    virtual ~GeneratorVisitor();
    BasicTypeDeclaration* resolveTypeInSuperClasses(const Class* klass, const QString& name);
    BasicTypeDeclaration* resolveType(const QString& name);
    BasicTypeDeclaration* resolveType(QString& name);
    QString resolveEnumMember(const QString& name);
    QString resolveEnumMember(const QString& parent, const QString& name);
    QPair<bool, bool> parseCv(const ListNode<std::size_t> *cv);

protected:
    inline const Token& token(std::size_t token) { return m_session->token_stream->token(token); }

    virtual void visitAccessSpecifier(AccessSpecifierAST* node);
    virtual void visitBaseSpecifier(BaseSpecifierAST* node);
    virtual void visitClassSpecifier(ClassSpecifierAST* node);
    virtual void visitDeclarator(DeclaratorAST* node);
    virtual void visitElaboratedTypeSpecifier(ElaboratedTypeSpecifierAST* node);
    virtual void visitEnumSpecifier(EnumSpecifierAST *);
    virtual void visitEnumerator(EnumeratorAST *);
    virtual void visitFunctionDefinition(FunctionDefinitionAST* );
    virtual void visitInitializerClause(InitializerClauseAST *);
    virtual void visitNamespace(NamespaceAST* node);
    virtual void visitParameterDeclaration(ParameterDeclarationAST* node);
    virtual void visitSimpleDeclaration(SimpleDeclarationAST* node);
    virtual void visitSimpleTypeSpecifier(SimpleTypeSpecifierAST* node);
    virtual void visitTemplateDeclaration(TemplateDeclarationAST* node);
    virtual void visitTemplateArgument(TemplateArgumentAST* node);
    virtual void visitTypedef(TypedefAST* node);
    virtual void visitUsing(UsingAST* node);
    virtual void visitUsingDirective(UsingDirectiveAST* node);

private:
    NameCompiler *nc;
    TypeCompiler *tc;
    
    ParseSession *m_session;
    QString m_header;
    
    bool createType;
    bool createTypedef;
    short inClass;
    
    bool inTemplate;
    bool isStatic;
    bool isVirtual;
    bool isExplicit;
    bool hasInitializer;
    
    Type currentType;
    Type* currentTypeRef;
    
    bool inMethod;
    Method currentMethod;
    
    Function currentFunction;
    
    Enum currentEnum;
    Enum* currentEnumRef;
    
    Class::Kind kind;
    QStack<Class*> klass;
    QStack<Access> access;
    QStack<bool> inSignals;
    QStack<bool> inSlots;
    
    QStack<QStringList> usingTypes;
    QStack<QStringList> usingNamespaces;
    
    QStringList nspace;
    
    QStack<QList<QProperty> > q_properties;
};

#endif // PARSERVISITOR_H
