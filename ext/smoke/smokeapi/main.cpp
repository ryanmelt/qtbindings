/*
    Command line introspection tool for SMOKE libs
    Copyright (C) 2010 Arno Rehn <arno@arnorehn.de>
    Copyright (C) 2010 Richard Dale <richard.j.dale@gmail.com>

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

#include <QtCore>
#include <QtDebug>

#include <smoke.h>

static QTextStream qOut(stdout);

typedef void (*InitSmokeFn)();
typedef QPair<Smoke::ModuleIndex,int> ClassEntry;

static QList<Smoke*> smokeModules;

static bool showClassNamesOnly;
static bool showParents;
static bool matchPattern;
static bool caseInsensitive;
static QRegExp targetPattern;

static Smoke* 
loadSmokeModule(QString moduleName) {
    QFileInfo file(QString("libsmoke") + moduleName);
    QLibrary lib(file.filePath());

    QString init_name = "init_" + moduleName + "_Smoke";
    InitSmokeFn init = (InitSmokeFn) lib.resolve(init_name.toLatin1());

    if (!init)
        qFatal("Couldn't resolve %s: %s", qPrintable(init_name), qPrintable(lib.errorString()));
    
    (*init)();

    QString smoke_name = moduleName + "_Smoke";
    Smoke** smoke = (Smoke**) lib.resolve(smoke_name.toLatin1());
    if (!smoke)
        qFatal("Couldn't resolve %s: %s", qPrintable(smoke_name), qPrintable(lib.errorString()));

    return *smoke;
}

static QString
methodToString(Smoke::ModuleIndex methodId)
{
    QString result;
    Smoke * smoke = methodId.smoke;
    Smoke::Method& methodRef = smoke->methods[methodId.index];
    
    if ((methodRef.flags & Smoke::mf_signal) != 0) {
        result.append("signal ");
    }
    
    if ((methodRef.flags & Smoke::mf_slot) != 0) {
        result.append("slot ");
    }
    
    const char * typeName = smoke->types[methodRef.ret].name;
    
    if ((methodRef.flags & Smoke::mf_enum) != 0) {
        result.append(QString("enum %1::%2")
                            .arg(smoke->classes[methodRef.classId].className)
                            .arg(smoke->methodNames[methodRef.name]) );
        return result;
    }
    
    if ((methodRef.flags & Smoke::mf_virtual) != 0) {
        result.append("virtual ");
    }
    
    if (	(methodRef.flags & Smoke::mf_static) != 0
            && (smoke->classes[methodRef.classId].flags & Smoke::cf_namespace) == 0 )
    {
        result.append("static ");
    }
    
    if ((methodRef.flags & Smoke::mf_ctor) == 0) {
        result.append((typeName != 0 ? typeName : "void"));
        result.append(" ");
    }
    
    result.append(  QString("%1::%2(")
                        .arg(smoke->classes[methodRef.classId].className)
                        .arg(smoke->methodNames[methodRef.name]) );
                        
    for (int i = 0; i < methodRef.numArgs; i++) {
        if (i > 0) {
            result.append(", ");
        }
        
        typeName = smoke->types[smoke->argumentList[methodRef.args+i]].name;
        result.append((typeName != 0 ? typeName : "void"));
    }
    
    result.append(")");
    
    if ((methodRef.flags & Smoke::mf_const) != 0) {
        result.append(" const");
    }
    
    if ((methodRef.flags & Smoke::mf_purevirtual) != 0) {
        result.append(" = 0");
    }
    
    return result;
}

static QList<ClassEntry>
getAllParents(const Smoke::ModuleIndex& classId, int indent)
{
    Smoke* smoke = classId.smoke;
    QList<ClassEntry> result;
    
    for (   Smoke::Index * parent = smoke->inheritanceList + smoke->classes[classId.index].parents; 
            *parent != 0; 
            parent++ ) 
    {
        Smoke::ModuleIndex parentId = Smoke::findClass(smoke->classes[*parent].className);
        Q_ASSERT(parentId != Smoke::NullModuleIndex);
        result << getAllParents(parentId, indent + 1);
    }
    
    result << ClassEntry(classId, indent);
    return result;
}

static void
showClass(const Smoke::ModuleIndex& classId, int indent)
{
    if (showClassNamesOnly) {
        QString className = QString::fromLatin1(classId.smoke->classes[classId.index].className);    
        if (!matchPattern || targetPattern.indexIn(className) != -1) {
			while (indent > 0) {
				qOut << "  ";
				indent--;
			}
            qOut << className << "\n";
        }
        
        return;
    }
    
    Smoke * smoke = classId.smoke;
    Smoke::Index imax = smoke->numMethodMaps;
    Smoke::Index imin = 0, icur = -1, methmin, methmax;
    methmin = -1; methmax = -1; // kill warnings
    int icmp = -1;

    while (imax >= imin) {
        icur = (imin + imax) / 2;
        icmp = smoke->leg(smoke->methodMaps[icur].classId, classId.index);
        if (icmp == 0) {
            Smoke::Index pos = icur;
            while (icur != 0 && smoke->methodMaps[icur-1].classId == classId.index) {
                icur --;
            }
            
            methmin = icur;
            icur = pos;
            while (icur < imax && smoke->methodMaps[icur+1].classId == classId.index) {
                icur ++;
            }
            
            methmax = icur;
            break;
        }
        
        if (icmp > 0) {
            imax = icur - 1;
        } else {
            imin = icur + 1;
        }
    }

    if (icmp == 0) {
        for (Smoke::Index i = methmin ; i <= methmax ; i++) {
            Smoke::Index ix = smoke->methodMaps[i].method;
            if (ix >= 0) {  // single match
                QString method = methodToString(Smoke::ModuleIndex(smoke, ix));
                if (!matchPattern || targetPattern.indexIn(method) != -1) {
                    qOut << method << "\n";
                }
            } else {        // multiple match
                ix = -ix;       // turn into ambiguousMethodList index
                while (smoke->ambiguousMethodList[ix]) {
                    QString method = methodToString(Smoke::ModuleIndex(smoke, smoke->ambiguousMethodList[ix]));
                    if (!matchPattern || targetPattern.indexIn(method) != -1) {
                        qOut << method << "\n";
                    }
                    
                    ix++;
                }
            }
        }
    }
}

#define PRINT_USAGE() \
    qDebug() << "Usage:" << argv[0] << "-r <smoke lib> [-r more smoke libs..] [-c] [-p] [-m pattern] [-i] [<classname(s)>..]"

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);
    QStringList arguments = app.arguments();
    
    showClassNamesOnly = false;
    showParents = false;
    caseInsensitive = false;
    matchPattern = false;

    if (argc == 1) {
        PRINT_USAGE();
        return 0;
    }

    int i = 1;
    while (i < arguments.length()) {
        if (arguments[i] == QLatin1String("-h") || arguments[i] == QLatin1String("--help")) {
            PRINT_USAGE();
            return 0;
        } else if (arguments[i] == QLatin1String("-r") || arguments[i] == QLatin1String("--require")) {
            i++;
            if (i < arguments.length()) {
                smokeModules << loadSmokeModule(arguments[i]);
            }
            i++;
        } else if (arguments[i] == QLatin1String("-c") || arguments[i] == QLatin1String("--classes")) {
            showClassNamesOnly = true;
            i++;
        } else if (arguments[i] == QLatin1String("-p") || arguments[i] == QLatin1String("--parents")) {
            showParents = true;
            i++;
        } else if (arguments[i] == QLatin1String("-i") || arguments[i] == QLatin1String("--insensitive")) {
            caseInsensitive = true;
            i++;
        } else if (arguments[i] == QLatin1String("-m") || arguments[i] == QLatin1String("--match")) {
            i++;
            if (i < arguments.length()) {
                targetPattern = QRegExp(arguments[i]);
                matchPattern = true;
            }
            i++;
        } else {
            break;
        }        
    }

    if (caseInsensitive) {
        targetPattern.setCaseSensitivity(Qt::CaseInsensitive);
    }
    
    smokeModules << loadSmokeModule("qtcore");
    
    if (i >= arguments.length()) {
        if (targetPattern.isEmpty()) {
            PRINT_USAGE();
            return 0;
        } else {
            foreach (Smoke * smoke, smokeModules) {
                for (int i = 1; i <= smoke->numClasses; i++) {
                    if (!smoke->classes[i].external) {
                        showClass(Smoke::ModuleIndex(smoke, i), 0);
                    }
                }
            }
            
            return 0;
        }
    }
    
    while (i < arguments.length()) {
        QString className = arguments[i];

        Smoke::ModuleIndex classId = Smoke::findClass(className.toLatin1());
        if (classId == Smoke::NullModuleIndex) {
            qFatal("Error: class '%s' not found", className.toLatin1().constData());
        }
        
        if (showParents) {
            QList<ClassEntry> parents = getAllParents(classId, 0);
            foreach (ClassEntry parent, parents) {
                showClass(parent.first, parent.second);
            }
        } else {
            showClass(classId, 0);
        }
        
        i++;
    }
    
    return 0;
}
