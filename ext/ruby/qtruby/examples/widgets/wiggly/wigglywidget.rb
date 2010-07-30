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

class WigglyWidget < Qt::Widget

    slots 'setText(const QString&)'

    def initialize(parent = nil)
        super(parent)
        setBackgroundRole(Qt::Palette::Midlight)
    
        newFont = font()
        newFont.pointSize += 20
        setFont(newFont)
    
        @step = 0
        @timer = Qt::BasicTimer.new
        @timer.start(60, self)
    end

    def setText(newText)
        @text = newText
    end

    def paintEvent(event)
        sineTable = [   0, 38, 71, 92, 100, 92, 71, 38,
                        0, -38, -71, -92, -100, -92, -71, -38 ]

        metrics = Qt::FontMetrics.new(font())
        x = (width() - metrics.width(@text)) / 2
        y = (height() + metrics.ascent() - metrics.descent()) / 2
        color = Qt::Color.new
    
        painter = Qt::Painter.new(self)
        (0...@text.size).each do |i|
            index = (@step + i) % 16
            color.setHsv((15 - index) * 16, 255, 191)
            painter.pen = color
            painter.drawText(x, y - ((sineTable[index] * metrics.height()) / 400),
                            @text[i, 1])
            x += metrics.width(@text[i, 1])
        end
        painter.end
    end

    def timerEvent(event)
        if event.timerId == @timer.timerId
            @step += 1
            update()
        else
            super(event)
        end
    end
end