require 'Qt'

class CannonField < Qt::Widget
  signals 'angleChanged(int)', 'forceChanged(int)'
  slots 'setAngle(int)', 'setForce(int)'

  def initialize(parent = nil)
    super
    @ang = 45
    @f = 0
    setPalette(Qt::Palette.new(Qt::Color.new(250, 250, 200)))
    setAutoFillBackground(true)
  end

  def setAngle(degrees)
    if degrees < 5
      degrees = 5
    elsif degrees > 70
      degrees = 70
    end
    if @ang == degrees
      return
    end
    @ang = degrees
    repaint()
    emit angleChanged(@ang)
  end

  def setForce(newton)
    if newton < 0
      newton = 0
    end
    if @f == newton
      return
    end
    @f = newton
    emit forceChanged(@f)
  end

  def paintEvent(e)
    if !e.rect().intersects(cannonRect())
      return
    end

    cr = cannonRect()
    pix = Qt::Pixmap.new(cr.size())
    pix.fill(self, cr.topLeft())

    painter = Qt::Painter.new(pix)
    painter.setBrush(Qt::Brush.new(Qt::blue))
    painter.setPen(Qt::NoPen)
    painter.translate(0, pix.height() - 1)
    painter.drawPie(Qt::Rect.new(-35, -35, 70, 70), 0, 90 * 16)
    painter.rotate(- @ang)
    painter.drawRect(Qt::Rect.new(33, -4, 15, 8))
    painter.end()

    painter.begin(self)
    painter.drawPixmap(cr.topLeft(), pix)
    painter.end()
  end

  def cannonRect()
    r = Qt::Rect.new(0, 0, 50, 50)
    r.moveBottomLeft(rect().bottomLeft())
    return r
  end

  def sizePolicy()
    return Qt::SizePolicy.new(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)
  end
end
