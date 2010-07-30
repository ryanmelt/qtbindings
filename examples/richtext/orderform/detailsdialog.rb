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
	
class DetailsDialog < Qt::Dialog

	slots 'verify()'
	
	def initialize(title, parent = nil)
	    super(parent)
		@orderItems = []
		@items = []
	    nameLabel = Qt::Label.new(tr("Name:"))
	    addressLabel = Qt::Label.new(tr("Address:"))
	
	    @nameEdit = Qt::LineEdit.new
	    @addressEdit = Qt::TextEdit.new
	    @addressEdit.plainText = ""
	    @offersCheckBox = Qt::CheckBox.new(tr("Send offers:"))
	
	    setupItemsTable()
	
	    okButton = Qt::PushButton.new(tr("OK"))
	    cancelButton = Qt::PushButton.new(tr("Cancel"))
	    okButton.default = true
	
	    connect(okButton, SIGNAL('clicked()'), self, SLOT('verify()'))
	    connect(cancelButton, SIGNAL('clicked()'), self, SLOT('reject()'))
	
	    detailsLayout = Qt::GridLayout.new do |d|
			d.addWidget(nameLabel, 0, 0)
			d.addWidget(@nameEdit, 0, 1)
			d.addWidget(addressLabel, 1, 0)
			d.addWidget(@addressEdit, 1, 1)
			d.addWidget(@itemsTable, 0, 2, 2, 2)
			d.addWidget(@offersCheckBox, 2, 1, 1, 4)
		end
	
	    buttonLayout = Qt::HBoxLayout.new do |b|
			b.addStretch(1)
			b.addWidget(okButton)
			b.addWidget(cancelButton)
		end
	
	    self.layout = Qt::VBoxLayout.new do |m|
			m.addLayout(detailsLayout)
			m.addLayout(buttonLayout)
	    end
	
	    self.windowTitle = title
	end
	
	def setupItemsTable()
	    @items << tr("T-shirt") << tr("Badge") << tr("Reference book") <<
	          tr("Coffee cup")
	
	    @itemsTable = Qt::TableWidget.new(@items.length, 2)
	
		(0...@items.length).each do |row|
	        name = Qt::TableWidgetItem.new(@items[row])
	        name.flags = Qt::ItemIsEnabled | Qt::ItemIsSelectable
	        @itemsTable.setItem(row, 0, name)
	        quantity = Qt::TableWidgetItem.new("1")
	        @itemsTable.setItem(row, 1, quantity)
	    end
	end
	
	def orderItems()
	    orderList = []
	
		(0...@items.length).each do |row|
	        item = Array.new(2)
        	item[0] = @itemsTable.item(row, 0).text
        	quantity = @itemsTable.item(row, 1).data(Qt::DisplayRole).toInt
	        item[1] = [0, quantity].max
	        orderList.push(item)
	    end
	
	    return orderList
	end
	
	def senderName()
	    return @nameEdit.text
	end
	
	def senderAddress()
	    return @addressEdit.toPlainText
	end
	
	def sendOffers()
	    return @offersCheckBox.checked?
	end
	
	def verify()
	    if !@nameEdit.text.empty? && !@addressEdit.toPlainText.empty?
	        accept()
	        return
	    end
	
	    answer = Qt::MessageBox.warning(self, tr("Incomplete Form"),
	        tr("The form does not contain all the necessary information.\n" +
	           "Do you want to discard it?"),
	        Qt::MessageBox::Yes, Qt::MessageBox::No)
	
	    if answer == Qt::MessageBox::Yes
	        reject()
		end
	end
end
