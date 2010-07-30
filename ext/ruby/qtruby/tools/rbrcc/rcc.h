/****************************************************************************
**
** Copyright (C) 1992-2006 Trolltech AS. All rights reserved.
**
** This file is part of the tools applications of the Qt Toolkit.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** this file.  Please review the following information to ensure GNU
** General Public Licensing requirements will be met:
** http://www.trolltech.com/products/qt/opensource.html
**
** If you are unsure which license is appropriate for your use, please
** review the following information:
** http://www.trolltech.com/products/qt/licensing.html or contact the
** sales department at sales@trolltech.com.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
****************************************************************************/

#ifndef RCC_H
#define RCC_H

#include <QtCore/QStringList>
#include <QtCore/QFileInfo>
#include <QtCore/QLocale>
#include <QtCore/QHash>
#include <QtCore/QString>

#define TAG_RCC "RCC"
#define TAG_RESOURCE "qresource"
#define TAG_FILE "file"

#define ATTRIBUTE_LANG "lang"
#define ATTRIBUTE_PREFIX "prefix"
#define ATTRIBUTE_ALIAS "alias"
#define ATTRIBUTE_THRESHOLD "threshold"
#define ATTRIBUTE_COMPRESS "compress"

#define CONSTANT_HEADER_SIZE 8
#define CONSTANT_COMPRESSLEVEL_DEFAULT 0
#define CONSTANT_COMPRESSTHRESHOLD_DEFAULT 70

struct RCCFileInfo;

class RCCResourceLibrary
{
public:
    inline RCCResourceLibrary();
    ~RCCResourceLibrary();

    bool output(FILE *out);

    bool readFiles(bool ignoreErrors=false);

    enum Format { Binary, C_Code };
    inline void setFormat(Format f) { mFormat = f; }
    inline Format format() const { return mFormat; }

    inline void setInputFiles(QStringList files) { mFileNames = files; }
    inline QStringList inputFiles() const { return mFileNames; }

    QStringList dataFiles() const;

    inline void setVerbose(bool b) { mVerbose = b; }
    inline bool verbose() const { return mVerbose; }

    inline void setInitName(const QString &n) { mInitName = n; }
    inline QString initName() const { return mInitName; }

    inline void setCompressLevel(int c) { mCompressLevel = c; }
    inline int compressLevel() const { return mCompressLevel; }

    inline void setCompressThreshold(int t) { mCompressThreshold = t; }
    inline int compressThreshold() const { return mCompressThreshold; }

    inline void setResourceRoot(QString str) { mResourceRoot = str; }
    inline QString resourceRoot() const { return mResourceRoot; }

private:
    RCCFileInfo *root;
    bool addFile(const QString &alias, const RCCFileInfo &file);
    bool interpretResourceFile(QIODevice *inputDevice, QString file, QString currentPath = QString(), bool ignoreErrors = false);

    bool writeHeader(FILE *out);
    bool writeDataBlobs(FILE *out);
    bool writeDataNames(FILE *out);
    bool writeDataStructure(FILE *out);
    bool writeInitializer(FILE *out);

    QStringList mFileNames;
    QString mResourceRoot, mInitName;
    Format mFormat;
    bool mVerbose;
    int mCompressLevel;
    int mCompressThreshold;
    int mTreeOffset, mNamesOffset, mDataOffset;
};

inline RCCResourceLibrary::RCCResourceLibrary()
{
    root = 0;
    mVerbose = false;
    mFormat = C_Code;
    mCompressLevel = -1;
    mCompressThreshold = 70;
    mTreeOffset = mNamesOffset = mDataOffset = 0;
}

struct RCCFileInfo
{
    enum Flags
    {
        NoFlags = 0x00,
        Compressed = 0x01,
        Directory = 0x02
    };

    inline RCCFileInfo(QString name = QString(), QFileInfo fileInfo = QFileInfo(),
                       QLocale::Language language = QLocale::C, 
                       QLocale::Country country = QLocale::AnyCountry,
                       uint flags = NoFlags,
                       int compressLevel = CONSTANT_COMPRESSLEVEL_DEFAULT, int compressThreshold = CONSTANT_COMPRESSTHRESHOLD_DEFAULT);
    ~RCCFileInfo() { qDeleteAll(children); }
    inline QString resourceName() {
        QString resource = name;
        for(RCCFileInfo *p = parent; p; p = p->parent)
            resource = resource.prepend(p->name + "/");
        return ":" + resource;
    }

    int flags;
    QString name;
    QLocale::Language language;
    QLocale::Country country;
    QFileInfo fileInfo;
    RCCFileInfo *parent;
    QHash<QString, RCCFileInfo*> children;
    int mCompressLevel;
    int mCompressThreshold;

    qint64 nameOffset, dataOffset, childOffset;
    qint64 writeDataBlob(FILE *out, qint64 offset, RCCResourceLibrary::Format format);
    qint64 writeDataName(FILE *out, qint64 offset, RCCResourceLibrary::Format format);
    bool   writeDataInfo(FILE *out, RCCResourceLibrary::Format format);
};

inline RCCFileInfo::RCCFileInfo(QString name, QFileInfo fileInfo, QLocale::Language language, QLocale::Country country, uint flags,
                                int compressLevel, int compressThreshold)
{
    this->name = name;
    this->fileInfo = fileInfo;
    this->language = language;
    this->country = country;
    this->flags = flags;
    this->parent = 0;
    this->nameOffset = this->dataOffset = this->childOffset = 0;
    this->mCompressLevel = compressLevel;
    this->mCompressThreshold = compressThreshold;
}

#endif // RCC_H
