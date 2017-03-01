require 'Qt'

class CannonField < Qt::Widget
  signals 'angleChanged(int)'
  slots 'setAngle(int)'

  def initialize(parent = nil)
    super
    @currentAngle = 45
    setPalette(Qt::Palette.new(Qt::Color.new(250, 250, 200)))
    setAutoFillBackground(true)
  end

  def setAngle(degrees)
    if degrees < 5
      degrees = 5
    elsif degrees > 70
      degrees = 70
    end
    if @currentAngle == degrees
      return
    end
    @currentAngle = degrees
    repaint()
    emit angleChanged(@currentAngle)
  end

  def paintEvent(event)
    painter = Qt::Painter.new(self)

    painter.setPen(Qt::NoPen)
    painter.setBrush(Qt::Brush.new(Qt::blue))

    painter.translate(0, rect().bottom())
    painter.drawPie(Qt::Rect.new(-35, -35, 70, 70), 0, 90 * 16)
    painter.rotate(- @currentAngle)
    painter.drawRect(Qt::Rect.new(33, -4, 15, 8))
    painter.end()
  end

  def sizePolicy()
    return Qt::SizePolicy.new(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)
  end
end
