require 'mkmf'
dir_config('smoke')
dir_config('qt')

# For Linux, BSD*, Mac OS X etc:
$LOCAL_LIBS += '-lsmokeqt -lQtCore -lQtGui -lQtNetwork -lQtOpenGL -lQtSql -lQtXml -lstdc++'

# For Windows the Qt library names end in '4':
# $LOCAL_LIBS += '-lsmokeqt -lQtCore4 -lQtGui4 -lQtNetwork4 -lQtOpenGL4 -lQtSql4 -lQtXml4 -lstdc++'

create_makefile("qtruby4")
