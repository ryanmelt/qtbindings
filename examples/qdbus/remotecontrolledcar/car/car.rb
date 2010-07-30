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
    

class CarAdaptor < Qt::Object
    q_classinfo("D-Bus Interface", "com.trolltech.Examples.CarInterface")

    slots :accelerate, :decelerate, :turnLeft, :turnRight
    signals :crashed

    def initialize(car)
        super()
		@car = car
        startTimer(1000 / 33)
    end
    
    def accelerate
        @car.accelerate
    end
    
    def decelerate
        @car.decelerate
    end
    
    def turnLeft
        @car.turnLeft
    end
    
    def turnRight
        @car.turnRight
    end
    
    def timerEvent(event)
        @car.timerEvent(event)
    end
 end

# Note that as Ruby doesn't have multiple inheritance, and 'Car', can't inherit from 
# Qt::Object as well as Qt::Graphics item. So the timerEvent event handling is done
# in the CarAdaptor instance which is a Qt::Object, which calls back to the Car
# instance.
#
class Car < Qt::GraphicsItem
    def boundingRect()
        return Qt::RectF.new(-35, -81, 70, 115)
    end
    
    def initialize()
        super
        @color = Qt::Brush.new(Qt::green)
        @wheelsAngle = 0.0 
        @speed = 0.0
        setFlag(Qt::GraphicsItem::ItemIsMovable, true)
        setFlag(Qt::GraphicsItem::ItemIsFocusable, true)
    end
    
    def accelerate()
        if @speed < 10
            @speed += 1
        end
    end
    
    def decelerate()
        if @speed > -10
            @speed -= 1
        end
    end
    
    def turnLeft()
        if @wheelsAngle > -30
            @wheelsAngle -= 5
        end
    end
    
    def turnRight()
        if @wheelsAngle < 30
           @wheelsAngle += 5
        end
    end
    
    def paint(painter, option, widget)
        painter.brush = Qt::Brush.new(Qt::gray)
        painter.drawRect(-20, -58, 40, 2) # front axel
        painter.drawRect(-20, 7, 40, 2) # rear axel
    
        painter.brush = @color
        painter.drawRect(-25, -79, 50, 10) # front wing
    
        painter.drawEllipse(-25, -48, 50, 20) # side pods
        painter.drawRect(-25, -38, 50, 35) # side pods
        painter.drawRect(-5, 9, 10, 10) # back pod
    
        painter.drawEllipse(-10, -81, 20, 100) # main body
    
        painter.drawRect(-17, 19, 34, 15) # rear wing
    
        painter.brush = Qt::Brush.new(Qt::black)
        painter.drawPie(-5, -51, 10, 15, 0, 180 * 16)
        painter.drawRect(-5, -44, 10, 10) # cocpit
    
        painter.save()
        painter.translate(-20, -58)
        painter.rotate(@wheelsAngle)
        painter.drawRect(-10, -7, 10, 15) # front left
        painter.restore()
    
        painter.save()
        painter.translate(20, -58)
        painter.rotate(@wheelsAngle)
        painter.drawRect(0, -7, 10, 15) # front left
        painter.restore()
    
        painter.drawRect(-30, 0, 12, 17) # rear left
        painter.drawRect(19, 0, 12, 17)  # rear right
    end
    
    def timerEvent(event)
        axelDistance = 54
        wheelsAngleRads = (@wheelsAngle * Math::PI) / 180
        turnDistance = Math.cos(wheelsAngleRads) * axelDistance * 2
        turnRateRads = wheelsAngleRads / turnDistance  # rough estimate
        turnRate = (turnRateRads * 180) / Math::PI
        rotation = @speed * turnRate
        
        rotate(rotation)
        translate(0, -@speed)
        update()
    end
end
