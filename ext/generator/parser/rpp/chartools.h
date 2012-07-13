/*
  Copyright 2008 David Nolden <david.nolden.kdevelop@art-master.de>

  Permission to use, copy, modify, distribute, and sell this software and its
  documentation for any purpose is hereby granted without fee, provided that
  the above copyright notice appear in all copies and that both that
  copyright notice and this permission notice appear in supporting
  documentation.

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
  KDEVELOP TEAM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifndef CHARTOOLS
#define CHARTOOLS
#include <QChar>

#include <cstdlib>

#include "../cppparser_export.h"

template<class T>
class QVector;
class QString;
class QByteArray;
typedef QVector<unsigned int> PreprocessedContents;

inline bool isSpace(char c) {
  return QChar(c).isSpace();
}

inline bool isLetter(char c) {
  return QChar(c).isLetter();
}

inline bool isLetterOrNumber(char c) {
  return QChar(c).isLetterOrNumber();
}

inline bool isNumber(char c) {
  return QChar(c).isNumber();
}

//Takes an index as delt with during preprocessing, and determines whether it is a fake-index that represents
//a character. If the 0xffff0000 bits are set, it is a custom character.
#define isCharacter(index) ((index & 0xffff0000) == 0xffff0000)

//Creates an index that represents the given character
#define indexFromCharacter(character) ((unsigned int)character | 0xffff0000)

//Extracts the character that is represented by the index
#define characterFromIndex(index) ((char)(index & 0xffff))

inline bool isSpace(unsigned int c) {
  return isCharacter(c) && QChar(characterFromIndex(c)).isSpace();
}

inline bool isLetter(unsigned int c) {
  return isCharacter(c) && QChar(characterFromIndex(c)).isLetter();
}

inline bool isLetterOrNumber(unsigned int c) {
  return isCharacter(c) && QChar(characterFromIndex(c)).isLetterOrNumber();
}

inline bool isNumber(unsigned int c) {
  return isCharacter(c) && QChar(characterFromIndex(c)).isNumber();
}

inline bool isNewline(unsigned int c) {
  return isCharacter(c) && characterFromIndex(c) == '\n';
}

///Opposite of convertFromByteArray
CPPPARSER_EXPORT QByteArray stringFromContents(const PreprocessedContents& contents, int offset = 0, int count = 0);

///Opposite of convertFromByteArray
CPPPARSER_EXPORT QByteArray stringFromContents(const uint* contents, int count);

///Return the line at the given line number from the contents
CPPPARSER_EXPORT QByteArray lineFromContents(std::size_t size, const uint* contents, int lineNumber);

///Returns a string that has a gap inserted between the tokens(for debugging)
CPPPARSER_EXPORT QByteArray stringFromContentsWithGaps(const PreprocessedContents& contents, int offset = 0, int count = 0);

///Converts the byte array to a vector of fake-indices containing the text
CPPPARSER_EXPORT PreprocessedContents convertFromByteArray(const QByteArray& array);

///Converts the byte array to a vector of fake-indices containing the text
///This also tokenizes the given array when possible
CPPPARSER_EXPORT PreprocessedContents tokenizeFromByteArray(const QByteArray& array);
#endif
