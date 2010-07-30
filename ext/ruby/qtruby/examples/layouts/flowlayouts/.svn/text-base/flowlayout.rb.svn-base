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
	
	
class FlowLayout < Qt::Layout
	
	def initialize(parent = nil, spacing = -1)
	    super(parent)
#	    setMargin(margin)
	    setSpacing(spacing)
		@itemList = []
	end
	
	def addItem(item)
	    @itemList << item
	end
	
	def count()
	    return @itemList.length()
	end
	
	def itemAt(index)
	    return @itemList[index]
	end
	
	def takeAt(index)
	    if index >= 0 && index < @itemList.length
	        return @itemList.delete_at(index)
	    else
	        return nil
		end
	end
	
	def expandingDirections()
	    return 0
	end
	
	def hasHeightForWidth()
	    return true
	end
	
	def heightForWidth(width)
	    height = doLayout(Qt::Rect.new(0, 0, width, 0), true)
	    return height
	end
	
	def setGeometry(rect)
	    super(rect)
	    doLayout(rect, false)
	end
	
	def sizeHint()
	    return minimumSize()
	end
	
	def minimumSize()
	    size = Qt::Size.new
		@itemList.each { |item| size = size.expandedTo(item.minimumSize()) }
	    size += Qt::Size.new(2*margin(), 2*margin())
	    return size
	end
	
	def doLayout(rect, testOnly)
	    x = rect.x
	    y = rect.y
	    lineHeight = 0
	
		@itemList.each do |item|
	        nextX = x + item.sizeHint().width() + spacing()
	        if nextX - spacing() > rect.right() && lineHeight > 0
	            x = rect.x()
	            y = y + lineHeight + spacing()
	            nextX = x + item.sizeHint().width() + spacing()
	            lineHeight = 0
	        end
	
	        if !testOnly
	            item.setGeometry(Qt::Rect.new(Qt::Point.new(x, y), item.sizeHint()))
			end
	
	        x = nextX
	        lineHeight = [lineHeight, item.sizeHint().height()].max
	    end
	    return y + lineHeight - rect.y()
	end
end
