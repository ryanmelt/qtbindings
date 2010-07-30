#!/usr/bin/env ruby

require 'Qt'
 
class PassiveWindow < Qt::Frame
	MARGIN = 20
	
    def initialize(message)
        super(nil, Qt::X11BypassWindowManagerHint | Qt::WindowStaysOnTopHint |
                   Qt::Tool | Qt::FramelessWindowHint)
        setFrameStyle(Qt::Frame::Box| Qt::Frame::Plain)
        setLineWidth(2)

        setMinimumWidth(100)
        layout = Qt::VBoxLayout.new(self) do |l|
            l.spacing = 11
            l.margin = 6
        end
        Qt::Label.new(message, self)

        quit=Qt::PushButton.new(tr("Close"), self)
        connect(quit, SIGNAL("clicked()"), SLOT("close()"))
	end

    def show
        super
        move(Qt::Application.desktop().width() - width() - MARGIN,
            Qt::Application.desktop().height() - height() - MARGIN)
	end
end
  	
if (Process.fork != nil)
	exit
end
app = Qt::Application.new(ARGV)
win = PassiveWindow.new(ARGV[0])
win.show
app.exec
