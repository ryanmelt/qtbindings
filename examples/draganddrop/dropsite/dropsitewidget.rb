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
	
	
	
	
class DropArea < Qt::Label
	
	slots 'clear()'
	
	signals 'changed(const QMimeData*)'
	
	def initialize(parent = nil)
	    super(parent)
	    setMinimumSize(200, 200)
	    setFrameStyle(Qt::Frame::Sunken | Qt::Frame::StyledPanel)
	    setAlignment(Qt::AlignCenter)
	    setAcceptDrops(true)
	    setAutoFillBackground(true)
      clear()
	end
	
	def dragEnterEvent(event)
	    setText(tr("<drop content>"))
	    setBackgroundRole(Qt::Palette::Highlight)
	
	    event.acceptProposedAction()
#	    emit changed(event.mimeData())
	end
	
  def dragMoveEvent(event)
      event.acceptProposedAction()
  end

	def dropEvent(event)
	    mimeData = event.mimeData()
      if mimeData.hasText
            setText(mimeData.text())
            setTextFormat(Qt::PlainText)
	    end

	    formats = mimeData.formats()
	    formats.each do |format|
	        if format.start_with?("image/")
	            pixmap = Qt::Pixmap.new
	            pixmap.loadFromData(mimeData.data(format), format)
	            if !pixmap.nil?
	                setPixmap(pixmap)
	                break
	            end
	        end
	        #text = createPlainText(mimeData.data(format), format)
	        text = mimeData.data(format).to_s
	        if !text.empty?
	            setText(text)
	            break
	        else
	            setText(tr("No supported format"))
	        end
	    end
	
	    setBackgroundRole(Qt::Palette::Dark)
	    event.acceptProposedAction()
	end
	
	def dragLeaveEvent(event)
	    clear()
	    event.accept()
	end
	
	def clear()
	    setText(tr("<drop content>"))
	    setBackgroundRole(Qt::Palette::Dark)
	
	    emit changed(nil)
	end
end
