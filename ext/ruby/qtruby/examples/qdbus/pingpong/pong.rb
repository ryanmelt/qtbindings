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
require 'ping-common.rb'

class Pong < Qt::Object
	slots 'QString ping(const QString&)'
	
	def ping(arg)
	    Qt::MetaObject.invokeMethod(Qt::CoreApplication.instance(), "quit")
	    return 'ping("' + arg +'") got called'
	end
end
	
app = Qt::CoreApplication.new(ARGV)
	
if !Qt::DBusConnection::sessionBus.connected?
	$stderr.puts("Cannot connect to the D-BUS session bus.\n" \
	                "To start it, run:\n" \
	                "\teval `dbus-launch --auto-syntax`\n")
	exit(1)
end
	
if !Qt::DBusConnection.sessionBus.registerService(SERVICE_NAME)
	$stderr.puts("%s\n" %  Qt::DBusConnection.sessionBus.lastError.message)
	exit(1)
end
	
pong = Pong.new
Qt::DBusConnection.sessionBus.registerObject("/", pong, Qt::DBusConnection::ExportAllSlots)
	    
app.exec()
