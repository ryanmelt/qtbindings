#!/usr/bin/env ruby
$VERBOSE = true; $:.unshift File.dirname($0)

require 'Qt'
require 'lcdrange.rb'
require 'cannon.rb'

class MyWidget < Qt::Widget
    def initialize(parent = nil)
        super
        quit = Qt::PushButton.new('Quit')
        quit.font = Qt::Font.new('Times', 18, Qt::Font::Bold)
    
        connect(quit, SIGNAL('clicked()'), $qApp, SLOT('quit()'))
    
        angle = LCDRange.new( self )
        angle.range = 5..70

        cannonField = CannonField.new( self )

        connect( angle, SIGNAL('valueChanged(int)'),
                cannonField, SLOT('setAngle(int)') )
        connect( cannonField, SIGNAL('angleChanged(int)'),
                angle, SLOT('setValue(int)') )
        gridLayout = Qt::GridLayout.new

        gridLayout.addWidget( quit, 0, 0 )
        gridLayout.addWidget( angle, 1, 0 )
        gridLayout.addWidget( cannonField, 1, 1, 2, 1 )
        gridLayout.setColumnStretch( 1, 10 )
        setLayout( gridLayout )

        angle.setValue( 60 )
        angle.setFocus()
    end
end    

a = Qt::Application.new(ARGV)

w = MyWidget.new
w.setGeometry( 100, 100, 500, 355 )
w.show
a.exec
