#!/usr/bin/env ruby
$VERBOSE = true; $:.unshift File.dirname($0)

require 'Qt'

class MyWidget < Qt::Widget

def initialize()
    super
    quit = Qt::PushButton.new('Quit')
    quit.setFont(Qt::Font.new('Times', 18, Qt::Font::Bold))
    
    connect(quit, SIGNAL('clicked()'), $qApp, SLOT('quit()'))
    
    lcd = Qt::LCDNumber.new(2)

    slider = Qt::Slider.new(Qt::Horizontal)
    slider.range = 0..99
    slider.value = 0

    connect(quit, SIGNAL('clicked()'), $qApp, SLOT('quit()'))
    connect(slider, SIGNAL('valueChanged(int)'),
            lcd, SLOT('display(int)'))

    layout = Qt::VBoxLayout.new
    layout.addWidget(quit)
    layout.addWidget(lcd)
    layout.addWidget(slider)
    setLayout(layout)
end

end

app = Qt::Application.new(ARGV)
widget = MyWidget.new
widget.show
app.exec
