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

#ifndef GLOBALS_H
#define GLOBALS_H

#include <QMap>
#include <QSet>
#include <QString>
#include <QStringList>

template<typename T>
class QStack;

class QDir;
class QFileInfo;
class QString;
class QStringList;
class QTextStream;

class Class;
class Function;
class Member;
class Method;
class Field;
class Type;

struct Options
{
    static QDir outputDir;
    static int parts;
    static QString module;
    static QStringList parentModules;
    static QStringList scalarTypes;
    static QStringList voidpTypes;
    static QList<QFileInfo> headerList;
    static QStringList classList;
    static bool qtMode;
    
    static QList<QRegExp> excludeExpressions;
    static QList<QRegExp> includeFunctionNames;
    static QList<QRegExp> includeFunctionSignatures;
    
    static bool typeExcluded(const QString& typeName);
    static bool functionNameIncluded(const QString& fnName);
    static bool functionSignatureIncluded(const QString& sig);
};

struct SmokeDataFile
{
    SmokeDataFile();

    void write();
    bool isClassUsed(const Class* klass);
    QString getTypeFlags(const Type *type, int *classIdx);

    QMap<QString, int> classIndex;
    QHash<const Member*, int> methodIdx;
    QHash<Type*, int> typeIndex;
    QSet<Class*> externalClasses;
    QSet<Type*> usedTypes;
    QStringList includedClasses;
    QHash<const Class*, QSet<const Method*> > declaredVirtualMethods;
};

struct SmokeClassFiles
{
    SmokeClassFiles(SmokeDataFile *data);
    void write();
    void write(const QList<QString>& keys);

private:
    QString generateMethodBody(const QString& indent, const QString& className, const QString& smokeClassName, const Method& meth, int index, bool dynamicDispatch, QSet< QString >& includes);
    void generateMethod(QTextStream& out, const QString& className, const QString& smokeClassName, const Method& meth, int index, QSet<QString>& includes);
    void generateGetAccessor(QTextStream& out, const QString& className, const Field& field, const Type* type, int index);
    void generateSetAccessor(QTextStream& out, const QString& className, const Field& field, const Type* type, int index);
    void generateEnumMemberCall(QTextStream& out, const QString& className, const QString& member, int index);
    void generateVirtualMethod(QTextStream& out, const Method& meth, QSet<QString>& includes);
    
    void writeClass(QTextStream& out, const Class* klass, const QString& className, QSet<QString>& includes);
    
    SmokeDataFile *m_smokeData;
};
    
struct Util
{
    static QHash<QString, QString> typeMap;
    static QHash<const Method*, const Function*> globalFunctionMap;
    static QHash<const Method*, const Field*> fieldAccessors;
    
    static bool isVirtualInheritancePath(const Class* desc, const Class* super);
    static QList<const Class*> superClassList(const Class* klass);
    static QList<const Class*> descendantsList(const Class* klass);

    static void preparse(QSet<Type*> *usedTypes, QSet<const Class*> *superClasses, const QList<QString>& keys);

    static bool canClassBeInstanciated(const Class* klass);
    static bool canClassBeCopied(const Class* klass);
    static bool hasClassVirtualDestructor(const Class* klass);
    static bool hasClassPublicDestructor(const Class* klass);
    static const Method* findDestructor(const Class* klass);

    static bool derivesFromInvalid(const Class* klass);

    static void checkForAbstractClass(Class* klass);
    static void addDefaultConstructor(Class* klass);
    static void addCopyConstructor(Class* klass);
    static void addDestructor(Class* klass);
    static void addOverloads(const Method& meth);
    static void addAccessorMethods(const Field& field, QSet<Type*> *usedTypes);

    static QChar munge(const Type *type);
    static QString mungedName(const Method&);

    static Type* normalizeType(const Type* type);

    static QString stackItemField(const Type* type);
    static QString assignmentString(const Type* type, const QString& var);
    static QList<const Method*> collectVirtualMethods(const Class* klass);
    static const Method* isVirtualOverriden(const Method& meth, const Class* klass);
    static QList<const Method*> virtualMethodsForClass(const Class* klass);
};

#endif
