#!/usr/bin/ruby
=begin
**
** Copyright (C) 2004-2005 Trolltech AS. All rights reserved.
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

def method1()
    qDebug("Method 1:")
    
    reply = Qt::DBusConnection.sessionBus.interface.registeredServiceNames
    if !reply.valid?
            qDebug("Error:" + reply.error.message)
            exit 1
    end
    reply.value.each {|name| qDebug(name)}
end
    
def method2()
    qDebug("Method 2:")
    
    bus = Qt::DBusConnection.sessionBus
    dbus_iface = Qt::DBusInterface.new("org.freedesktop.DBus", "/org/freedesktop/DBus", 
                                       "org.freedesktop.DBus", bus)
        
    qDebug(dbus_iface.call("ListNames").arguments[0].value.inspect)
end
    
def method3()
    qDebug("Method 3:")
    qDebug(Qt::DBusConnection.sessionBus.interface.registeredServiceNames.value.inspect)
end
    
app = Qt::CoreApplication.new(ARGV)
    
if !Qt::DBusConnection.sessionBus.connected?
    $stderr.puts("Cannot connect to the D-BUS session bus.\n" \
                    "To start it, run:\n" \
                    "\teval `dbus-launch --auto-syntax`\n")
    exit 1
end
    
method1()
method2()
method3()

exit 0

