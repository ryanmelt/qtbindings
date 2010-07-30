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


# In the original C++ example the Mouse class inherited from both
# QObject and QGraphicsItem. As that isn't possible in Ruby, use
# a helper class 'MouseTimer' to periodically invoke the 
# Mouse.timerEvent() method.
class MouseTimer < Qt::Object
    def initialize(mouse)
        super(nil)
        @mouse = mouse
    end

    def timerEvent(event)
        @mouse.timerEvent(event)
    end
end

class Mouse < Qt::GraphicsItem
    TwoPi = 2.0 * Math::PI
    
    def self.normalizeAngle(angle)
        while angle < 0 do
            angle += TwoPi
        end
        while angle > TwoPi do
            angle -= TwoPi
        end
        return angle
    end
    
    def initialize()
        super(nil)
        @angle = 0.0
        @speed = 0.0
        @mouseEyeDirection = 0.0
        @color = Qt::Color.new(rand(256), rand(256), rand(256))
        rotate(rand(360 * 16))
        adjust = 0.5
        @boundingRect = Qt::RectF.new(-20 - adjust, -22 - adjust,
                      40 + adjust, 83 + adjust)
        @timer = MouseTimer.new(self)
        @timer.startTimer(1000 / 33)
    end
    
    def boundingRect
        return @boundingRect
    end
    
    def shape
        path = Qt::PainterPath.new
        path.addRect(-10, -20, 20, 40)
        return path
    end
    
    def paint(painter, arg, widget)
        # Body
        painter.brush = Qt::Brush.new(@color)
        painter.drawEllipse(-10, -20, 20, 40)
    
        # Eyes
        painter.brush = Qt::Brush.new(Qt::white)
        painter.drawEllipse(-10, -17, 8, 8)
        painter.drawEllipse(2, -17, 8, 8)
    
        # Nose
        painter.brush = Qt::Brush.new(Qt::black)
        painter.drawEllipse(Qt::RectF.new(-2, -22, 4, 4))
    
        # Pupils
        painter.drawEllipse(Qt::RectF.new(-8.0 + @mouseEyeDirection, -17, 4, 4))
        painter.drawEllipse(Qt::RectF.new(4.0 + @mouseEyeDirection, -17, 4, 4))
    
        # Ears
        painter.brush = Qt::Brush.new(scene.collidingItems(self).empty? ? Qt::darkYellow : Qt::red)
        painter.drawEllipse(-17, -12, 16, 16)
        painter.drawEllipse(1, -12, 16, 16)
    
        # Tail
        path = Qt::PainterPath.new(Qt::PointF.new(0, 20))
        path.cubicTo(-5, 22, -5, 22, 0, 25)
        path.cubicTo(5, 27, 5, 32, 0, 30)
        path.cubicTo(-5, 32, -5, 42, 0, 35)
        painter.brush = Qt::NoBrush
        painter.drawPath(path)
    end
    
    def timerEvent(event)
        # Don't move too far away
        lineToCenter = Qt::LineF.new(Qt::PointF.new(0, 0), mapFromScene(0, 0))
        if lineToCenter.length() > 150
            angleToCenter = Math.acos(lineToCenter.dx / lineToCenter.length)
            if lineToCenter.dy < 0
                angleToCenter = TwoPi - angleToCenter
            end
            angleToCenter = Mouse.normalizeAngle((Math::PI - angleToCenter) + Math::PI / 2)
    
            if angleToCenter < Math::PI && angleToCenter > Math::PI / 4
                # Rotate left
                @angle += (@angle < -Math::PI / 2) ? 0.25 : -0.25
            elsif angleToCenter >= Math::PI && angleToCenter < (Math::PI + Math::PI / 2 + Math::PI / 4)
                # Rotate right
                @angle += (@angle < Math::PI / 2) ? 0.25 : -0.25
            end
        elsif Math.sin(@angle) < 0
            @angle += 0.25
        elsif Math.sin(@angle) > 0
            @angle -= 0.25
        end
    
        # Try not to crash with any other mice
        dangerMice = scene.items(Qt::PolygonF.new([mapToScene(0, 0),
                                   mapToScene(-30, -50),
                                   mapToScene(30, -50)]))
        dangerMice.each do |item|
            if item == self
                next
            end
            
            lineToMouse = Qt::LineF.new(Qt::PointF.new(0, 0), mapFromItem(item, 0, 0))
            angleToMouse = Math.acos(lineToMouse.dx / lineToMouse.length)
            if lineToMouse.dy < 0
                angleToMouse = TwoPi - angleToMouse
            end
            angleToMouse = Mouse.normalizeAngle((Math::PI - angleToMouse) + Math::PI / 2)
    
            if angleToMouse >= 0 && angleToMouse < Math::PI / 2
                # Rotate right
                @angle += 0.5
            elsif angleToMouse <= TwoPi && angleToMouse > (TwoPi - Math::PI / 2)
                # Rotate left
                @angle -= 0.5
            end
        end
    
        # Add some random movement
        if dangerMice.size > 1 && rand(10) == 0
            if rand(1) == 1
                @angle += rand(100) / 500.0
            else
                @angle -= rand(100) / 500.0
            end
        end
    
        @speed += (-50 + rand(100)) / 100.0
    
        dx = Math.sin(@angle) * 10
        @mouseEyeDirection = ((dx / 5).abs < 1) ? 0 : dx / 5
    
        rotate(dx)
        setPos(mapToParent(0, -(3 + Math.sin(@speed) * 3)))
    end
end
