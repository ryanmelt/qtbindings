#!/usr/bin/env ruby
$VERBOSE = true; $:.unshift File.dirname($0)

require 'Qt'

class LCDRange < Qt::Widget
  def initialize(parent = nil)
    super
    lcd = Qt::LCDNumber.new(2)
    slider = Qt::Slider.new(Qt::Horizontal)
    slider.range = 0..99
    slider.value = 0

    lcd.connect(slider, SIGNAL('valueChanged(int)'), SLOT('display(int)'))

    layout = Qt::VBoxLayout.new
    layout.addWidget(lcd)
    layout.addWidget(slider)
    setLayout(layout)
  end
end

class MyWidget < Qt::Widget
  def initialize()
    super
    quit = Qt::PushButton.new('Quit')
    quit.setFont(Qt::Font.new('Times', 18, Qt::Font::Bold))
    connect(quit, SIGNAL('clicked()'), $qApp, SLOT('quit()'))

    grid = Qt::GridLayout.new

    for row in 0..3
      for column in 0..3
        grid.addWidget(LCDRange.new, row, column)
      end
    end

    layout = Qt::VBoxLayout.new
    layout.addWidget(quit)
    layout.addLayout(grid)
    setLayout(layout)
  end
end

app = Qt::Application.new(ARGV)
widget = MyWidget.new
widget.show
app.exec
