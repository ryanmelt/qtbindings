#!/usr/bin/env ruby
$VERBOSE = true; $:.unshift File.dirname($0)

require 'Qt'
require './lcdrange.rb'
require './cannon.rb'

class MyWidget < Qt::Widget
    def initialize(parent = nil)
        super
        quit = Qt::PushButton.new('Quit')
        quit.setFont(Qt::Font.new('Times', 18, Qt::Font::Bold))
    
        connect(quit, SIGNAL('clicked()'), $qApp, SLOT('quit()'))
    
        angle = LCDRange.new( self )
        angle.range = 5..70
        
        force  = LCDRange.new( self )
        force.range = 10..50
        
        cannonField = CannonField.new( self )

        connect( angle, SIGNAL('valueChanged(int)'),
                cannonField, SLOT('setAngle(int)') )
        connect( cannonField, SIGNAL('angleChanged(int)'),
                angle, SLOT('setValue(int)') )

        connect( force, SIGNAL('valueChanged(int)'),
                cannonField, SLOT('setForce(int)') )
        connect( cannonField, SIGNAL('forceChanged(int)'),
                force, SLOT('setValue(int)') )
        
        leftLayout = Qt::VBoxLayout.new()
        leftLayout.addWidget( angle )
        leftLayout.addWidget( force )

        gridLayout = Qt::GridLayout.new
        gridLayout.addWidget( quit, 0, 0 )
        gridLayout.addLayout(leftLayout, 1, 0)
        gridLayout.addWidget( cannonField, 1, 1, 2, 1 )
        gridLayout.setColumnStretch( 1, 10 )
		setLayout(gridLayout)
    
        angle.setValue( 60 )
        force.setValue( 25 )
        angle.setFocus()
    end
end    

app = Qt::Application.new(ARGV)
widget = MyWidget.new
widget.setGeometry( 100, 100, 500, 355 )
widget.show
app.exec
