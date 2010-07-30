/* This file is part of KDevelop
    Copyright 2002-2005 Roberto Raggi <roberto@kdevelop.org>

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

#include "cppparser_export.h"
#include "default_visitor.h"
// #include <language/duchain/identifier.h>

#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QList>

class ParseSession;

class CPPPARSER_EXPORT TypeCompiler: protected DefaultVisitor
{
public:
  TypeCompiler(ParseSession* session);

//   KDevelop::QualifiedIdentifier identifier() const;
  inline const QStringList& qualifiedName() const { return m_type; }
  inline QString name() const { if (m_integral) return m_type.join(" "); else return m_type.join("::"); }
  inline QList<int> cv() const { return _M_cv; }

  bool isConstant() const;
  bool isVolatile() const;

  bool isIntegral() const { return m_integral; }

  QStringList cvString() const;

  void run(TypeSpecifierAST *node);

protected:
  virtual void visitClassSpecifier(ClassSpecifierAST *node);
  virtual void visitEnumSpecifier(EnumSpecifierAST *node);
  virtual void visitElaboratedTypeSpecifier(ElaboratedTypeSpecifierAST *node);
  virtual void visitSimpleTypeSpecifier(SimpleTypeSpecifierAST *node);

  virtual void visitName(NameAST *node);

private:
  ParseSession* m_session;
  QStringList m_type;
//   KDevelop::QualifiedIdentifier _M_type;
  QList<int> _M_cv;
  bool m_integral;
};

#endif // TYPE_COMPILER_H

