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

#include <QCoreApplication>
#include <QDir>
#include <QFileInfo>
#include <QHash>
#include <QSet>
#include <QString>
#include <QtDebug>

#include <QtXml>

#include <iostream>

#include <type.h>

#include "globals.h"
#include "../../options.h"

QDir Options::outputDir = QDir::current();
QList<QFileInfo> Options::headerList;
QStringList Options::classList;

int Options::parts = 20;
QString Options::module = "qt";
QStringList Options::parentModules;
QStringList Options::scalarTypes;
QStringList Options::voidpTypes;
bool Options::qtMode = false;
QList<QRegExp> Options::excludeExpressions;
QList<QRegExp> Options::includeFunctionNames;
QList<QRegExp> Options::includeFunctionSignatures;

static void showUsage()
{
    std::cout <<
    "Usage: generator -g smoke [smoke generator options] [other generator options] -- <headers>" << std::endl <<
    "    -m <module name> (default: 'qt')" << std::endl <<
    "    -p <parts> (default: 20)" << std::endl <<
    "    -pm <comma-seperated list of parent modules>" << std::endl <<
    "    -st <comma-seperated list of types that should be munged to scalars>" << std::endl <<
    "    -vt <comma-seperated list of types that should be mapped to Smoke::t_voidp>" << std::endl;
}

extern "C" Q_DECL_EXPORT
int generate()
{
    Options::headerList = ParserOptions::headerList;
    
    QFileInfo smokeConfig;
    
    const QStringList& args = QCoreApplication::arguments();
    for (int i = 0; i < args.count(); i++) {
        if ((args[i] == "-m" || args[i] == "-p" || args[i] == "-pm" || args[i] == "-o" ||
             args[i] == "-st" || args[i] == "-vt" || args[i] == "-smokeconfig") && i + 1 >= args.count())
        {
            qCritical() << "generator_smoke: not enough parameters for option" << args[i];
            return EXIT_FAILURE;
        } else if (args[i] == "-m") {
            Options::module = args[++i];
        } else if (args[i] == "-p") {
            bool ok = false;
            Options::parts = args[++i].toInt(&ok);
            if (!ok) {
                qCritical() << "generator_smoke: couldn't parse argument for option" << args[i - 1];
                return EXIT_FAILURE;
            }
        } else if (args[i] == "-pm") {
            Options::parentModules = args[++i].split(',');
        } else if (args[i] == "-st") {
            Options::scalarTypes = args[++i].split(',');
        } else if (args[i] == "-vt") {
            Options::voidpTypes = args[++i].split(',');
        } else if (args[i] == "-smokeconfig") {
            smokeConfig = QFileInfo(args[++i]);
        } else if (args[i] == "-o") {
            Options::outputDir = QDir(args[++i]);
        } else if (args[i] == "-h" || args[i] == "--help") {
            showUsage();
            return EXIT_SUCCESS;
        }
    }
    
    if (smokeConfig.exists()) {
        QFile file(smokeConfig.filePath());
        file.open(QIODevice::ReadOnly);
        QDomDocument doc;
        doc.setContent(file.readAll());
        file.close();
        QDomElement root = doc.documentElement();
        QDomNode node = root.firstChild();
        while (!node.isNull()) {
            QDomElement elem = node.toElement();
            if (elem.isNull()) {
                node = node.nextSibling();
                continue;
            }
            if (elem.tagName() == "outputDir") {
                Options::outputDir = QDir(elem.text());
            } else if (elem.tagName() == "moduleName") {
                Options::module = elem.text();
            } else if (elem.tagName() == "parts") {
                Options::parts = elem.text().toInt();
            } else if (elem.tagName() == "parentModules") {
                QDomNode parent = elem.firstChild();
                while (!parent.isNull()) {
                    QDomElement elem = parent.toElement();
                    if (elem.isNull()) {
                        parent = parent.nextSibling();
                        continue;
                    }
                    if (elem.tagName() == "module") {
                        Options::parentModules << elem.text();
                    }
                    parent = parent.nextSibling();
                }
            } else if (elem.tagName() == "scalarTypes") {
                QDomNode typeName = elem.firstChild();
                while (!typeName.isNull()) {
                    QDomElement elem = typeName.toElement();
                    if (elem.isNull()) {
                        typeName = typeName.nextSibling();
                        continue;
                    }
                    if (elem.tagName() == "typeName") {
                        Options::scalarTypes << elem.text();
                    }
                    typeName = typeName.nextSibling();
                }
            } else if (elem.tagName() == "voidpTypes") {
                QDomNode typeName = elem.firstChild();
                while (!typeName.isNull()) {
                    QDomElement elem = typeName.toElement();
                    if (elem.isNull()) {
                        typeName = typeName.nextSibling();
                        continue;
                    }
                    if (elem.tagName() == "typeName") {
                        Options::voidpTypes << elem.text();
                    }
                    typeName = typeName.nextSibling();
                }
            } else if (elem.tagName() == "classList") {
                QDomNode klass = elem.firstChild();
                while (!klass.isNull()) {
                    QDomElement elem = klass.toElement();
                    if (elem.isNull()) {
                        klass = klass.nextSibling();
                        continue;
                    }
                    if (elem.tagName() == "class") {
                        Options::classList << elem.text();
                    }
                    klass = klass.nextSibling();
                }
            } else if (elem.tagName() == "exclude") {
                QDomNode typeName = elem.firstChild();
                while (!typeName.isNull()) {
                    QDomElement elem = typeName.toElement();
                    if (elem.isNull()) {
                        typeName = typeName.nextSibling();
                        continue;
                    }
                    if (elem.tagName() == "signature") {
                        Options::excludeExpressions << QRegExp(elem.text());
                    }
                    typeName = typeName.nextSibling();
                }
            } else if (elem.tagName() == "functions") {
                QDomNode function = elem.firstChild();
                while (!function.isNull()) {
                    QDomElement elem = function.toElement();
                    if (elem.isNull()) {
                        function = function.nextSibling();
                        continue;
                    }
                    if (elem.tagName() == "name") {
                        Options::includeFunctionNames << QRegExp(elem.text());
                    } else if (elem.tagName() == "signature") {
                        Options::includeFunctionSignatures << QRegExp(elem.text());
                    }
                    function = function.nextSibling();
                }
            }
            node = node.nextSibling();
        }
    } else {
        qWarning() << "Couldn't find config file" << smokeConfig.filePath();
    }
    
    if (!Options::outputDir.exists()) {
        qWarning() << "output directoy" << Options::outputDir.path() << "doesn't exist; creating it...";
        QDir::current().mkpath(Options::outputDir.path());
    }
    
    Options::qtMode = ParserOptions::qtMode;

    Options::voidpTypes << "long long" << "long long int" << "unsigned long long" << "unsigned long long int";
    Options::scalarTypes << "long long" << "long long int" << "unsigned long long" << "unsigned long long int";
    
    // Fill the type map. It maps some long integral types to shorter forms as used in SMOKE.
    Util::typeMap["long int"] = "long";
    Util::typeMap["short int"] = "short";
    Util::typeMap["long double"] = "double";
    Util::typeMap["wchar_t"] = "int";   // correct?

    if (sizeof(unsigned int) == sizeof(size_t)) {
        Util::typeMap["size_t"] = "uint";
    } else if (sizeof(unsigned long) == sizeof(size_t)) {
        Util::typeMap["size_t"] = "ulong";
    }

    qDebug() << "Generating SMOKE sources...";
    
    SmokeDataFile smokeData;
    smokeData.write();
    SmokeClassFiles classFiles(&smokeData);
    classFiles.write();
    
    qDebug() << "Done.";
    
    return EXIT_SUCCESS;
}
