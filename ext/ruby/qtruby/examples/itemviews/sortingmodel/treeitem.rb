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
	
#	A container for items of data supplied by the simple tree model.
	
class TreeItem

	attr_reader :childItems
	
	def initialize(data, parent = nil)
	    @parentItem = parent
	    @itemData = data
		@childItems = []
	end
	
	def appendChild(item)
	    @childItems.push(item)
	end
	
	def child(row)
	    return @childItems[row]
	end
	
	def childCount
	    return @childItems.length
	end
	
	def childRow(item)
	    return @childItems.index(item)
	end
	
	def columnCount()
	    return @itemData.length
	end
	
	def data(column)
	    return @itemData[column]
	end
	
	def parent
	    return @parentItem
	end
	
	def row
	    if ! @parentItem.nil?
	        return @parentItem.childRow(self)
		end
	
	    return 0
	end
end
