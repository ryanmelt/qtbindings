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

require 'shapeitem.rb'

class SortingBox < Qt::Widget
	
	slots	:createNewCircle,
    		:createNewSquare,
    		:createNewTriangle

	RAND_MAX = 2147483647
	
	def initialize(parent = nil)
		super(parent)
	    setAttribute(Qt::WA_StaticContents)
	    setMouseTracking(true)
	    setBackgroundRole(Qt::Palette::Base)
	
	    @itemInMotion = nil
		@shapeItems = []
		@circlePath = Qt::PainterPath.new
		@squarePath = Qt::PainterPath.new
		@trianglePath = Qt::PainterPath.new

	    @newCircleButton = createToolButton(tr("New Circle"),
	                                       Qt::Icon.new("images/circle.png"),
	                                       SLOT(:createNewCircle))
	
	    @newSquareButton = createToolButton(tr("New Square"),
	                                       Qt::Icon.new("images/square.png"),
	                                       SLOT(:createNewSquare))
	
	    @newTriangleButton = createToolButton(tr("New Triangle"),
	                                         Qt::Icon.new("images/triangle.png"),
	                                         SLOT(:createNewTriangle))
	
	    @circlePath.addEllipse(Qt::RectF.new(0.0, 0.0, 100.0, 100.0))
	    @squarePath.addRect(Qt::RectF.new(0.0, 0.0, 100.0, 100.0))
	
	    x = @trianglePath.currentPosition().x()
	    y = @trianglePath.currentPosition().y()
	    @trianglePath.moveTo(x + 120 / 2, y)
	    @trianglePath.lineTo(0, 100)
	    @trianglePath.lineTo(120, 100)
	    @trianglePath.lineTo(x + 120 / 2, y)
	
	    setWindowTitle(tr("Tooltips"))
	    resize(500, 300)
	
	    createShapeItem(@circlePath, tr("Circle"), initialItemPosition(@circlePath),
	                    initialItemColor())
	    createShapeItem(@squarePath, tr("Square"), initialItemPosition(@squarePath),
	                    initialItemColor())
	    createShapeItem(@trianglePath, tr("Triangle"),
	                    initialItemPosition(@trianglePath), initialItemColor())
	end
	
	def event(event)
	    if event.type == Qt::Event::ToolTip
	        index = itemAt(event.pos())
	        if index != -1
	            Qt::ToolTip.showText(event.globalPos(), @shapeItems[index].toolTip())
	        else
	            Qt::ToolTip.showText(event.globalPos(), "")
			end
	    end
	    super(event)
	end
	
	def resizeEvent(event)
	    margin = style().pixelMetric(Qt::Style::PM_DefaultTopLevelMargin)
	    x = width() - margin
	    y = height() - margin
	
	    y = updateButtonGeometry(@newCircleButton, x, y)
	    y = updateButtonGeometry(@newSquareButton, x, y)
	    updateButtonGeometry(@newTriangleButton, x, y)
	end
	
	def paintEvent(event)
	    painter = Qt::Painter.new(self)
		@shapeItems.each do |shapeItem|
	        painter.translate(shapeItem.position())
	        painter.brush = Qt::Brush.new(shapeItem.color)
	        painter.drawPath(shapeItem.path())
	        painter.translate(-shapeItem.position())
	    end
		painter.end
	end
	
	def mousePressEvent(event)
	    if event.button == Qt::LeftButton
	        index = itemAt(event.pos)
	        if index != -1
	            @itemInMotion = @shapeItems[index]
	            @previousPosition = event.pos
	            @shapeItems.push @shapeItems.delete_at(index)
	            update()
	        end
	    end
	end
	
	def mouseMoveEvent(event)
	    if (event.buttons & Qt::LeftButton.to_i) && !@itemInMotion.nil?
	        moveItemTo(event.pos)
		end
	end
	
	def mouseReleaseEvent(event)
	    if event.button == Qt::LeftButton && !@itemInMotion.nil?
	        moveItemTo(event.pos)
	        @itemInMotion = nil
	    end
	end
	
	def createNewCircle()
	    createShapeItem(@circlePath, tr("Circle"), randomItemPosition(),
	                    randomItemColor())
	end
	
	def createNewSquare()
	    createShapeItem(@squarePath, tr("Square"), randomItemPosition(),
	                    randomItemColor())
	end
	
	def createNewTriangle()
	    createShapeItem(@trianglePath, tr("Triangle"), randomItemPosition(),
	                    randomItemColor())
	end
	
	def itemAt(pos)
		(@shapeItems.length - 1).downto(0) do |i|
	        item = @shapeItems[i]
	        if item.path.contains(Qt::PointF.new(pos - item.position))
	            return i
			end
	    end
	    return -1
	end
	
	def moveItemTo(pos)
	    offset = pos - @previousPosition
	    @itemInMotion.position = @itemInMotion.position + offset
	    @previousPosition = pos
	    update()
	end
	
	def updateButtonGeometry(button, x, y)
	    size = button.sizeHint()
	    button.setGeometry(x - size.rwidth, y - size.rheight,
	                        size.rwidth, size.rheight)
	
	    return y - size.rheight - 
				style().pixelMetric(Qt::Style::PM_DefaultLayoutSpacing)
	end
	
	def createShapeItem(path, toolTip, pos, color)
	    shapeItem = ShapeItem.new
	    shapeItem.path = path
	    shapeItem.toolTip = toolTip
	    shapeItem.position = pos
	    shapeItem.color = color
	    @shapeItems.push(shapeItem)
	    update()
	end
	
	def createToolButton(toolTip, icon, member)
	    button = Qt::ToolButton.new(self)
	    button.toolTip = toolTip
	    button.icon = icon
	    button.setIconSize(Qt::Size.new(32, 32))
	    connect(button, SIGNAL(:clicked), self, member)
	
	    return button
	end
	
	def initialItemPosition(path)
	    y = (height() - path.controlPointRect().height()) / 2
	    if @shapeItems.length == 0
	        x = ((3 * width()) / 2 - path.controlPointRect.width) / 2
	    else
	        x = (width() / @shapeItems.size -
	             path.controlPointRect.width) / 2
		end
	    return Qt::Point.new(x, y)
	end
	
	def randomItemPosition()
	    return Qt::Point.new(rand(RAND_MAX) % (width() - 120), rand(RAND_MAX) % (height() - 120))
	end
	
	def initialItemColor()
	    return Qt::Color::fromHsv(((@shapeItems.size() + 1) * 85) % 256, 255, 190)
	end
	
	def randomItemColor()
	    return Qt::Color::fromHsv(rand(RAND_MAX) % 256, 255, 190)
	end
end
