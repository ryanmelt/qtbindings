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
	
		
class XbelGenerator
	IndentSize = 4
	
	def initialize(treeWidget)
	    @treeWidget = treeWidget
		@outf = Qt::TextStream.new
	end
	
	def write(device)
	    @outf.device = device
	    @outf.codec = "UTF-8"
	    @outf << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" <<
	        "<!DOCTYPE xbel>\n" <<
	        "<xbel version=\"1.0\">\n"
		
		for i in 0...@treeWidget.topLevelItemCount()
	        generateItem(@treeWidget.topLevelItem(i), 1)
		end
	
	    @outf << "</xbel>\n"
	    return true
	end
	
	def indent(depth)
	    return " " * (IndentSize * depth)
	end
	
	def escapedText(str)
	    result = str
	    result.gsub!("&", "&amp;")
	    result.gsub!("<", "&lt;")
	    result.gsub!(">", "&gt;")
	    return result
	end
	
	def escapedAttribute(str)
	    result = escapedText(str)
	    result.gsub!("\"", "&quot;")
	    return '"' + result + '"'
	end
	
	def generateItem(item, depth)
	    tagName = item.data(0, Qt::UserRole).toString()
	    if tagName == "folder"
	        folded = !@treeWidget.isItemExpanded(item)
	        @outf << indent(depth) << "<folder folded=\"" << (folded ? "yes" : "no") <<
	                             "\">\n" <<
	            indent(depth + 1) << "<title>" << escapedText(item.text(0)) <<
	                                 "</title>\n"
	
			for i in 0...item.childCount()
	            generateItem(item.child(i), depth + 1)
			end
	
	        @outf << indent(depth) << "</folder>\n"
	    elsif tagName == "bookmark"
	        @outf << indent(depth) << "<bookmark"
	        if !item.text(1).empty?
	            @outf << " href=" << escapedAttribute(item.text(1))
			end
	        @outf << ">\n" <<
	            indent(depth + 1) << "<title>" << escapedText(item.text(0)) <<
	                                 "</title>\n" <<
	            indent(depth) << "</bookmark>\n"
	    elsif tagName == "separator"
	        @outf << indent(depth) << "<separator/>\n"
	    end
	end
end
