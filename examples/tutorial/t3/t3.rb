#!/usr/bin/env ruby
$VERBOSE = true; $:.unshift File.dirname($0)

require 'Qt'

app = Qt::Application.new(ARGV)

window = Qt::Widget.new
window.resize(200, 120)

quit = Qt::PushButton.new('Quit', window)
quit.font = Qt::Font.new('Times', 18, Qt::Font::Bold)
quit.setGeometry(10, 40, 180, 40)
app.connect(quit, SIGNAL('clicked()'), app, SLOT('quit()'))

window.show
app.exec
