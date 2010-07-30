require 'Qt'

class DigitalClock < Qt::LCDNumber

	slots 'showTime()'

	# Constructs a DigitalClock widget
	def initialize(parent = nil)
		super(parent)
		setSegmentStyle(Filled)

		@timer = Qt::Timer.new(self)
		connect(@timer, SIGNAL('timeout()'), self, SLOT('showTime()'))
		@timer.start(1000)

		showTime()

		setWindowTitle(tr("Digital Clock"))
		resize(150, 60)
	end

	def showTime()
		time = Qt::Time.currentTime
		text = time.toString("hh:mm")
		if time.second % 2 == 0
			text[2] = ' '
		end
		display(text)
	end
end
