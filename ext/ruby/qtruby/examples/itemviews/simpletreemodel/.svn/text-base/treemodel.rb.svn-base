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

require 'treeitem.rb'

class TreeModel < Qt::AbstractItemModel
	
	def initialize(data, parent = nil)
	    super(parent)
	    rootData = []
	    rootData << "Title" << "Summary"
	    @rootItem = TreeItem.new(rootData)
	    setupModelData(data.to_s.split("\n"), @rootItem)
	end
	
	def columnCount(parent)
	    if parent.valid?
	        return parent.internalPointer.columnCount
	    else
	        return @rootItem.columnCount
		end
	end
	
	def data(index, role)
	    if !index.valid?
	        return Qt::Variant.new
		end
	
	    if role != Qt::DisplayRole
	        return Qt::Variant.new
		end
	
	    item = index.internalPointer
	    return item.data(index.column)
	end
	
	def flags(index)
	    if !index.valid?
	        return Qt::ItemIsEnabled
		end
	
	    return Qt::ItemIsEnabled | Qt::ItemIsSelectable
	end
	
	def headerData(section, orientation, role)
	    if orientation == Qt::Horizontal && role == Qt::DisplayRole
	        return Qt::Variant.new(@rootItem.data(section))
		end
	
	    return Qt::Variant.new
	end
	
	def index(row, column, parent)
	    if !parent.valid?
	        parentItem = @rootItem
	    else
	        parentItem = parent.internalPointer
		end
	
	    @childItem = parentItem.child(row)
	    if ! @childItem.nil?
	        return createIndex(row, column, @childItem)
	    else
	        return Qt::ModelIndex.new
		end
	end
	
	def parent(index)
	    if !index.valid?
	        return Qt::ModelIndex.new
		end
	
	    childItem = index.internalPointer
	    parentItem = childItem.parent
	
	    if parentItem == @rootItem
	        return Qt::ModelIndex.new
		end
	
	    return createIndex(parentItem.row, 0, parentItem)
	end
	
	def rowCount(parent)
	    if !parent.valid?
	        parentItem = @rootItem
	    else
	        parentItem = parent.internalPointer
		end
	
	    return parentItem.childCount
	end
	
	def setupModelData(lines, parent)
	    parents = []
	    indentations = []
	    parents << parent
	    indentations << 0
	
	    number = 0
	
	    while number < lines.length
	        position = 0
	        while position < lines[number].length
	            if lines[number][position, 1] != " "
	                break
				end
	            position += 1
	        end
	
	        lineData = lines[number][position, lines[number].length].strip
	
	        if !lineData.empty?
	            # Read the column data from the rest of the line.
	            columnStrings = lineData.split("\t").delete_if {|item| item == ""}
	            columnData = []
				for column in 0...columnStrings.length
	                columnData << columnStrings[column]
				end
	
	            if position > indentations.last
	                # The last child of the current parent is now the parent.new
	                # unless the current parent has no children.
	
	                if parents.last.childCount > 0
	                    parents << parents.last.child(parents.last.childCount - 1)
	                    indentations << position
	                end
	            else
	                while position < indentations.last && parents.length > 0
	                    parents.pop
	                    indentations.pop
	                end
	            end
	
	            # Append a item.new to the current parent's list of children.
	            parents.last.appendChild(TreeItem.new(columnData, parents.last))
	        end
	
	        number += 1
	    end
	end
end
