/* This file is part of KDevelop
    Copyright 2002-2005 Roberto Raggi <roberto@kdevelop.org>
    Copyright 2009 Arno Rehn <arno@arnorehn.de>

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License version 2 as published by the Free Software Foundation.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public License
   along with this library; see the file COPYING.LIB.  If not, write to
   the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.
*/

#ifndef TYPE_COMPILER_H
#define TYPE_COMPILER_H

#include "generator_export.h"
#include "default_visitor.h"
#include "type.h"

#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QList>
#include <QtCore/QVector>

class ParseSession;
class GeneratorVisitor;

class GENERATOR_EXPORT TypeCompiler: protected DefaultVisitor
{
public:
  TypeCompiler(ParseSession* session, GeneratorVisitor* visitor);

//   KDevelop::QualifiedIdentifier identifier() const;
  inline const QStringList& qualifiedName() const { return m_type; }
  inline QList<int> cv() const { return _M_cv; }

  bool isConstant() const;
  bool isVolatile() const;

  QStringList cvString() const;

  const Type& type() const { return m_realType; }

  void run(TypeSpecifierAST *node, const DeclaratorAST* declarator = 0);
  void run(const DeclaratorAST *declarator);
  void run(const ListNode<PtrOperatorAST*> *ptr_ops);

protected:
  void setRealType();
  
  virtual void visitClassSpecifier(ClassSpecifierAST *node);
  virtual void visitEnumSpecifier(EnumSpecifierAST *node);
  virtual void visitElaboratedTypeSpecifier(ElaboratedTypeSpecifierAST *node);
  virtual void visitParameterDeclaration(ParameterDeclarationAST* node);
  virtual void visitPtrOperator(PtrOperatorAST* node);
  virtual void visitSimpleTypeSpecifier(SimpleTypeSpecifierAST *node);

  virtual void visitName(NameAST *node);

private:
  ParseSession* m_session;
  GeneratorVisitor* m_visitor;
  QStringList m_type;
//   KDevelop::QualifiedIdentifier _M_type;
  QList<int> _M_cv;
  Type m_realType;
  bool isRef;
  QVector<bool> pointerDepth;
  QMap<int, QList<Type> > m_templateArgs;
};

#endif // TYPE_COMPILER_H

