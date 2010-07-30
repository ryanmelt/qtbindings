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
    
class RobotPart < Qt::GraphicsItem
    
    def initialize(parent)
        super(parent)
        @color = Qt::Color.new(Qt::lightGray)
        @pixmap = Qt::Pixmap.new
        @dragOver = false
        setAcceptDrops(true)
    end
    
    def dragEnterEvent(event)
        if event.mimeData.hasColor ||
            self.kind_of?(RobotHead) && event.mimeData.hasImage
            event.accepted = true
            @dragOver = true
            update()
        else
            event.accepted = false
        end
    end
    
    def dragLeaveEvent(event)
        @dragOver = false
        update()
    end
    
    def dropEvent(event)
        @dragOver = false
        if event.mimeData.hasColor
            @color = qVariantValue(Qt::Color, event.mimeData.colorData)
        elsif event.mimeData.hasImage
            @pixmap = qVariantValue(Qt::Pixmap, event.mimeData.imageData)
        end
        update()
    end
end

class RobotHead < RobotPart
    Type = Qt::GraphicsItem::UserType + 1
    
    def initialize(parent)
        super(parent)
    end
    
    def boundingRect
        return Qt::RectF.new(-15, -50, 30, 50)
    end
    
    def paint(painter, option, widget)
        if @pixmap.null?
            painter.brush = Qt::Brush.new(@dragOver ? @color.light(130) : @color)
            painter.drawRoundRect(-10, -30, 20, 30)
            painter.brush = Qt::Brush.new(Qt::white)
            painter.drawEllipse(-7, -3 - 20, 7, 7)
            painter.drawEllipse(0, -3 - 20, 7, 7)
            painter.brush = Qt::Brush.new(Qt::black)
            painter.drawEllipse(-5, -1 - 20, 2, 2)
            painter.drawEllipse(2, -1 - 20, 2, 2)
            painter.pen = Qt::Pen.new(Qt::Brush.new(Qt::black), 2)
            painter.brush = Qt::NoBrush
            painter.drawArc(-6, -2 - 20, 12, 15, 190 * 16, 160 * 16)
        else
            painter.scale(0.2272, 0.2824)
            painter.drawPixmap(Qt::PointF.new(-15 * 4.4, -50 * 3.54), @pixmap)
        end
    end
    
    def type()
        return Type
    end
end

class RobotTorso < RobotPart

    def initialize(parent)
        super(parent)
    end
    
    def boundingRect
        return Qt::RectF.new(-30, -20, 60, 60)
    end
    
    def paint(painter, option, widget)
        painter.brush = Qt::Brush.new(@dragOver ? @color.light(130) : @color)
        painter.drawRoundRect(-20, -20, 40, 60)
        painter.drawEllipse(-25, -20, 20, 20)
        painter.drawEllipse(5, -20, 20, 20)
        painter.drawEllipse(-20, 22, 20, 20)
        painter.drawEllipse(0, 22, 20, 20)
    end
end

class RobotLimb < RobotPart

    def initialize(parent)
        super(parent)
    end
    
    def boundingRect
        return Qt::RectF.new(-5, -5, 40, 10)
    end
    
    def paint(painter, option, widget)
        painter.brush = Qt::Brush.new(@dragOver ? @color.light(130) : @color)
        painter.drawRoundRect(boundingRect(), 50, 50)
        painter.drawEllipse(-5, -5, 10, 10)
    end
end

class Robot < RobotPart
    
    def initialize(view)
        super(nil)
        torsoItem = RobotTorso.new(self)
        headItem = RobotHead.new(torsoItem)
        upperLeftArmItem = RobotLimb.new(torsoItem)
        lowerLeftArmItem = RobotLimb.new(upperLeftArmItem)
        upperRightArmItem = RobotLimb.new(torsoItem)
        lowerRightArmItem = RobotLimb.new(upperRightArmItem)
        upperRightLegItem = RobotLimb.new(torsoItem)
        lowerRightLegItem = RobotLimb.new(upperRightLegItem)
        upperLeftLegItem = RobotLimb.new(torsoItem)
        lowerLeftLegItem = RobotLimb.new(upperLeftLegItem)
        
        headItem.setPos(0, -18)
        upperLeftArmItem.setPos(-15, -10)
        lowerLeftArmItem.setPos(30, 0)
        upperRightArmItem.setPos(15, -10)
        lowerRightArmItem.setPos(30, 0)
        upperRightLegItem.setPos(10, 32)
        lowerRightLegItem.setPos(30, 0)
        upperLeftLegItem.setPos(-10, 32)
        lowerLeftLegItem.setPos(30, 0)
    
        @timeLine = Qt::TimeLine.new
    
        headAnimation = Qt::GraphicsItemAnimation.new(view) do |a|
            a.item = headItem
            a.timeLine = @timeLine
            a.setRotationAt(0, 20)
            a.setRotationAt(1, -20)
            a.setScaleAt(1, 1.1, 1.1)
        end
    
        upperLeftArmAnimation = Qt::GraphicsItemAnimation.new(view) do |a|
            a.item = upperLeftArmItem
            a.timeLine = @timeLine
            a.setRotationAt(0, 190)
            a.setRotationAt(1, 180)
        end
    
        lowerLeftArmAnimation = Qt::GraphicsItemAnimation.new(view) do |a|
            a.item = lowerLeftArmItem
            a.timeLine = @timeLine
            a.setRotationAt(0, 50)
            a.setRotationAt(1, 10)
        end
        
        upperRightArmAnimation = Qt::GraphicsItemAnimation.new(view) do |a|
            a.item = upperRightArmItem
            a.timeLine = @timeLine
            a.setRotationAt(0, 300)
            a.setRotationAt(1, 310)
        end
    
        lowerRightArmAnimation = Qt::GraphicsItemAnimation.new(view) do |a|
            a.item = lowerRightArmItem
            a.timeLine = @timeLine
            a.setRotationAt(0, 0)
            a.setRotationAt(1, -70)
        end
    
        upperLeftLegAnimation = Qt::GraphicsItemAnimation.new(view) do |a|
            a.item = upperLeftLegItem
            a.timeLine = @timeLine
            a.setRotationAt(0, 150)
            a.setRotationAt(1, 80)
        end
    
        lowerLeftLegAnimation = Qt::GraphicsItemAnimation.new(view) do |a|
            a.item = lowerLeftLegItem
            a.timeLine = @timeLine
            a.setRotationAt(0, 70)
            a.setRotationAt(1, 10)
        end
    
        upperRightLegAnimation = Qt::GraphicsItemAnimation.new(view) do |a|
            a.item = upperRightLegItem
            a.timeLine = @timeLine
            a.setRotationAt(0, 40)
            a.setRotationAt(1, 120)
        end
        
        lowerRightLegAnimation = Qt::GraphicsItemAnimation.new(view) do |a|
            a.item = lowerRightLegItem
            a.timeLine = @timeLine
            a.setRotationAt(0, 10)
            a.setRotationAt(1, 50)
        end
        
        torsoAnimation = Qt::GraphicsItemAnimation.new(view) do |a|
            a.item = torsoItem
            a.timeLine = @timeLine
            a.setRotationAt(0, 5)
            a.setRotationAt(1, -20)
        end
    
        @timeLine.updateInterval = 1000 / 25
        @timeLine.curveShape = Qt::TimeLine::SineCurve
        @timeLine.loopCount = 0
        @timeLine.duration = 2000
        @timeLine.start
    end
    
    def boundingRect
        return Qt::RectF.new()
    end
    
    def paint(painter, option, widget)
    end
end
