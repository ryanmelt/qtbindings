#!/usr/bin/ruby

module QtWebKit
    module Internal
        def self.init_all_classes
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
