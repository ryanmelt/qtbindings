/*
    Dump all parsed classes to stdout.
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

#include <QFileInfo>
#include <QList>

#include <type.h>

#include <iostream>

extern "C" Q_DECL_EXPORT
void generate()
{
    foreach (const QString& className, classes.keys()) {
        std::cout << qPrintable(className);
        if (classes[className].isForwardDecl())
            std::cout << " [forward declaration]";
        std::cout << std::endl;
    }
}
