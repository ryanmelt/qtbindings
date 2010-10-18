=begin
**
** Copyright (C) 2004-2006 Trolltech AS. All rights reserved.
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
	
require './svgview.rb'

class SvgWindow < Qt::ScrollArea

    Native = 0
    OpenGL = 1
    Image = 2
	
	def initialize()
	    super()
	    view = Qt::Widget.new(self)
        @mousePressPos = Qt::Point.new
        @scrollBarValuesOnMousePress = Qt::Point.new
	    @renderer = Native
	    setWidget(view)
	end
	
	def openFile(file)
	    @currentPath = file
	    self.renderer = @renderer
	end
	
	def renderer=(type = Native)
	    @renderer = type
	
	    if @renderer == OpenGL
	        view = SvgGLView.new(@currentPath, self)
	    elsif @renderer == Image
	        view = SvgRasterView.new(@currentPath, self)
	    else
	        view = SvgNativeView.new(@currentPath, self)
        end
	
	    setWidget(view)
	    view.show()
	end
	
	def mousePressEvent(event)
	    @mousePressPos = event.pos
	    @scrollBarValuesOnMousePress.x = horizontalScrollBar.value
	    @scrollBarValuesOnMousePress.y = verticalScrollBar.value
	    event.accept
	end
	
	def mouseMoveEvent(event)
	    if @mousePressPos.null?
	        event.ignore
	        return
	    end
	
	    horizontalScrollBar.value = @scrollBarValuesOnMousePress.x - event.pos.x + @mousePressPos.x
	    verticalScrollBar.value = @scrollBarValuesOnMousePress.y - event.pos.y + @mousePressPos.y
	    horizontalScrollBar.update
	    verticalScrollBar.update
	    event.accept
	end
	
	def mouseReleaseEvent(event)
	    @mousePressPos = Qt::Point.new
	    event.accept
	end
end
