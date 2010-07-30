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
	
class PiecesModel < Qt::AbstractListModel
    
	RAND_MAX = 2147483647
	
	def initialize(parent)
	    super(parent)
		@locations = []
		@pixmaps = []
	end
	
	def data(index, role)
	    if !index.valid?
	        return Qt::Variant.new
		end
	
	    if role == Qt::DecorationRole
	        return qVariantFromValue(Qt::Icon.new(@pixmaps[index.row].scaled(60, 60,
	                         Qt::KeepAspectRatio, Qt::SmoothTransformation)))
	    elsif role == Qt::UserRole
	        return qVariantFromValue(@pixmaps[index.row])
	    elsif role == Qt::UserRole + 1
	        return qVariantFromValue(@locations[index.row])
		end
	
	    return Qt::Variant.new
	end
	
	def addPiece(pixmap, location)
		if (2.0*rand(RAND_MAX)/(RAND_MAX+1.0)).to_i == 1
	        row = 0
	    else
	        row = @pixmaps.size
		end

	    beginInsertRows(Qt::ModelIndex.new, row, row)
	    @pixmaps[row] = pixmap
	    @locations[row] = location
	    endInsertRows()
	end
	
	def flags(index)
	    if index.valid?
	        return (Qt::ItemIsEnabled | Qt::ItemIsSelectable |
	                Qt::ItemIsDragEnabled | Qt::ItemIsSelectable | Qt::ItemIsDropEnabled)
	    end
	
	    return Qt::ItemIsEnabled | Qt::ItemIsDropEnabled
	end
	
	def removeRows(row, count, parent)
	    if parent.valid?
	        return false
		end
	
	    if row >= @pixmaps.size() || row + count <= 0
	        return false
		end
	
	    beginRow = [0, row].max
	    endRow = [row + count - 1, @pixmaps.size() - 1].min
	
	    beginRemoveRows(parent, beginRow, endRow)
	
	    while beginRow <= endRow
	        @pixmaps.delete(beginRow)
	        @locations.delete(beginRow)
	        beginRow += 1
	    end
	
	    endRemoveRows()
	    return true
	end
	
	def mimeTypes()
	    types = []
	    types << "image/x-puzzle-piece"
	    return types
	end
	
	def mimeData(indexes)
	    mimeData = Qt::MimeData.new
	    encodedData = Qt::ByteArray.new
	
	    stream = Qt::DataStream.new(encodedData, Qt::IODevice::WriteOnly)
	
	    indexes.each do |index|
	        if index.valid?
	            pixmap = qVariantValue(Qt::Pixmap, data(index, Qt::UserRole))
	            location = data(index, Qt::UserRole+1).toPoint
	            stream << pixmap << location
	        end
	    end
	
	    mimeData.setData("image/x-puzzle-piece", encodedData)
	    return mimeData
	end
	
	def dropMimeData(data, action, row, column, parent)
	    if !data.hasFormat("image/x-puzzle-piece")
	        return false
		end
	
	    if action == Qt::IgnoreAction
	        return true
		end
	
	    if column > 0
	        return false
		end
	
	    if !parent.valid? && row < 0
	        endRow = @pixmaps.size
	    elsif !parent.valid?
	        endRow = [row, pixmaps.size()].min
	    else
	        endRow = parent.row
		end
	
	    encodedData = data.data("image/x-puzzle-piece")
	    stream = Qt::DataStream.new(encodedData, Qt::IODevice::ReadOnly)
	
	    while !stream.atEnd
	        pixmap = Qt::Pixmap.new
	        location = Qt::Point.new
	        stream >> pixmap >> location
	
	        beginInsertRows(Qt::ModelIndex.new, endRow, endRow)
	        @pixmaps.insert(endRow, pixmap)
	        @locations.insert(endRow, location)
	        endInsertRows()
	
	        endRow += 1
	    end
	
	    return true
	end
	
	def rowCount(parent)
	    if parent.valid?
	        return 0
	    else
	        return @pixmaps.size
		end
	end
	
	def supportedDropActions
	    return Qt::CopyAction | Qt::MoveAction
	end
end
