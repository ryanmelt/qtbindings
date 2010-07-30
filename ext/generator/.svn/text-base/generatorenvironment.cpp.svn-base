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

#include "generatorenvironment.h"

#include <rpp/pp-macro.h>
#include "options.h"

GeneratorEnvironment::GeneratorEnvironment(rpp::pp * preprocessor) : rpp::Environment(preprocessor), q_property(new rpp::pp_macro("Q_PROPERTY"))
{
    q_property->formals.append(IndexedString("text"));
    q_property->setDefinitionText("void __q_property(const char* foo = #text);");
    q_property->function_like = true;
}

GeneratorEnvironment::~GeneratorEnvironment()
{
    if (!ParserOptions::qtMode) {
        // if not in qt-mode, this won't be deleted by rpp::Environment
        delete q_property;
    }
}

void GeneratorEnvironment::setMacro(rpp::pp_macro* macro)
{
    QString macroName = macro->name.str();
    if (   macroName == "signals" || macroName == "slots" || macroName == "Q_SIGNALS" || macroName == "Q_SLOTS"
        || ParserOptions::dropMacros.contains(macroName)) {
        delete macro;
        return;
    } else if (ParserOptions::qtMode && macroName == "Q_PROPERTY") {
        delete macro;
        rpp::Environment::setMacro(q_property);
        return;
    }
    rpp::Environment::setMacro(macro);
}
