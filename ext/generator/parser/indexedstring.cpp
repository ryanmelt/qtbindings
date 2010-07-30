/***************************************************************************
   Copyright 2008 David Nolden <david.nolden.kdevelop@art-master.de>
***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

#include <QtCore/QStringList>
#include <QtCore/QUrl>
#include <QtDebug>

#include "indexedstring.h"
// #include "repositories/stringrepository.h"

// #include "referencecounting.h"

Q_GLOBAL_STATIC(QStringList, strings);

int getIndex(const QString& str) {
    int idx = strings()->indexOf(str);
    if (idx > -1) return idx;
    strings()->append(str);
    return strings()->count() - 1;
}

IndexedString::IndexedString() : m_index(0) {
}

///@param str must be a utf8 encoded string, does not need to be 0-terminated.
///@param length must be its length in bytes.
IndexedString::IndexedString( const char* str, unsigned short length, unsigned int hash ) {
  if(!length)
    m_index = 0;
  else if(length == 1)
    m_index = 0xffff0000 | str[0];
  else {
    m_index = getIndex(QString::fromUtf8(str, length));
    /*QMutexLocker lock(globalIndexedStringRepository->mutex());
    
    m_index = globalIndexedStringRepository->index(IndexedStringRepositoryItemRequest(str, hash ? hash : hashString(str, length), length));
    
    if(shouldDoDUChainReferenceCounting(this))
      increase(globalIndexedStringRepository->dynamicItemFromIndexSimple(m_index)->refCount);*/
  }
}

IndexedString::IndexedString( char c ) {
  m_index = 0xffff0000 | c;
}

IndexedString::IndexedString( const QUrl& url ) {
  QByteArray array(url.path().toUtf8());

  const char* str = array.constData();

  int size = array.size();

  if(!size)
    m_index = 0;
  else if(size == 1)
    m_index = 0xffff0000 | str[0];
  else {
    m_index = getIndex(QString::fromUtf8(str));
    /*QMutexLocker lock(globalIndexedStringRepository->mutex());
    m_index = globalIndexedStringRepository->index(IndexedStringRepositoryItemRequest(str, hashString(str, size), size));
    
    if(shouldDoDUChainReferenceCounting(this))
      increase(globalIndexedStringRepository->dynamicItemFromIndexSimple(m_index)->refCount);*/
  }
}

IndexedString::IndexedString( const QString& string ) {
  QByteArray array(string.toUtf8());

  const char* str = array.constData();

  int size = array.size();

  if(!size)
    m_index = 0;
  else if(size == 1)
    m_index = 0xffff0000 | str[0];
  else {
    m_index = getIndex(string);
    /*QMutexLocker lock(globalIndexedStringRepository->mutex());
    m_index = globalIndexedStringRepository->index(IndexedStringRepositoryItemRequest(str, hashString(str, size), size));

    if(shouldDoDUChainReferenceCounting(this))
      increase(globalIndexedStringRepository->dynamicItemFromIndexSimple(m_index)->refCount);*/
  }
}

IndexedString::IndexedString( const char* str) {
  unsigned int length = strlen(str);
  if(!length)
    m_index = 0;
  else if(length == 1)
    m_index = 0xffff0000 | str[0];
  else {
    m_index = getIndex(QString::fromUtf8(str));
    /*QMutexLocker lock(globalIndexedStringRepository->mutex());
    m_index = globalIndexedStringRepository->index(IndexedStringRepositoryItemRequest(str, hashString(str, length), length));
    
    if(shouldDoDUChainReferenceCounting(this))
      increase(globalIndexedStringRepository->dynamicItemFromIndexSimple(m_index)->refCount);*/
  }
}

IndexedString::IndexedString( const QByteArray& str) {
  unsigned int length = str.length();
  if(!length)
    m_index = 0;
  else if(length == 1)
    m_index = 0xffff0000 | str[0];
  else {
    m_index = getIndex(QString::fromUtf8(str));
    /*QMutexLocker lock(globalIndexedStringRepository->mutex());
    m_index = globalIndexedStringRepository->index(IndexedStringRepositoryItemRequest(str, hashString(str, length), length));
    
    if(shouldDoDUChainReferenceCounting(this))
      increase(globalIndexedStringRepository->dynamicItemFromIndexSimple(m_index)->refCount);*/
  }
}

IndexedString::~IndexedString() {
  /*if(m_index && (m_index & 0xffff0000) != 0xffff0000) {
    if(shouldDoDUChainReferenceCounting(this)) {
      QMutexLocker lock(globalIndexedStringRepository->mutex());
    
      decrease(globalIndexedStringRepository->dynamicItemFromIndexSimple(m_index)->refCount);
    }
  }*/
}

IndexedString::IndexedString( const IndexedString& rhs ) : m_index(rhs.m_index) {
  /*if(m_index && (m_index & 0xffff0000) != 0xffff0000) {
    if(shouldDoDUChainReferenceCounting(this)) {
      QMutexLocker lock(globalIndexedStringRepository->mutex());
      increase(globalIndexedStringRepository->dynamicItemFromIndexSimple(m_index)->refCount);
    }
  }*/
}

IndexedString& IndexedString::operator=(const IndexedString& rhs) {
  if(m_index == rhs.m_index)
    return *this;
  /*if(m_index && (m_index & 0xffff0000) != 0xffff0000) {
    
    if(shouldDoDUChainReferenceCounting(this)) {
      QMutexLocker lock(globalIndexedStringRepository->mutex());
      decrease(globalIndexedStringRepository->dynamicItemFromIndexSimple(m_index)->refCount);
    }
  }*/
  
  m_index = rhs.m_index;
  
  /*if(m_index && (m_index & 0xffff0000) != 0xffff0000) {
    if(shouldDoDUChainReferenceCounting(this)) {
      QMutexLocker lock(globalIndexedStringRepository->mutex());
      increase(globalIndexedStringRepository->dynamicItemFromIndexSimple(m_index)->refCount);
    }
  }*/
  
  return *this;
}


QUrl IndexedString::toUrl() const {
  QUrl url( str() );
  return url;
}

QString IndexedString::str() const {
  if(!m_index)
    return QString();
  else if((m_index & 0xffff0000) == 0xffff0000)
    return QString(QChar((char)m_index & 0xff));
  else
    return strings()->at(m_index); /*stringFromItem(globalIndexedStringRepository->itemFromIndex(m_index));*/
}

int IndexedString::length() const {
  if(!m_index)
    return 0;
  else if((m_index & 0xffff0000) == 0xffff0000)
    return 1;
  else
    return strings()->at(m_index).length(); /*globalIndexedStringRepository->itemFromIndex(m_index)->length;*/
}

QByteArray IndexedString::byteArray() const {
  if(!m_index)
    return QByteArray();
  else if((m_index & 0xffff0000) == 0xffff0000)
    return QString(QChar((char)m_index & 0xff)).toUtf8();
  else
    return strings()->at(m_index).toUtf8(); /*arrayFromItem(globalIndexedStringRepository->itemFromIndex(m_index));*/
}

unsigned int IndexedString::hashString(const char* str, unsigned short length) {
  RunningHash running;
  for(int a = length-1; a >= 0; --a) {
    running.append(*str);
    ++str;
  }
  return running.hash;
}
