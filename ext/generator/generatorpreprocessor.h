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

#ifndef GENERATORPREPROCESSOR_H
#define GENERATORPREPROCESSOR_H

#include <QDir>
#include <QFileInfo>
#include <QHash>
#include <QList>
#include <QPair>
#include <QStack>
#include <QString>

#include <rpp/pp-engine.h>
#include <rpp/pp-stream.h>
#include <rpp/preprocessor.h>

namespace rpp {
    class MacroBlock;
}

extern QList<QString> parsedHeaders;

class Preprocessor : public rpp::Preprocessor
{
public:
    Preprocessor(const QList<QDir>& includeDirs = QList<QDir>(), const QStringList& defines = QStringList(),
                 const QFileInfo& file = QFileInfo());
    virtual ~Preprocessor();
    
    virtual rpp::Stream* sourceNeeded(QString& fileName, rpp::Preprocessor::IncludeType type, int sourceLine, bool skipCurrentPath);

    void setFile(const QFileInfo& file);
    QFileInfo file();
    
    void setIncludeDirs(QList<QDir> dirs);
    QList<QDir> includeDirs();
    
    void setDefines(QStringList defines);
    QStringList defines();
    
    PreprocessedContents preprocess();
    PreprocessedContents lastContents();

private:
    rpp::pp *pp;
    rpp::MacroBlock *m_topBlock;
    QList<QDir> m_includeDirs;
    QStringList m_defines;
    QFileInfo m_file;
    PreprocessedContents m_contents;
    QHash<QString, QPair<QFileInfo, PreprocessedContents> > m_cache;
    QList<PreprocessedContents> m_localContent;
    QStack<QFileInfo> m_fileStack;
};

class HeaderStream : public rpp::Stream
{
public:
    HeaderStream(PreprocessedContents* contents, QStack<QFileInfo>* stack) : rpp::Stream(contents), m_stack(stack) {}
    virtual ~HeaderStream() { m_stack->pop(); }

private:
    QStack<QFileInfo>* m_stack;
};

#endif // GENERATORPREPROCESSOR_H
