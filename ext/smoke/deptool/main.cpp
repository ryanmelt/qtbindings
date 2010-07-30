/*
    Dependency tool for SMOKE libs
    Copyright (C) 2010 Arno Rehn <arno@arnorehn.de>

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

typedef void (*InitSmokeFn)();

Smoke* loadSmokeModule(QFileInfo file) {
    QLibrary lib(file.filePath());

    QString moduleName = file.baseName().replace(QRegExp("^libsmoke"), QString());

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

bool smokeModuleLessThan(Smoke* a, Smoke* b) {
    return qstrcmp(a->moduleName(), b->moduleName()) < 0;
}

#define PRINT_USAGE() \
    qDebug() << "Usage:" << argv[0] << "[--xml] <smoke lib> [more smoke libs..]"

int main(int argc, char** argv)
{
    bool generateXml = false;
    QHash<Smoke*, QSet<Smoke*> > parents;

    if (argc == 1) {
        PRINT_USAGE();
        return 0;
    }

    for (int i = 1; i < argc; i++) {
        if (QLatin1String(argv[i]) == "--xml") {
            generateXml = true;
            continue;
        } else if (QLatin1String(argv[i]) == "--help" || QLatin1String(argv[i]) == "-h") {
            PRINT_USAGE();
            continue;
        }

        parents[loadSmokeModule(QFileInfo(argv[i]))] = QSet<Smoke*>();
    }

    for (QHash<Smoke*, QSet<Smoke*> >::iterator iter = parents.begin(); iter != parents.end(); iter++) {
        for (short i = 1; i <= iter.key()->numClasses; i++) {
            Smoke::Class *klass = iter.key()->classes + i;

            for (short* idx = iter.key()->inheritanceList + klass->parents; *idx; idx++) {
                Smoke::Class *parentClass = iter.key()->classes + *idx;
                if (!parentClass->external)
                    continue;

                Smoke* parentModule = 0;
                if ((parentModule = iter.key()->findClass(parentClass->className).smoke)) {
                    iter.value().insert(parentModule);
                } else {
                    qWarning() << "WARNING: missing parent module for class" << parentClass->className;
                }
            }
        }
    }

    for (QHash<Smoke*, QSet<Smoke*> >::iterator iter = parents.begin(); iter != parents.end(); iter++) {
        // remove dependencies that are already covered by other parent modules
        foreach (Smoke* smoke, iter.value()) {
            iter.value() -= parents[smoke];
        }
    }

    QTextStream qOut(stdout);
    QList<Smoke*> smokeModules = parents.keys();
    qSort(smokeModules.begin(), smokeModules.end(), smokeModuleLessThan);
    foreach(Smoke* smoke, smokeModules) {
        qDebug() << "parent modules for" << smoke->moduleName();

        QList<Smoke*> sortedList = parents[smoke].toList();
        qSort(sortedList.begin(), sortedList.end(), smokeModuleLessThan);

        if (generateXml) {
            qOut << "    <parentModules>" << endl;
            foreach (Smoke* parent, sortedList) {
                qOut << "        <module>" << parent->moduleName() << "</module>" << endl;
            }
            qOut << "    </parentModules>" << endl;
        } else {
            foreach (Smoke* parent, sortedList) {
                qOut << "  * " << parent->moduleName() << endl;
            }
        }
    }

    foreach (Smoke* smoke, parents.keys())
        delete smoke;

    return 0;
}
