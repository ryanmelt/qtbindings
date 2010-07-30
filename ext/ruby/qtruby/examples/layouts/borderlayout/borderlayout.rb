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
	
	
class BorderLayout < Qt::Layout
	West = 0
	North = 1
	South = 2
	East = 3
	Center = 4
	
	MinimumSize = 0
	SizeHint = 1

	ItemWrapper = Struct.new :item, :position
	
	def initialize(parent = nil, margin = 0, spacing = -1)
		@list = []
	    super(parent)
	    setMargin(margin)
	    setSpacing(spacing)
	end
	
#	def initialize(spacing)
#	    setSpacing(spacing)
#	end
	
	def addItem(item)
	    add(item, West)
	end
	
	def addWidget(widget, position)
	    add(Qt::WidgetItem.new(widget), position)
	end
	
	def expandingDirections()
	    return Qt::Horizontal | Qt::Vertical
	end
	
	def hasHeightForWidth()
	    return false
	end
	
	def count()
	    return @list.length()
	end
	
	def itemAt(index)
	    wrapper = @list[index]
	    if !wrapper.nil?
	        return wrapper.item
	    else
	        return nil
		end
	end
	
	def minimumSize()
	    return calculateSize(MinimumSize)
	end
	
	def setGeometry(rect)
	    center = 0
	    eastWidth = 0
	    westWidth = 0
	    northHeight = 0
	    southHeight = 0
	    centerHeight = 0
	
	    super(rect)
	
		(0...@list.length).each do |i|
	        wrapper = @list[i]
	        item = wrapper.item
	        position = wrapper.position
	
	        if position == North
	            item.geometry = Qt::Rect.new(rect.x, northHeight, rect.width,
	                                    item.sizeHint.height)
	
	            northHeight += item.geometry.height + spacing()
	        elsif position == South
	            item.geometry = Qt::Rect.new(item.geometry.x,
	                                    item.geometry.y, rect.width,
	                                    item.sizeHint.height)
	
	            southHeight += item.geometry().height() + spacing()
	
	            item.geometry = Qt::Rect.new(rect.x,
	                              rect.y + rect.height - southHeight + spacing(),
	                              item.geometry.width,
	                              item.geometry.height)
	        elsif position == Center
	            center = wrapper
	        end
	    end
	
	    centerHeight = rect.height() - northHeight - southHeight
	
		(0...@list.length).each do |i|
	        wrapper = @list[i]
	        item = wrapper.item
	        position = wrapper.position
	
	        if position == West
	            item.geometry = Qt::Rect.new(rect.x + westWidth, northHeight,
	                                    item.sizeHint.width, centerHeight)
	
	            westWidth += item.geometry.width + spacing()
	        elsif position == East
	            item.geometry = Qt::Rect.new(item.geometry.x, item.geometry.y,
	                                    item.sizeHint.width, centerHeight)
	
	            eastWidth += item.geometry.width + spacing()
	
	            item.geometry = Qt::Rect.new(
	                              rect.x + rect.width - eastWidth + spacing,
	                              northHeight, item.geometry.width,
	                              item.geometry.height)
	        end
	    end
	
	    if !center.nil?
	        center.item.geometry = Qt::Rect.new(westWidth, northHeight,
	                                        rect.width - eastWidth - westWidth,
	                                        centerHeight)
		end
	end
	
	def sizeHint()
	    return calculateSize(SizeHint)
	end
	
	def takeAt(index)
	    if index >= 0 && index < @list.length()
	        layoutStruct = @list.delete_at(index)
	        return layoutStruct.item
	    end
	    return nil
	end
	
	def add(item, position)
	    @list << ItemWrapper.new(item, position)
	end
	
	def calculateSize(sizeType)
	    totalSize = Qt::Size.new
	
		(0...@list.length).each do |i|
	        wrapper = @list[i]
	        position = wrapper.position
	
	        if sizeType == MinimumSize
	            itemSize = wrapper.item.minimumSize
	        else # (sizeType == SizeHint)
	            itemSize = wrapper.item.sizeHint
			end
	
	        if position == North || position == South || position == Center
	            totalSize.height += itemSize.height
			end
	
	        if position == West || position == East || position == Center
	            totalSize.width += itemSize.width
			end
	    end
	    return totalSize
	end
end
