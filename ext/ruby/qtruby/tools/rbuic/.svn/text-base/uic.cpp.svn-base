/****************************************************************************
**
** Copyright (C) 1992-2008 Trolltech ASA. All rights reserved.
**
** This file is part of the tools applications of the Qt Toolkit.
**
** This file may be used under the terms of the GNU General Public
** License versions 2.0 or 3.0 as published by the Free Software
** Foundation and appearing in the files LICENSE.GPL2 and LICENSE.GPL3
** included in the packaging of this file.  Alternatively you may (at
** your option) use any later version of the GNU General Public
** License if such license has been publicly approved by Trolltech ASA
** (or its successors, if any) and the KDE Free Qt Foundation. In
** addition, as a special exception, Trolltech gives you certain
** additional rights. These rights are described in the Trolltech GPL
** Exception version 1.2, which can be found at
** http://www.trolltech.com/products/qt/gplexception/ and in the file
** GPL_EXCEPTION.txt in this package.
**
** Please review the following information to ensure GNU General
** Public Licensing requirements will be met:
** http://trolltech.com/products/qt/licenses/licensing/opensource/. If
** you are unsure which license is appropriate for your use, please
** review the following information:
** http://trolltech.com/products/qt/licenses/licensing/licensingoverview
** or contact the sales department at sales@trolltech.com.
**
** In addition, as a special exception, Trolltech, as the sole
** copyright holder for Qt Designer, grants users of the Qt/Eclipse
** Integration plug-in the right for the Qt/Eclipse Integration to
** link to functionality provided by Qt Designer and its related
** libraries.
**
** This file is provided "AS IS" with NO WARRANTY OF ANY KIND,
** INCLUDING THE WARRANTIES OF DESIGN, MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE. Trolltech reserves all rights not expressly
** granted herein.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
****************************************************************************/

#include "uic.h"
#include "ui4.h"
#include "driver.h"
#include "option.h"
#include "treewalker.h"
#include "validator.h"

#ifdef QT_UIC_CPP_GENERATOR
#include "cppwriteincludes.h"
#include "cppwritedeclaration.h"
#endif

#ifdef QT_UIC_JAVA_GENERATOR
#include "javawriteincludes.h"
#include "javawritedeclaration.h"
#endif

#ifdef QT_UIC_RUBY_GENERATOR
#include "rbwritedeclaration.h"
#endif

#include <QtXml/QDomDocument>
#include <QtCore/QFileInfo>
#include <QtCore/QRegExp>
#include <QtCore/QTextStream>
#include <QtCore/QDateTime>

#if defined Q_WS_WIN
#include <qt_windows.h>
#endif

#if defined(QT_BEGIN_NAMESPACE)
  QT_BEGIN_NAMESPACE
#endif

Uic::Uic(Driver *d)
     : drv(d),
       out(d->output()),
       opt(d->option()),
       info(d),
       externalPix(true)
{
}

Uic::~Uic()
{
}

bool Uic::printDependencies()
{
    QString fileName = opt.inputFile;

    QFile f;
    if (fileName.isEmpty())
        f.open(stdin, QIODevice::ReadOnly);
    else {
        f.setFileName(fileName);
        if (!f.open(QIODevice::ReadOnly))
            return false;
    }

    QDomDocument doc;                        // ### generalize. share more code with the other tools!
    if (!doc.setContent(&f))
        return false;

    QDomElement root = doc.firstChildElement();
    DomUI *ui = new DomUI();
    ui->read(root);

    double version = ui->attributeVersion().toDouble();
    if (version < 4.0) {
        delete ui;

        fprintf(stderr, "uic: File generated with too old version of Qt Designer\n");
        return false;
    }

    if (DomIncludes *includes = ui->elementIncludes()) {
        foreach (DomInclude *incl, includes->elementInclude()) {
            QString file = incl->text();
            if (file.isEmpty())
                continue;

            fprintf(stdout, "%s\n", file.toLocal8Bit().constData());
        }
    }

    if (DomCustomWidgets *customWidgets = ui->elementCustomWidgets()) {
        foreach (DomCustomWidget *customWidget, customWidgets->elementCustomWidget()) {
            if (DomHeader *header = customWidget->elementHeader()) {
                QString file = header->text();
                if (file.isEmpty())
                    continue;

                fprintf(stdout, "%s\n", file.toLocal8Bit().constData());
            }
        }
    }

    delete ui;

    return true;
}

void Uic::writeCopyrightHeader(DomUI *ui)
{
    QString comment = ui->elementComment();
#ifdef QT_UIC_RUBY_GENERATOR
    if (comment.size())
        out << "=begin\n" << comment << "\n=end\n\n";

	out << "=begin\n";
	out << "** Form generated from reading ui file '" << QFileInfo(opt.inputFile).fileName() << "'\n";
	out << "**\n";
	out << "** Created: " << QDateTime::currentDateTime().toString() << "\n";
	out << "**      " << QString("by: Qt User Interface Compiler version %1\n").arg(QT_VERSION_STR);
	out << "**\n";
	out << "** WARNING! All changes made in this file will be lost when recompiling ui file!\n";
	out << "=end\n\n";
#else
    if (comment.size())
        out << "/*\n" << comment << "\n*/\n\n";

        out << "/********************************************************************************\n";
        out << "** Form generated from reading ui file '" << QFileInfo(opt.inputFile).fileName() << "'\n";
        out << "**\n";
        out << "** Created: " << QDateTime::currentDateTime().toString() << "\n";
        out << "**      " << QString::fromLatin1("by: Qt User Interface Compiler version %1\n").arg(QLatin1String(QT_VERSION_STR));
        out << "**\n";
        out << "** WARNING! All changes made in this file will be lost when recompiling ui file!\n";
        out << "********************************************************************************/\n\n";
#endif
}

bool Uic::write(QIODevice *in)
{
    QDomDocument doc;
    if (!doc.setContent(in))
        return false;

    if (option().generator == Option::JavaGenerator) {
         // the Java generator ignores header protection
        opt.headerProtection = false;
    }

    QDomElement root = doc.firstChildElement();
    DomUI *ui = new DomUI();
    ui->read(root);

    double version = ui->attributeVersion().toDouble();
    if (version < 4.0) {
        delete ui;

        fprintf(stderr, "uic: File generated with too old version of Qt Designer\n");
        return false;
    }

    QString language = ui->attributeLanguage();


    bool rtn = false;

    if (option().generator == Option::JavaGenerator) {
#ifdef QT_UIC_JAVA_GENERATOR
        if (language.toLower() != QLatin1String("jambi")) {
            fprintf(stderr, "uic: File is not a 'jambi' form\n");
            return false;
        }
        rtn = jwrite (ui);
#else
        fprintf(stderr, "uic: option to generate java code not compiled in\n");
#endif
    } else if (option().generator == Option::RubyGenerator) {
#ifdef QT_UIC_RUBY_GENERATOR
        rtn = rbwrite (ui);
#else
        fprintf(stderr, "uic: option to generate ruby code not compiled in\n");
#endif
    } else {
#ifdef QT_UIC_CPP_GENERATOR
        if (!language.isEmpty() && language.toLower() != QLatin1String("c++")) {
            fprintf(stderr, "uic: File is not a 'c++' ui file, language=%s\n", qPrintable(language));
            return false;
        }

        rtn = write (ui);
#else
        fprintf(stderr, "uic: option to generate cpp code not compiled in\n");
#endif
    }

    delete ui;

    return rtn;
}

#ifdef QT_UIC_CPP_GENERATOR
bool Uic::write(DomUI *ui)
{
    using namespace CPP;

    if (!ui || !ui->elementWidget())
        return false;

    if (opt.copyrightHeader)
        writeCopyrightHeader(ui);

    if (opt.headerProtection) {
        writeHeaderProtectionStart();
        out << "\n";
    }

    pixFunction = ui->elementPixmapFunction();
    if (pixFunction == QLatin1String("QPixmap::fromMimeSource"))
        pixFunction = QLatin1String("qPixmapFromMimeSource");

    externalPix = ui->elementImages() == 0;

    info.acceptUI(ui);
    cWidgetsInfo.acceptUI(ui);
    WriteIncludes writeIncludes(this);
    writeIncludes.acceptUI(ui);

    Validator(this).acceptUI(ui);
    WriteDeclaration(this, writeIncludes.scriptsActivated()).acceptUI(ui);

    if (opt.headerProtection)
        writeHeaderProtectionEnd();

    return true;
}
#endif

#ifdef QT_UIC_JAVA_GENERATOR
bool Uic::jwrite(DomUI *ui)
{
    using namespace Java;

    if (!ui || !ui->elementWidget())
        return false;

    if (opt.copyrightHeader)
        writeCopyrightHeader(ui);

    pixFunction = ui->elementPixmapFunction();
    if (pixFunction == QLatin1String("QPixmap::fromMimeSource"))
        pixFunction = QLatin1String("qPixmapFromMimeSource");

    externalPix = ui->elementImages() == 0;

    info.acceptUI(ui);
    cWidgetsInfo.acceptUI(ui);
    WriteIncludes(this).acceptUI(ui);

    Validator(this).acceptUI(ui);
    WriteDeclaration(this).acceptUI(ui);

    return true;
}
#endif

#ifdef QT_UIC_RUBY_GENERATOR
bool Uic::rbwrite(DomUI *ui)
{
    using namespace Ruby;

    if (!ui || !ui->elementWidget())
        return false;

    if (opt.copyrightHeader)
        writeCopyrightHeader(ui);

    pixFunction = ui->elementPixmapFunction();
    if (pixFunction == QLatin1String("Qt::Pixmap::fromMimeSource"))
        pixFunction = QLatin1String("qPixmapFromMimeSource");

    externalPix = ui->elementImages() == 0;

    info.acceptUI(ui);
    cWidgetsInfo.acceptUI(ui);
//    WriteIncludes(this).acceptUI(ui);

    Validator(this).acceptUI(ui);
    if (option().execCode) {
    	if (option().useKDE) {
			out << "require 'korundum4'" << endl << endl;
		} else {
			out << "require 'Qt4'" << endl << endl;
		}
	}

    WriteDeclaration(this).acceptUI(ui);

    if (option().execCode) {
		QString qualifiedClassName = ui->elementClass() + option().postfix;
		QString className = qualifiedClassName.mid(0, 1).toUpper() + qualifiedClassName.mid(1);
		DomWidget*  parentWidget = ui->elementWidget();
		QString parentClass = parentWidget->attributeClass();

    	if (option().useKDE) {
			out << "if $0 == __FILE__" << endl;
			out << option().indent << "about = KDE::AboutData.new(\"" << className.toLower() << "\", \"" << className << "\", KDE.ki18n(\"\"), \"0.1\")" << endl;
			out << option().indent << "KDE::CmdLineArgs.init(ARGV, about)" << endl;
			out << option().indent << "a = KDE::Application.new" << endl;
			out << option().indent << "u = " << option().prefix << className << ".new" << endl;
			parentClass.replace(QRegExp("^Q"), "Qt::");
			parentClass.replace(QRegExp("^K"), "KDE::");
			out << option().indent << "w = " << parentClass << ".new" << endl;
			out << option().indent << "u.setupUi(w)" << endl;
			out << option().indent << "a.topWidget = w" << endl;
			out << option().indent << "w.show" << endl;
			out << option().indent << "a.exec" << endl;
			out << "end" << endl;
		} else {
			out << "if $0 == __FILE__" << endl;
			out << option().indent << "a = Qt::Application.new(ARGV)" << endl;
			out << option().indent << "u = " << option().prefix << className << ".new" << endl;
			parentClass.replace(QRegExp("^Q"), "Qt::");
			out << option().indent << "w = " << parentClass << ".new" << endl;
			out << option().indent << "u.setupUi(w)" << endl;
			out << option().indent << "w.show" << endl;
			out << option().indent << "a.exec" << endl;
			out << "end" << endl;
		}
    }

    return true;
}
#endif

#ifdef QT_UIC_CPP_GENERATOR

void Uic::writeHeaderProtectionStart()
{
    QString h = drv->headerFileName();
    out << "#ifndef " << h << "\n"
        << "#define " << h << "\n";
}

void Uic::writeHeaderProtectionEnd()
{
    QString h = drv->headerFileName();
    out << "#endif // " << h << "\n";
}
#endif

bool Uic::isMainWindow(const QString &className) const
{
    return customWidgetsInfo()->extends(className, QLatin1String("Q3MainWindow"))
        || customWidgetsInfo()->extends(className, QLatin1String("QMainWindow"));
}

bool Uic::isToolBar(const QString &className) const
{
    return customWidgetsInfo()->extends(className, QLatin1String("Q3ToolBar"))
        || customWidgetsInfo()->extends(className, QLatin1String("QToolBar"));
}

bool Uic::isButton(const QString &className) const
{
    return customWidgetsInfo()->extends(className, QLatin1String("QRadioButton"))
        || customWidgetsInfo()->extends(className, QLatin1String("QToolButton"))
        || customWidgetsInfo()->extends(className, QLatin1String("QCheckBox"))
        || customWidgetsInfo()->extends(className, QLatin1String("QPushButton"));
}

bool Uic::isContainer(const QString &className) const
{
    return customWidgetsInfo()->extends(className, QLatin1String("QStackedWidget"))
        || customWidgetsInfo()->extends(className, QLatin1String("QToolBox"))
        || customWidgetsInfo()->extends(className, QLatin1String("QTabWidget"))
        || customWidgetsInfo()->extends(className, QLatin1String("QScrollArea"))
        || customWidgetsInfo()->extends(className, QLatin1String("QMdiArea"))
        || customWidgetsInfo()->extends(className, QLatin1String("QWizard"));
}

bool Uic::isStatusBar(const QString &className) const
{
    return customWidgetsInfo()->extends(className, QLatin1String("QStatusBar"));
}

bool Uic::isMenuBar(const QString &className) const
{
    return customWidgetsInfo()->extends(className, QLatin1String("QMenuBar"));
}

bool Uic::isMenu(const QString &className) const
{
    return customWidgetsInfo()->extends(className, QLatin1String("QMenu"))
        || customWidgetsInfo()->extends(className, QLatin1String("QPopupMenu"));
}

#if defined(QT_END_NAMESPACE)
  QT_END_NAMESPACE
#endif
