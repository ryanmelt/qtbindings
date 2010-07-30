=begin
/***************************************************************************
                          qtscript.rb  -  QtScript ruby client lib
                             -------------------
    begin                : 11-07-2008
    copyright            : (C) 2008 by Richard Dale
    email                : richard.j.dale@gmail.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
=end

module QtScript
  module Internal
    def self.init_all_classes
#      Qt::Internal::add_normalize_proc(Proc.new do |classname|
#        if classname =~ /^QtScript/
#          now = classname.sub(/^QtScript?(?=[A-Z])/,'QtScript::')
#        end
#        now
#      end)
      getClassList.each do |c|
        classname = Qt::Internal::normalize_classname(c)
        id = Qt::Internal::findClass(c);
        Qt::Internal::insert_pclassid(classname, id)
        Qt::Internal::cpp_names[classname] = c
        klass = Qt::Internal::isQObject(c) ? Qt::Internal::create_qobject_class(classname, Qt) \
                                           : Qt::Internal::create_qt_class(classname, Qt)
        Qt::Internal::classes[classname] = klass unless klass.nil?
      end
    end
  end
end
