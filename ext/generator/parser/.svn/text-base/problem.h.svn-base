#ifndef PROBLEM_H
#define PROBLEM_H

#include "cppparser_export.h"
#include "simplecursor.h"

struct CPPPARSER_EXPORT Problem {
    enum Source {
        Source_Preprocessor,
        Source_Lexer,
        Source_Parser
    };
    
    Source source;
    QString description;
    QString explanation;
    QString file;
    SimpleCursor position;
};

#endif
