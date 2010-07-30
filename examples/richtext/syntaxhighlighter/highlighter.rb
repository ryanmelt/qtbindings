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
	
	
class Highlighter < Qt::Object
	
	slots	'highlight(int, int, int)'
	
	def initialize(parent = nil)
	    super(parent)
		@mappings = {}
	end
	
	def addToDocument(doc)
	    connect(doc, SIGNAL('contentsChange(int, int, int)'),
	            self, SLOT('highlight(int, int, int)'))
	end
	
	def addMapping(pattern, format)
	    @mappings[pattern] = format
	end
	
	def highlight(position, removed, added)
	    doc = sender()
	
	    block = doc.findBlock(position)
	    if !block.valid?
	        return
		end
	
	    if added > removed
	        endBlock = doc.findBlock(position + added)
	    else
	        endBlock = block
		end

	    while block.valid? and !(endBlock < block) do
	        highlightBlock(block)
	        block = block.next
	    end
	end
	
	def highlightBlock(block)
	    layout = block.layout
	    text = block.text
		if text.nil?
			return
		end

	    overrides = []
		@mappings.each do |pattern, value|
	        expression = Regexp.new(pattern)
	        i = text.index(expression)
	        while !i.nil?
	            range = Qt::TextLayout::FormatRange.new
	            range.start = i
	            range.length = $&.length
	            range.format = value
	            overrides << range

	            i = text.index(expression, i + $&.length)
	        end
	    end
	
	   layout.additionalFormats = overrides
	   block.document.markContentsDirty(block.position, block.length)
	end
end
