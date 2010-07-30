=begin
**
** Copyright (C) 2005-2005 Trolltech AS. All rights reserved.
**
** This file is part of the example classes of the Qt Toolkit.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** self file.  Please review the following information to ensure GNU
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

class CharacterWidget < Qt::Widget

    slots 'updateFont(const QString&)', 'updateStyle(const QString&)'
    signals 'characterSelected(const QString&)'

    def initialize(parent = nil)
        super(parent)
        @lastKey = -1
        @displayFont = Qt::Font.new
        setMouseTracking(true)
    end

    def updateFont(fontFamily)
        @displayFont.family = fontFamily
        @displayFont.pixelSize = 16
        update()
    end

    def updateStyle(fontStyle)
        fontDatabase = Qt::FontDatabase.new
        @displayFont = fontDatabase.font(@displayFont.family(), fontStyle, 12)
        @displayFont.pixelSize = 16
        update()
    end

    def sizeHint()
        return Qt::Size.new(32*24, (65536/32)*24)
    end

    def mouseMoveEvent(event)
        widgetPosition = mapFromGlobal(event.globalPos())
        key = (widgetPosition.y()/24)*32 + widgetPosition.x()/24
        Qt::ToolTip.showText(event.globalPos(), key.to_s, self)
    end

    def mousePressEvent(event)
        if event.button() == Qt::LeftButton
            @lastKey = (event.y()/24)*32 + event.x()/24
            if Qt::Char.new(@lastKey).category() != Qt::Char::NoCategory
                emit characterSelected(Qt::Char.new(@lastKey).to_s)
            end
            update()
        else
            super
        end
    end

    def paintEvent(event)
        painter = Qt::Painter.new(self)
        painter.fillRect(event.rect(), Qt::Brush.new(Qt::white))
        painter.font = @displayFont

        redrawRect = event.rect()
        beginRow = redrawRect.top()/24
        endRow = redrawRect.bottom()/24
        beginColumn = redrawRect.left()/24
        endColumn = redrawRect.right()/24

        painter.pen = Qt::Color.new(Qt::gray)
        (beginRow..endRow).each do |row|
            (beginColumn..endColumn).each do |column|
                painter.drawRect(column*24, row*24, 24, 24)
            end
        end

        fontMetrics = Qt::FontMetrics.new(@displayFont)
        painter.pen = Qt::Color.new(Qt::black)
        (beginRow..endRow).each do |row|
            (beginColumn..endColumn).each do |column|

                key = row*32 + column
                painter.setClipRect(column*24, row*24, 24, 24)

                if key == @lastKey
                    painter.fillRect(column*24, row*24, 24, 24, Qt::Brush.new(Qt::red))
                end

                painter.drawText(   column*24 + 12 - fontMetrics.width(Qt::Char.new(key))/2,
                                    row*24 + 4 + fontMetrics.ascent(),
                                    Qt::Char.new(key).to_s )
            end
        end
        painter.end
    end
end