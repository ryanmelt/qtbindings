#!/usr/bin/ruby -W
require "Qt"

app = Qt::Application.new(ARGV)

hello = Qt::PushButton.new('Hello World!')
hello.resize(100, 30)
hello.show()

# This code hangs the application because it is trying to access the GUI
# (QT code) outside of the main thread
#Thread.new { sleep 2; hello.resize(200,50) }

# This code executes because it puts the GUI code inside
# Qt.execute_in_main_thread
Qt.execute_in_main_thread { sleep 2; hello.resize(200,50) }

app.exec()

