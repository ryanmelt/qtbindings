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
		
	
class SvgRasterView < Qt::Widget
	slots :poluteImage

	def initialize(file, parent)
	    super(parent)
        @buffer = Qt::Image.new
        @dirty = true
	    @doc = Qt::SvgRenderer.new(file, self)
	    connect(@doc, SIGNAL(:repaintNeeded),
	            self, SLOT(:poluteImage))
	end
	
	def paintEvent(event)
	    if @buffer.size() != size() || @dirty
	        @buffer = Qt::Image.new(size(), Qt::Image::Format_ARGB32_Premultiplied)
	        p = Qt::Painter.new(@buffer)
	        p.setViewport(0, 0, width(), height())
	        p.eraseRect(0, 0, width(), height())
	        @doc.render(p)
	    end
	    pt = Qt::Painter.new(self)
	    pt.drawImage(0, 0, @buffer)
        pt.end
	end
	
	def sizeHint()
	    if @doc
	        return @doc.defaultSize()
        end
	    return super()
	end
	
	def poluteImage()
	    @dirty = true
	    update()
	end
	
	def wheelEvent(e)
	    diff = 0.1
	    size = @doc.defaultSize()
	    w  = size.width()
	    h = size.height()
	    if e.delta() > 0
	        w = (width() +  width() * diff)
	        h = (height() + height() * diff)
	    else
	        w  = (width() - width() * diff)
	        h = (height() - height() * diff)
	    end
	
	    resize(w, h)
	end
end

class SvgNativeView < Qt::Widget

	def initialize(file, parent)
	    super(parent)
	    @doc = Qt::SvgRenderer.new(file, self)
	    connect(@doc, SIGNAL(:repaintNeeded),
	            self, SLOT(:update))
	end
	
	def paintEvent(event)
	    p = Qt::Painter.new(self)
	    p.setViewport(0, 0, width(), height())
	    @doc.render(p)
        p.end
	end
	
	def sizeHint()
	    if @doc
	        return @doc.defaultSize()
        end
	    return super()
	end
	
	def wheelEvent(e)
	    diff = 0.1
	    size = @doc.defaultSize()
	    w  = size.width()
	    h = size.height()
	    if e.delta() > 0
	        w = (width() + width() * diff)
	        h = (height() + height() * diff)
	    else
	        w = (width() - width() * diff)
	        h = (height() - height() * diff)
	    end
	    resize(w, h)
	end
end

class SvgGLView < Qt::GLWidget
	
	def initialize(file, parent)
	    super(Qt::GLFormat.new(Qt::GL::SampleBuffers), parent)
	    @doc = Qt::SvgRenderer.new(file, self)
	    connect(@doc, SIGNAL(:repaintNeeded),
	            self, SLOT(:update))
	end
	
	def paintEvent(event)
	    p = Qt::Painter.new(self)
	    @doc.render(p)
        p.end
	end
	
	def sizeHint()
	    if @doc
	        return @doc.defaultSize()
        end
	    return super()
	end
	
	def wheelEvent(e)
	    diff = 0.1
	    size = @doc.defaultSize()
	    w = size.width()
	    h = size.height()
	    if e.delta() > 0
	        w = (width() + width() * diff)
	        h = (height() + height() * diff)
	    else
	        w = (width() - width() * diff)
	        h = (height() - height() * diff)
	    end
	    resize(w, h)
	end
end
