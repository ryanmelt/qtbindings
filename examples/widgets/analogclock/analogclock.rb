#!/usr/bin/env ruby -w

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

require 'Qt'

# an analog clock widget using an internal Qt::Timer
class AnalogClock < Qt::Widget

    def initialize(parent = nil)
        super(parent)

        @timer = Qt::Timer.new(self)
        connect(@timer, SIGNAL('timeout()'), self, SLOT('update()'))
        @timer.start(1000)

        setWindowTitle(tr("Analog Clock"))
        resize(200, 200)
    end

    def paintEvent(e)
        hourHand = Qt::Polygon.new( [   Qt::Point.new(7, 8),
                                        Qt::Point.new(-7, 8),
                                        Qt::Point.new(0, -40) ] )
        minuteHand = Qt::Polygon.new(   [   Qt::Point.new(7, 8),
                                            Qt::Point.new(-7, 8),
                                            Qt::Point.new(0, -70) ] )
        hourColor = Qt::Color.new(127, 0, 127)
        minuteColor = Qt::Color.new(0, 127, 127, 191)

        side = width() < height() ? width() : height()
        time = Qt::Time.currentTime

        painter = Qt::Painter.new(self)
        painter.renderHint = Qt::Painter::Antialiasing
        painter.translate(width() / 2, height() / 2)
        painter.scale(side / 200.0, side / 200.0)

        painter.pen = Qt::NoPen
        painter.brush = Qt::Brush.new(hourColor)

        painter.save
        painter.rotate(30.0 * ((time.hour + time.minute / 60.0)))
        painter.drawConvexPolygon(hourHand)
        painter.restore

        painter.pen = hourColor
        (0...12).each do |i|
            painter.drawLine(88, 0, 96, 0)
            painter.rotate(30.0)
        end

        painter.pen = Qt::NoPen
        painter.brush = Qt::Brush.new(minuteColor)

        painter.save
        painter.rotate(6.0 * (time.minute + time.second / 60.0))
        painter.drawConvexPolygon(minuteHand)
        painter.restore

        painter.pen = minuteColor
        (0...60).each do |j|
            if (j % 5) != 0
                painter.drawLine(92, 0, 96, 0)
            end
            painter.rotate(6.0)
        end

		painter.end
    end
end
