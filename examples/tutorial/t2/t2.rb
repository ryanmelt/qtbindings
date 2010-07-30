#!/usr/bin/env ruby
$VERBOSE = true; $:.unshift File.dirname($0)

require 'Qt';

a = Qt::Application.new(ARGV)

quit = Qt::PushButton.new('Quit', nil)
quit.resize(75, 30)
quit.setFont(Qt::Font.new('Times', 18, Qt::Font::Bold))

Qt::Object.connect(quit, SIGNAL('clicked()'), a, SLOT('quit()'))

quit.show
a.exec
exit
