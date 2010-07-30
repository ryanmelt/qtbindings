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
		
require 'xbelgenerator.rb'

class XbelHandler < Qt::XmlDefaultHandler
	
	def initialize(treeWidget)
	    super()
		@treeWidget = treeWidget
	    @item = nil
	    @metXbelTag = false
		@currentText = ""
	
	    style = @treeWidget.style()
	
		@folderIcon = Qt::Icon.new
	    @folderIcon.addPixmap(style.standardPixmap(Qt::Style::SP_DirClosedIcon),
	                         Qt::Icon::Normal, Qt::Icon::Off)
	    @folderIcon.addPixmap(style.standardPixmap(Qt::Style::SP_DirOpenIcon),
	                         Qt::Icon::Normal, Qt::Icon::On)
		@bookmarkIcon = Qt::Icon.new
	    @bookmarkIcon.addPixmap(style.standardPixmap(Qt::Style::SP_FileIcon))
	end
	
	def startElement(namespaceURI, localName, qName, attributes)
	    if !@metXbelTag && qName != "xbel"
	        @errorStr = Qt::Object.tr("The file is not an XBEL file.")
	        return false
	    end
	
	    if qName == "xbel"
	        version = attributes.value("version")
	        if !version.empty? && version != "1.0"
	            @errorStr = Qt::Object.tr("The file is not an XBEL version 1.0 file.")
	            return false
	        end
	        @metXbelTag = true
	    elsif qName == "folder"
	        @item = createChildItem(qName)
	        @item.flags = @item.flags | Qt::ItemIsEditable.to_i
	        @item.setIcon(0, @folderIcon)
	        @item.setText(0, Qt::Object.tr("Folder"))
	        folded = (attributes.value("folded") != "no")
	        @treeWidget.setItemExpanded(@item, !folded)
	    elsif qName == "bookmark"
	        @item = createChildItem(qName)
	        @item.flags = @item.flags | Qt::ItemIsEditable.to_i
	        @item.setIcon(0, @bookmarkIcon)
	        @item.setText(0, Qt::Object.tr("Unknown title"))
	        @item.setText(1, attributes.value("href"))
	    elsif qName == "separator"
	        @item = createChildItem(qName)
	        @item.flags = @item.flags & ~Qt::ItemIsSelectable.to_i
#	        @item.setText(0, Qt::String(30, 0xB7))
	        @item.setText(0, "..............................")
	    end
	
		@currentText = ""
	    return true
	end
	
	def endElement(namespaceURI, localName, qName)
	    if qName == "title"
	        if !@item.nil?
	            @item.setText(0, @currentText)
			end
	    elsif qName == "folder" || qName == "bookmark" ||
	               qName == "separator"
	        @item = @item.parent()
	    end
	    return true
	end
	
	def characters(str)
	    @currentText += str
	    return true
	end
	
	def fatalError(exception)
	    Qt::MessageBox.information(@treeWidget.window(), Qt::Object.tr("SAX Bookmarks"),
	                             Qt::Object::tr("Parse error at line %s, column %s:\n%s" %
	                             [exception.lineNumber, exception.columnNumber,exception.message]))
	    return false
	end
	
	def errorString()
	    return @errorStr
	end
	
	def createChildItem(tagName)
	    if !@item.nil?
	        childItem = Qt::TreeWidgetItem.new(@item, Qt::TreeWidgetItem::Type)
	    else
	        childItem = Qt::TreeWidgetItem.new(@treeWidget)
	    end
	    childItem.setData(0, Qt::UserRole, Qt::Variant.new(tagName))
	    return childItem
	end
end
