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
	
		
class CircleWidget < Qt::Widget
	
	slots 'nextAnimationFrame()'
	
	def initialize(parent = nil)
	    super(parent)
	    @floatBased = false
	    @antialiased = false
	    @frameNo = 0
	
	    setBackgroundRole(Qt::Palette::Base)
	    setSizePolicy(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)
	end
	
	def floatBased=(floatBased)
	    @floatBased = floatBased
	    update()
	end
	
	def antialiased=(antialiased)
	    @antialiased = antialiased
	    update()
	end
	
	def minimumSizeHint()
	    return Qt::Size.new(50, 50)
	end
	
	def sizeHint()
	    return Qt::Size.new(180, 180)
	end
	
	def nextAnimationFrame()
	    @frameNo += 1
	    update()
	end
	
	def paintEvent(event)
	    painter = Qt::Painter.new(self)
	    painter.setRenderHint(Qt::Painter::Antialiasing, @antialiased)
	    painter.translate(width() / 2, height() / 2)
	
		diameter = 0
		while diameter < 256
	        delta = ((@frameNo % 128) - diameter / 2).abs
	        alpha = 255 - (delta * delta) / 4 - diameter
	        if alpha > 0
	            painter.pen = Qt::Pen.new(Qt::Brush.new(Qt::Color.new(0, diameter / 2, 127, alpha)), 3)
	
	            if @floatBased
	                painter.drawEllipse(Qt::RectF.new(-diameter / 2.0, -diameter / 2.0,
	                                           diameter, diameter))
	            else
	                painter.drawEllipse(Qt::Rect.new(-diameter / 2, -diameter / 2,
	                                          diameter, diameter))
	            end
	        end
			diameter += 9
	    end
		painter.end
	end
end
