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

class DragWidget < Qt::Frame
	
	def initialize(parent = nil, flags = 0)
	    super(parent, flags)
	    setMinimumSize(200, 200)
	    setFrameStyle(Qt::Frame::Sunken | Qt::Frame::StyledPanel)
	    setAcceptDrops(true)
	
	    boatIcon = Qt::Label.new(self)
	    boatIcon.pixmap = Qt::Pixmap.new("images/boat.png")
	    boatIcon.move(20, 20)
	    boatIcon.show()
	    boatIcon.attribute = Qt::WA_DeleteOnClose
	
	    carIcon = Qt::Label.new(self)
	    carIcon.pixmap = Qt::Pixmap.new("images/car.png")
	    carIcon.move(120, 20)
	    carIcon.show()
	    carIcon.attribute = Qt::WA_DeleteOnClose
	
	    houseIcon = Qt::Label.new(self)
	    houseIcon.pixmap = Qt::Pixmap.new("images/house.png")
	    houseIcon.move(20, 120)
	    houseIcon.show()
	    houseIcon.attribute = Qt::WA_DeleteOnClose
	end
	
	def dragEnterEvent(event)
	    if event.mimeData().hasFormat("application/x-dnditemdata")
	        if event.source() == self
	            event.dropAction = Qt::MoveAction
	            event.accept()
	        else
	            event.acceptProposedAction()
	        end
	    else
	        event.ignore()
	    end
	end
	
	def dropEvent(event)
	    if event.mimeData().hasFormat("application/x-dnditemdata")
	        itemData = event.mimeData().data("application/x-dnditemdata")
	        dataStream = Qt::DataStream.new(itemData, Qt::IODevice::ReadOnly.to_i)
	        
	        pixmap = Qt::Pixmap.new
	        offset = Qt::Point.new
	        dataStream >> pixmap >> offset
	        newIcon = Qt::Label.new(self)
	        newIcon.pixmap = pixmap
	        newIcon.move(event.pos() - offset)
	        newIcon.show()
	        newIcon.attribute = Qt::WA_DeleteOnClose
	
	        if event.source() == self
	            event.dropAction = Qt::MoveAction
	            event.accept()
	        else
	            event.acceptProposedAction()
	        end
	    else
	        event.ignore()
	    end
	end
	
	def mousePressEvent(event)
	    child = childAt(event.pos())
	    if child.nil?
	        return
		end
	
	    pixmap = child.pixmap.copy
	
	    itemData = Qt::ByteArray.new("")
	    dataStream = Qt::DataStream.new(itemData, Qt::IODevice::WriteOnly.to_i)
	    dataStream << pixmap << (event.pos() - child.pos())
	    mimeData = Qt::MimeData.new
	    mimeData.setData("application/x-dnditemdata", itemData)
	        
	    drag = Qt::Drag.new(self)
	    drag.mimeData = mimeData
	    drag.pixmap = pixmap
	    drag.hotSpot = event.pos - child.pos
	
	    tempPixmap = pixmap.copy
	    painter = Qt::Painter.new
	    painter.begin(tempPixmap)
	    painter.fillRect(pixmap.rect(), Qt::Brush.new(Qt::Color.new(127, 127, 127, 127)))
	    painter.end
	
	    child.pixmap = tempPixmap
	
	    if drag.start(Qt::CopyAction | Qt::MoveAction) == Qt::MoveAction
	        child.close()
	    else
	        child.show()
	        child.pixmap = pixmap
	    end
	end
end
