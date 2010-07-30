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
** your m_option) use any later version of the GNU General Public
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

#include "rbwritedeclaration.h"
#include "rbwriteicondeclaration.h"
#include "rbwriteinitialization.h"
#include "rbwriteiconinitialization.h"
#include "driver.h"
#include "ui4.h"
#include "uic.h"
#include "databaseinfo.h"
#include "customwidgetsinfo.h"

#include <QtCore/QTextStream>

namespace Ruby {

WriteDeclaration::WriteDeclaration(Uic *uic)  :
    m_uic(uic),
    m_driver(uic->driver()),
    m_output(uic->output()),
    m_option(uic->option())
{
}

void WriteDeclaration::acceptUI(DomUI *node)
{
    QString qualifiedClassName = node->elementClass() + m_option.postfix;
    // Ruby classnames must start with an upper case letter
    QString className = qualifiedClassName.mid(0, 1).toUpper() + qualifiedClassName.mid(1);

    QString varName = m_driver->findOrInsertWidget(node->elementWidget());
    QString widgetClassName = node->elementWidget()->attributeClass();

    QString exportMacro = node->elementExportMacro();
    if (!exportMacro.isEmpty())
        exportMacro.append(QLatin1Char(' '));

    QStringList namespaceList = qualifiedClassName.split(QLatin1String("::"));
    if (namespaceList.count()) {
        className = namespaceList.last().mid(0, 1).toUpper() + namespaceList.last().mid(1);
        namespaceList.removeLast();
    }

    QListIterator<QString> it(namespaceList);
    while (it.hasNext()) {
        QString ns = it.next();
        if (ns.isEmpty())
            continue;
    }

    if (namespaceList.count())
        m_output << "\n";

    m_output << "class " << m_option.prefix << className << "\n";

    const QStringList connections = m_uic->databaseInfo()->connections();
    for (int i=0; i<connections.size(); ++i) {
        const QString connection = connections.at(i);

        if (connection == QLatin1String("(default)"))
            continue;

        m_output << m_option.indent << "@" << connection << "Connection = Qt::SqlDatabase.new\n";
    }

    TreeWalker::acceptWidget(node->elementWidget());

    m_output << "\n";

    WriteInitialization(m_uic).acceptUI(node);

    if (node->elementImages()) {
        WriteIconDeclaration(m_uic).acceptUI(node);

        m_output << m_option.indent << m_option.indent << "unknown_ID = "
            << node->elementImages()->elementImage().size() << "\n"
            << m_option.indent << "\n";

        WriteIconInitialization(m_uic).acceptUI(node);
    }

    m_output << "end\n\n";

    it.toBack();
    while (it.hasPrevious()) {
        QString ns = it.previous();
        if (ns.isEmpty())
            continue;
    }

    if (namespaceList.count())
        m_output << "\n";

    if (m_option.generateNamespace && !m_option.prefix.isEmpty()) {
        namespaceList.append(QLatin1String("Ui"));

        QListIterator<QString> it(namespaceList);
        while (it.hasNext()) {
            QString ns = it.next();
            if (ns.isEmpty())
                continue;

            m_output << "module " << ns.mid(0, 1).toUpper() << ns.mid(1) << "\n";
        }

        m_output << m_option.indent << "class "  << className << " < " << m_option.prefix << className << "\n";
        m_output << m_option.indent << "end\n";

        it.toBack();
        while (it.hasPrevious()) {
            QString ns = it.previous();
            if (ns.isEmpty())
                continue;

            m_output << "end  # module " << ns << "\n";
        }

        if (namespaceList.count())
            m_output << "\n";
    }
}

void WriteDeclaration::acceptWidget(DomWidget *node)
{
    QString className = QLatin1String("Qt::Widget");
    if (node->hasAttributeClass())
        className = node->attributeClass();

	QString item = m_driver->findOrInsertWidget(node);
	item = item.mid(0, 1).toLower() + item.mid(1);
    m_output << m_option.indent << "attr_reader :" << item << "\n";

    TreeWalker::acceptWidget(node);
}

void WriteDeclaration::acceptLayout(DomLayout *node)
{
    QString className = QLatin1String("Qt::Layout");
    if (node->hasAttributeClass())
        className = node->attributeClass();

	QString item = m_driver->findOrInsertLayout(node);
	item = item.mid(0, 1).toLower() + item.mid(1);
    m_output << m_option.indent << "attr_reader :" << item << "\n";

    TreeWalker::acceptLayout(node);
}

void WriteDeclaration::acceptSpacer(DomSpacer *node)
{
	QString item = m_driver->findOrInsertSpacer(node);
	item = item.mid(0, 1).toLower() + item.mid(1);
    m_output << m_option.indent << "attr_reader :" << item << "\n";

    TreeWalker::acceptSpacer(node);
}

void WriteDeclaration::acceptActionGroup(DomActionGroup *node)
{
	QString item = m_driver->findOrInsertActionGroup(node);
	item = item.mid(0, 1).toLower() + item.mid(1);
    m_output << m_option.indent << "attr_reader :" << item << "\n";

    TreeWalker::acceptActionGroup(node);
}

void WriteDeclaration::acceptAction(DomAction *node)
{
	QString item = m_driver->findOrInsertAction(node);
	item = item.mid(0, 1).toLower() + item.mid(1);
    m_output << m_option.indent << "attr_reader :" << item << "\n";

    TreeWalker::acceptAction(node);
}

} // namespace Ruby
