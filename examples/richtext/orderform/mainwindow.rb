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
	
require './detailsdialog.rb'

class MainWindow < Qt::MainWindow
	
	slots   'openDialog()',
    		'printFile()'
	
	def initialize(parent = nil)
		super
	    fileMenu = Qt::Menu.new(tr("&File"), self)
	    newAction = fileMenu.addAction(tr("&New..."))
	    newAction.shortcut = Qt::KeySequence.new( tr("Ctrl+N") )
	    @printAction = fileMenu.addAction(tr("&Print..."), self, SLOT('printFile()'))
	    @printAction.shortcut = Qt::KeySequence.new( tr("Ctrl+P") )
	    @printAction.enabled = false
	    quitAction = fileMenu.addAction(tr("E&xit"))
	    quitAction.shortcut = Qt::KeySequence.new( tr("Ctrl+Q") )
	    menuBar().addMenu(fileMenu)
	
	    @letters = Qt::TabWidget.new
	
	    connect(newAction, SIGNAL('triggered()'), self, SLOT('openDialog()'))
	    connect(quitAction, SIGNAL('triggered()'), self, SLOT('close()'))
	
	    self.centralWidget = @letters
	    self.windowTitle = tr("Order Form")
	end
	
	def createLetter(name, address, orderItems, sendOffers)
	    editor = Qt::TextEdit.new
	    tabIndex = @letters.addTab(editor, name)
	    @letters.currentIndex = tabIndex
	
	    cursor = Qt::TextCursor.new(editor.textCursor())
	    cursor.movePosition(Qt::TextCursor::Start)
	    topFrame = cursor.currentFrame()
	    topFrameFormat = topFrame.frameFormat()
	    topFrameFormat.padding = 16
	    topFrame.frameFormat = topFrameFormat
	
	    textFormat = Qt::TextCharFormat.new
	    boldFormat = Qt::TextCharFormat.new
	    boldFormat.fontWeight = Qt::Font::Bold
	
	    referenceFrameFormat = Qt::TextFrameFormat.new do |r|
			r.border = 1
			r.padding = 8
			r.position = Qt::TextFrameFormat::FloatRight
			r.width = Qt::TextLength.new(Qt::TextLength::PercentageLength, 40)
		end
	    cursor.insertFrame(referenceFrameFormat)
	
	    cursor.insertText("A company", boldFormat)
	    cursor.insertBlock()
	    cursor.insertText("321 City Street")
	    cursor.insertBlock()
	    cursor.insertText("Industry Park")
	    cursor.insertBlock()
	    cursor.insertText("Another country")
	
	    cursor.position = topFrame.lastPosition()
	
	    cursor.insertText(name, textFormat)
	    address.split("\n").each do |line|
	        cursor.insertBlock()
	        cursor.insertText(line)
	    end
	    cursor.insertBlock()
	    cursor.insertBlock()
	
	    date = Qt::Date.currentDate()
	    cursor.insertText(tr("Date: %s" % date.toString("d MMMM yyyy")),
	                      textFormat)
	    cursor.insertBlock()
	
	    bodyFrameFormat = Qt::TextFrameFormat.new
	    bodyFrameFormat.setWidth(Qt::TextLength.new(Qt::TextLength::PercentageLength, 100))
	    cursor.insertFrame(bodyFrameFormat)
	
	    cursor.insertText(tr("I would like to place an order for the following " +
	                         "items:"), textFormat)
	    cursor.insertBlock()
	
	    orderTableFormat = Qt::TextTableFormat.new
	    orderTableFormat.alignment = Qt::AlignHCenter.to_i
	    orderTable = cursor.insertTable(1, 2, orderTableFormat)
	
	    orderFrameFormat = cursor.currentFrame().frameFormat()
	    orderFrameFormat.border = 1
	    cursor.currentFrame().frameFormat = orderFrameFormat
	
	    cursor = orderTable.cellAt(0, 0).firstCursorPosition()
	    cursor.insertText(tr("Product"), boldFormat)
	    cursor = orderTable.cellAt(0, 1).firstCursorPosition()
	    cursor.insertText(tr("Quantity"), boldFormat)
	
		(0...orderItems.length).each do |i|
	        item = orderItems[i]
	        row = orderTable.rows()
	
	        orderTable.insertRows(row, 1)
	        cursor = orderTable.cellAt(row, 0).firstCursorPosition()
	        cursor.insertText(item[0], textFormat)
	        cursor = orderTable.cellAt(row, 1).firstCursorPosition()
	        cursor.insertText("%s" % item[1], textFormat)
	    end
	
	    cursor.position = topFrame.lastPosition()
	
	    cursor.insertText(tr("Please update my records to take account of the " +
	                         "following privacy information:"))
	    cursor.insertBlock()
	
	    offersTable = cursor.insertTable(2, 2)
	
	    cursor = offersTable.cellAt(0, 1).firstCursorPosition()
	    cursor.insertText(tr("I want to receive more information about your " +
	                         "company's products and special offers."), textFormat)
	    cursor = offersTable.cellAt(1, 1).firstCursorPosition()
	    cursor.insertText(tr("I do not want to receive any promotional information " +
	                         "from your company."), textFormat)
	
	    if sendOffers
	        cursor = offersTable.cellAt(0, 0).firstCursorPosition()
	    else
	        cursor = offersTable.cellAt(1, 0).firstCursorPosition()
		end
	
	    cursor.insertText("X", boldFormat)
	
	    cursor.position = topFrame.lastPosition()
	    cursor.insertBlock
	    cursor.insertText(tr("Sincerely,"), textFormat)
	    cursor.insertBlock
	    cursor.insertBlock
	    cursor.insertBlock
	    cursor.insertText(name)

	    @printAction.enabled = true
	end
	
	def createSample()
	    dialog = DetailsDialog.new("Dialog with default values", self)
	    createLetter("Mr Smith", "12 High Street\nSmall Town\nThis country",
	                 dialog.orderItems, true)
	end
	
	def openDialog()
	    dialog = DetailsDialog.new(tr("Enter Customer Details"), self)
	
	    if dialog.exec == Qt::Dialog::Accepted
	        createLetter(dialog.senderName, dialog.senderAddress,
	                     dialog.orderItems, dialog.sendOffers)
		end
	end
	
	def printFile()
	    editor = @letters.currentWidget
	    document = editor.document
	    printer = Qt::Printer.new
	
	    dialog = Qt::PrintDialog.new(printer, self)
	    if dialog.exec != Qt::Dialog::Accepted
	        return
		end
	
	    document.print(printer)
	end
end
