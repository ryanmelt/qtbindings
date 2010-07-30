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
		
require 'dropsitewidget.rb'
	
class DropSiteWindow < Qt::Widget
	
	slots 'updateFormatsTable(const QMimeData *)'
	
	def initialize(parent = nil)
	    super(parent)
	    @abstractLabel = Qt::Label.new(tr("The Drop Site example accepts drops from other " \
	                                  "applications, and displays the MIME formats " \
	                                  "provided by the drag object."))
	    @abstractLabel.wordWrap = true
	    @abstractLabel.adjustSize()
	
	    @dropArea = DropArea.new
	    connect(@dropArea, SIGNAL('changed(const QMimeData*)'),
	            self, SLOT('updateFormatsTable(const QMimeData*)'))
	
	    labels = []
	    labels << tr("Format") << tr("Content")

	    @formatsTable = Qt::TableWidget.new
        @formatsTable.setColumnCount(2)
        @formatsTable.setEditTriggers(Qt::AbstractItemView::NoEditTriggers)
        @formatsTable.setHorizontalHeaderLabels(labels)
        @formatsTable.horizontalHeader.setStretchLastSection(true)

	    @quitButton = Qt::PushButton.new(tr("Quit"))
	    @clearButton = Qt::PushButton.new(tr("Clear"))

        @buttonBox = Qt::DialogButtonBox.new
        @buttonBox.addButton(@clearButton, Qt::DialogButtonBox::ActionRole)
        @buttonBox.addButton(@quitButton, Qt::DialogButtonBox::RejectRole)

	    connect(@quitButton, SIGNAL('pressed()'), self, SLOT('close()'))
	    connect(@clearButton, SIGNAL('pressed()'), @dropArea, SLOT('clear()'))

	    @layout = Qt::VBoxLayout.new do |l|
			l.addWidget(@abstractLabel)
			l.addWidget(@dropArea)
			l.addWidget(@formatsTable)
			l.addWidget(@buttonBox)
		end
	
	    setLayout(@layout)
	    setWindowTitle(tr("Drop Site"))
	    setMinimumSize(350, 500)
	end
	
	def updateFormatsTable(mimeData = nil)
	    @formatsTable.rowCount = 0
	
	    if mimeData.nil?
	        return
		end

	    formats = mimeData.formats()

	    formats.each do |format|
	        formatItem = Qt::TableWidgetItem.new(format)
	        formatItem.flags = Qt::ItemIsEnabled
	        formatItem.textAlignment = Qt::AlignTop | Qt::AlignLeft
		
	        text = ""
	        if format == "text/plain"
                text = mimeData.text.simplified
            elsif format == "text/html"
                text = mimeData.text.simplified
            elsif format == "text/uri-list"
                urlList = mimeData.urls
                urlList.each do |url|
                    text << url.path + " "
                end
	        else
	            data = mimeData.data(format)
	            hexdata = ""
                data.to_s.each_byte { |b| hexdata << ("%2.2x " % b) }
	            text << hexdata
	        end
	
	        row = @supportedFormats.rowCount()
	        @formatsTable.insertRow(row)
	        @formatsTable.setItem(row, 0, Qt::TabelWidgetItem.new(format))
	        @formatsTable.setItem(row, 1, Qt::TabelWidgetItem.new(text))
	    end
	
	    @formatsTable.resizeColumnToContents(0)
	end
end
