#!/usr/bin/ruby

=begin
**
** Copyright (C) 2004-2006 Trolltech AS. All rights reserved.
**
** This file is part of the example classes of the Qt Toolkit.
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

** Translated to QtRuby by Richard Dale
=end

require 'Qt'
require './ping-common.rb'

class Pong < Qt::DBusAbstractAdaptor
    q_classinfo("D-Bus Interface", "com.trolltech.QtDBus.ComplexPong.Pong")

    signals :aboutToQuit
    slots 'QDBusVariant query(QString)', :quit,
			'QString value()', 'setValue(QString)'
    
    # the property
    def value()
        return @m_value
    end
    
    def setValue(newValue)
        @m_value = newValue
    end
    
    def quit
        Qt::Timer.singleShot(0, Qt::CoreApplication.instance, SLOT(:quit))
    end
    
    def query(query)
        q = query.downcase
        if q == "hello"
            return Qt::DBusVariant.new("World")
        elsif q == "ping"
            return Qt::DBusVariant.new("Pong")
        elsif q == "the answer to life, the universe and everything"
            return Qt::DBusVariant.new(42)
        elsif !q.index("unladen swallow").nil?
            if !q.index("european").nil?
                return Qt::DBusVariant.new(11.0)
            end
            return Qt::DBusVariant.new(Qt::ByteArray.new("african or european?"))
        end
    
        return Qt::DBusVariant.new("Sorry, I don't know the answer")
    end
end

app = Qt::CoreApplication.new(ARGV)
    
obj = Qt::Object.new
pong = Pong.new(obj)
pong.connect(app, SIGNAL(:aboutToQuit), SIGNAL(:aboutToQuit))
pong.setValue("initial value")
Qt::DBusConnection.sessionBus.registerObject("/", obj)
    
if !Qt::DBusConnection.sessionBus.registerService(SERVICE_NAME)
    $stderr.puts("%s" % Qt::DBusConnection.sessionBus.lastError.message)
    exit(1)
end
        
app.exec
