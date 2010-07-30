=begin
**
** Copyright (C) 2004-2005 Trolltech AS. All rights reserved.
**
** This file is part of the example classes of the Qt Toolkit.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** this file.  Please review the following information to ensure GNU
** General Public Licensing requirements will be met:
** http://www.trolltech.com/products/qt/opensource.html
**
** If you are unsure which license is appropriate for your use, please
** review the following information:
** http://www.trolltech.com/products/qt/licensing.html or contact the
** sales department at sales@trolltech.com.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**

** Translated to QtRuby by Richard Dale
=end
	
class RenderArea < Qt::Widget
	
	NoTransformation = 0
	Translate = 1
	Rotate = 2
	Scale = 3
	
	def initialize(parent = nil)
	    super(parent)
	    newFont = font()
	    newFont.pixelSize = 12
	    setFont(newFont)
	
	    fontMetrics = Qt::FontMetrics.new(newFont)
	    @xBoundingRect = fontMetrics.boundingRect(tr("x"))
	    @yBoundingRect = fontMetrics.boundingRect(tr("y"))
		@operations = []
		@shape = Qt::PainterPath.new
	end
	
	def operations=(operations)
	    @operations = Array.new(operations)
	    update()
	end
	
	def shape=(shape)
	    @shape = shape
	    update()
	end
	
	def minimumSizeHint()
	    return Qt::Size.new(50, 50)
	end
	
	def sizeHint()
	    return Qt::Size.new(232, 232)
	end
	
	def paintEvent(event)
	    painter = Qt::Painter.new(self)
	    painter.renderHint = Qt::Painter::Antialiasing
	    painter.fillRect(event.rect(), Qt::Brush.new(Qt::white))
	
	    painter.translate(66, 66)
	
	    painter.save()
	    transformPainter(painter)
	    drawShape(painter)
	    painter.restore()
	
	    drawOutline(painter)
	
	    painter.save()
	    transformPainter(painter)
	    drawCoordinates(painter)
	    painter.restore()
		painter.end
	end
	
	def drawCoordinates(painter)
	    painter.pen = Qt::Pen.new(Qt::Color.new(Qt::red))
	
	    painter.drawLine(0, 0, 50, 0)
	    painter.drawLine(48, -2, 50, 0)
	    painter.drawLine(48, 2, 50, 0)
	    painter.drawText(60 - @xBoundingRect.width() / 2,
	                     0 + @xBoundingRect.height() / 2, tr("x"))
	
	    painter.drawLine(0, 0, 0, 50)
	    painter.drawLine(-2, 48, 0, 50)
	    painter.drawLine(2, 48, 0, 50)
	    painter.drawText(0 - @yBoundingRect.width() / 2,
	                     60 + @yBoundingRect.height() / 2, tr("y"))
	end
	
	def drawOutline(painter)
	    painter.pen = Qt::Pen.new(Qt::Color.new(Qt::darkGreen))
	    painter.pen = Qt::Pen.new(Qt::DashLine)
	    painter.brush = Qt::NoBrush
	    painter.drawRect(0, 0, 100, 100)
	end
	
	def drawShape(painter)
	    painter.fillPath(@shape, Qt::Brush.new(Qt::blue))
	end
	
	def transformPainter(painter)
		(0...@operations.length).each do |i|
	        case @operations[i]
	        when Translate:
	            painter.translate(50, 50)
	        when Scale:
	            painter.scale(0.75, 0.75)
	        when Rotate:
	            painter.rotate(60)
	        when NoTransformation:
	        else
	            
	        end
	    end
	end
end
