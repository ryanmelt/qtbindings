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

#ifndef CODEMODEL_FWD_H
#define CODEMODEL_FWD_H

#include <QtCore/QList>
#include <QtCore/QSharedPointer>

// forward declarations
class CodeModel;
class _ArgumentModelItem;
class _ClassModelItem;
class _CodeModelItem;
class _EnumModelItem;
class _EnumeratorModelItem;
class _FileModelItem;
class _FunctionDefinitionModelItem;
class _FunctionModelItem;
class _NamespaceModelItem;
class _ScopeModelItem;
class _TemplateModelItem;
class _TemplateParameterModelItem;
class _TypeAliasModelItem;
class _VariableModelItem;
class _MemberModelItem;

typedef QSharedPointer<_ArgumentModelItem> ArgumentModelItem;
typedef QSharedPointer<_ClassModelItem> ClassModelItem;
typedef QSharedPointer<_CodeModelItem> CodeModelItem;
typedef QSharedPointer<_EnumModelItem> EnumModelItem;
typedef QSharedPointer<_EnumeratorModelItem> EnumeratorModelItem;
typedef QSharedPointer<_FileModelItem> FileModelItem;
typedef QSharedPointer<_FunctionDefinitionModelItem> FunctionDefinitionModelItem;
typedef QSharedPointer<_FunctionModelItem> FunctionModelItem;
typedef QSharedPointer<_NamespaceModelItem> NamespaceModelItem;
typedef QSharedPointer<_ScopeModelItem> ScopeModelItem;
typedef QSharedPointer<_TemplateModelItem> TemplateModelItem;
typedef QSharedPointer<_TemplateParameterModelItem> TemplateParameterModelItem;
typedef QSharedPointer<_TypeAliasModelItem> TypeAliasModelItem;
typedef QSharedPointer<_VariableModelItem> VariableModelItem;
typedef QSharedPointer<_MemberModelItem> MemberModelItem;

typedef QList<ArgumentModelItem> ArgumentList;
typedef QList<ClassModelItem> ClassList;
typedef QList<CodeModelItem> CodeList;
typedef QList<CodeModelItem> ItemList;
typedef QList<EnumModelItem> EnumList;
typedef QList<EnumeratorModelItem> EnumeratorList;
typedef QList<FileModelItem> FileList;
typedef QList<FunctionDefinitionModelItem> FunctionDefinitionList;
typedef QList<FunctionModelItem> FunctionList;
typedef QList<NamespaceModelItem> NamespaceList;
typedef QList<ScopeModelItem> ScopeList;
typedef QList<TemplateModelItem> TemplateList;
typedef QList<TemplateParameterModelItem> TemplateParameterList;
typedef QList<TypeAliasModelItem> TypeAliasList;
typedef QList<VariableModelItem> VariableList;
typedef QList<MemberModelItem> MemberList;

#endif // CODEMODEL_FWD_H
