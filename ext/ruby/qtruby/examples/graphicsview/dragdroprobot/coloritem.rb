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
    
class ColorItem < Qt::GraphicsItem
    @@n = 0

    def initialize
        super
        @color = Qt::Color.new(rand(256), rand(256), rand(256))
        setToolTip("Qt::Color(%d, %d, %d)\n%s" %
               [@color.red, @color.green, @color.blue,
               "Click and drag this color onto the robot!"])
        setCursor(Qt::Cursor.new(Qt::OpenHandCursor))
    end
    
    def boundingRect
        return Qt::RectF.new(-15.5, -15.5, 34, 34)
    end
    
    def paint(painter, option, widget)
        painter.pen = Qt::NoPen
        painter.brush = Qt::Brush.new(Qt::darkGray)
        painter.drawEllipse(-12, -12, 30, 30)
        painter.pen = Qt::Pen.new(Qt::Brush.new(Qt::black), 1)
        painter.brush = Qt::Brush.new(@color)
        painter.drawEllipse(-15, -15, 30, 30)
    end
    
    def mousePressEvent(event)
        if event.button != Qt::LeftButton
            event.ignore
            return
        end
    
        drag = Qt::Drag.new(event.widget)
        mime = Qt::MimeData.new
        drag.mimeData = mime
    
        @@n += 1
        if @@n > 2 && rand(3) == 0
            image = Qt::Image.new(":/images/head.png")
            mime.imageData = qVariantFromValue(image)
    
            drag.pixmap = Qt::Pixmap.fromImage(image.scaled(30, 40))
            drag.setHotSpot(Qt::Point.new(30, 40))
        else
            mime.colorData = qVariantFromValue(@color)
            mime.text = "#%2.2x%2.2x%2.2x" % [@color.red, @color.green, @color.blue]

            pixmap = Qt::Pixmap.new(34, 34)
            pixmap.fill(Qt::Color.new(Qt::transparent))
            painter = Qt::Painter.new(pixmap)
            painter.translate(15, 15)
            painter.renderHint = Qt::Painter::Antialiasing
            paint(painter, 0, 0)
            painter.end
        
            drag.pixmap = pixmap
            drag.hotSpot = Qt::Point.new(15, 20)
        end
        drag.start
    end
    
end
