=begin
/***************************************************************************
                          qttest.rb  -  QtTest ruby client lib
                             -------------------
    begin                : 29-10-2008
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

module QtTest
  module Internal
    def self.init_all_classes
      getClassList.each do |c|
        classname = Qt::Internal::normalize_classname(c)
        id = Qt::Internal::findClass(c);
        Qt::Internal::insert_pclassid(classname, id)
        Qt::Internal::cpp_names[classname] = c
        klass = Qt::Internal::isQObject(c) ? Qt::Internal::create_qobject_class(classname, Qt)  : Qt::Internal::create_qt_class(classname, Qt)
        Qt::Internal::classes[classname] = klass unless klass.nil?
      end
    end
  end
end

module Qt
  class Test < Base
      
    # This is the isValidSlot() function in testlib/qtestcase.cpp translated
    # to Ruby. Probably could be a bit shorter in Ruby..
    def self.validSlot?(sl)
      if sl.access != Qt::MetaMethod::Private || !sl.parameterTypes.empty? ||
         sl.typeName != "" || sl.methodType != Qt::MetaMethod::Slot
        return false
      end
      
      sig = sl.signature
      len = sig.length
      
      if len < 2
        return false
      end
      
      if sig[len - 2, 1] != '(' || sig[len - 1, 1] != ')'
        return false
      end
      
      if len > 7 && sig[len - 7, len] == "_data()"
        return false
      end
      
      if sig == "initTestCase()" || sig == "cleanupTestCase()" ||
         sig == "cleanup()" || sig == "init()"
        return false
      end

      return true
    end
    
    def self.current_binding
        @@current_binding
    end
    
    def self.current_binding=(b)
        @@current_binding = b
    end
    
    def self.qExec(*args)
      test_functions = []
      meta = args[0].metaObject
      className = meta.className
      for i in 0...meta.methodCount
        sl = meta.method(i)
        if Test.validSlot?(sl)
            test_functions << sl.signature.sub("()", "").to_sym
        end
      end
      
      # Trap calls to the test functions and save their binding, so that
      # the various test methods, like QVERIFY(), can evaluate the code strings
      # passed to them in the context of the test function
      trace_func = set_trace_func proc { |event, file, line, id, binding, klass|
        if event == 'call' && klass.name == className && test_functions.include?(id)
          Test.current_binding = binding
        end
      }
      
      if args.length == 2 && args[1].kind_of?(Array)
        super(args[0], args[1].length + 1, [$0] + args[1])
      else
        super(*args)
      end
      
      set_trace_func(trace_func)
    end
  end 

  class Base
    def QVERIFY(statement)
      file, line = caller(1)[0].split(':')
      if !Qt::Test.qVerify(eval(statement, Qt::Test.current_binding), statement, "", file, line.to_i)
          return eval('return', Qt::Test.current_binding)
      end
    end
    
    def QFAIL(message)
      file, line = caller(1)[0].split(':')
      Qt::Test.qFail(message, file, line.to_i)
      return eval('return', Qt::Test.current_binding)
    end
    
    def QVERIFY2(statement, description)
      file, line = caller(1)[0].split(':')
      if eval(statement, Qt::Test.current_binding)
        if !Qt::Test.qVerify(true, statement, description, file, line.to_i)
          return eval('return', Qt::Test.current_binding)
        end
      else
        if !Qt::Test.qVerify(false, statement, description, file, line.to_i)
          return eval('return', Qt::Test.current_binding)
        end
      end
    end
    
    def QCOMPARE(actual, expected)
      file, line = caller(1)[0].split(':')
      if !Qt::Test.qCompare(eval(actual, Qt::Test.current_binding), eval(expected, Qt::Test.current_binding), actual, expected, file, line.to_i)    
        return eval('return', Qt::Test.current_binding)
      end
    end
    
    def QSKIP(statement, mode)
      file, line = caller(1)[0].split(':')
      Qt::Test.qSkip(statement, mode, file, line.to_i)
      return eval('return', Qt::Test.current_binding)
    end
    
    def QEXPECT_FAIL(dataIndex, comment, mode)
      file, line = caller(1)[0].split(':')
      if !Qt::Test.qExpectFail(dataIndex, comment, mode, file, line.to_i)
        return eval('return', Qt::Test.current_binding)
      end
    end
  
    def QTEST(actual, testElement)
      file, line = caller(1)[0].split(':')
      if !Qt::Test.qTest(eval(actual, Qt::Test.current_binding), eval(testElement, Qt::Test.current_binding), actual, testElement, file, line.to_i)
        return eval('return', Qt::Test.current_binding)
      end
    end
    
    def QWARN(msg)
      Qt::Test.qWarn(msg)
    end
  end
end

