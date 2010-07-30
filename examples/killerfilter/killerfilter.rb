#!/usr/bin/env ruby -w

# This is the EventFilter example from Chapter 16 of 'Programming with Qt'

require 'Qt'

class KillerFilter < Qt::Object

	def eventFilter( object, event )
		if event.type() == Qt::Event::MouseButtonPress
			if event.button() == Qt::RightButton
				object.close()
				return true
			else
				return false
			end
		else
			return false
		end
	end

end
	
a = Qt::Application.new(ARGV)
	
toplevel = Qt::Widget.new
toplevel.resize(230, 130)

killerfilter = KillerFilter.new

pb = Qt::PushButton.new(toplevel)
pb.setGeometry( 10, 10, 100, 50 )
pb.text = "pushbutton"
pb.installEventFilter(killerfilter)

le = Qt::LineEdit.new(toplevel)
le.setGeometry( 10, 70, 100, 50 )
le.text = "Line edit"
le.installEventFilter(killerfilter)

cb = Qt::CheckBox.new(toplevel)
cb.setGeometry( 120, 10, 100, 50 )
cb.text = "Check-box"
cb.installEventFilter(killerfilter)

rb = Qt::RadioButton.new(toplevel)
rb.setGeometry( 120, 70, 100, 50 )
rb.text = "Radio button"
rb.installEventFilter(killerfilter)

toplevel.show
a.exec


	
