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
	
	
	
	
class MainWindow < Qt::MainWindow
	
	slots	'newLetter()',
    		'save()',
    		'print()',
    		'undo()',
    		'about()',
    		'insertCustomer(const QString&)',
    		'addParagraph(const QString&)'
	
	def initialize()
		super
	    @textEdit = Qt::TextEdit.new
	    setCentralWidget(@textEdit)
	
	    createActions()
	    createMenus()
	    createToolBars()
	    createStatusBar()
	    createDockWindows()
	
	    setWindowTitle(tr("Dock Widgets"))
	
	    newLetter()
	end
	
	def newLetter()
	    @textEdit.clear()
	
	    cursor = Qt::TextCursor.new(@textEdit.textCursor())
	    cursor.movePosition(Qt::TextCursor::Start)
	    topFrame = cursor.currentFrame()
	    topFrameFormat = topFrame.frameFormat()
	    topFrameFormat.padding = 16
	    topFrame.frameFormat = topFrameFormat
	
	    textFormat = Qt::TextCharFormat.new
	    boldFormat = Qt::TextCharFormat.new
	    boldFormat.fontWeight = Qt::Font::Bold
	    italicFormat = Qt::TextCharFormat.new
	    italicFormat.fontItalic = true
	
	    tableFormat = Qt::TextTableFormat.new
	    tableFormat.border = 1
	    tableFormat.cellPadding = 16
	    tableFormat.alignment = Qt::AlignRight
	    cursor.insertTable(1, 1, tableFormat)
	    cursor.insertText("The Firm", boldFormat)
	    cursor.insertBlock()
	    cursor.insertText("321 City Street", textFormat)
	    cursor.insertBlock()
	    cursor.insertText("Industry Park")
	    cursor.insertBlock()
	    cursor.insertText("Some Country")
	    cursor.position = topFrame.lastPosition()
	    cursor.insertText(Qt::Date::currentDate().toString("d MMMM yyyy"), textFormat)
	    cursor.insertBlock()
	    cursor.insertBlock()
	    cursor.insertText("Dear ", textFormat)
	    cursor.insertText("NAME", italicFormat)
	    cursor.insertText(",", textFormat)
		for i in 0...3
	        cursor.insertBlock()
		end
	    cursor.insertText(tr("Yours sincerely,"), textFormat)
		for i in 0...3
	        cursor.insertBlock()
		end
	    cursor.insertText("The Boss", textFormat)
	    cursor.insertBlock()
	    cursor.insertText("ADDRESS", italicFormat)
	end
	
	def print()
	    document = @textEdit.document()
	    printer = Qt::Printer.new
	
	    dlg = Qt::PrintDialog.new(printer, self)
	    if dlg.exec() != Qt::Dialog::Accepted
	        return
		end
	
	    document.print(printer)
	
	    statusBar().showMessage(tr("Ready"), 2000)
	end
	
	def save()
	    fileName = Qt::FileDialog.getSaveFileName(self,
	                        tr("Choose a file name"), ".",
	                        tr("HTML (*.html *.htm)"))
	    if fileName.empty?
	        return
		end
	    file = Qt::File.new(fileName)
	    if !file.open(Qt::File::WriteOnly | Qt::File::Text)
	        Qt::MessageBox.warning(self, tr("Dock Widgets"),
	                             tr("Cannot write file %s:\n%s." % [fileName, errorString]))
	        return
	    end
	
	    out = Qt::TextStream.new(file)
	    Qt::Application.setOverrideCursor(Qt::WaitCursor)
	    out << @textEdit.toHtml()
	    Qt::Application.restoreOverrideCursor()
	
	    statusBar().showMessage(tr("Saved '%1'").arg(fileName), 2000)
	end
	
	def undo()
	    document = @textEdit.document()
	    document.undo()
	end
	
	def insertCustomer(customer)
	    if customer.empty?
	        return
		end
	    @customerList = customer.split(", ")
	    document = @textEdit.document()
	    cursor = document.find("NAME")
	    if !cursor.nil?
	        cursor.beginEditBlock()
	        cursor.insertText(@customerList.at(0))
	        oldcursor = cursor
	        cursor = document.find("ADDRESS")
	        if !cursor.nil?
				for i in 1...@customerList.size
	                cursor.insertBlock()
	                cursor.insertText(@customerList.at(i))
	            end
	            cursor.endEditBlock()
	        else
	            oldcursor.endEditBlock()
			end
	    end
	end
	
	def addParagraph(paragraph)
	    if paragraph.empty?
	        return
		end
	    document = @textEdit.document()
	    cursor = document.find(tr("Yours sincerely,"))
	    if cursor.nil?
	        return
		end
	    cursor.beginEditBlock()
	    cursor.movePosition(Qt::TextCursor::PreviousBlock, Qt::TextCursor::MoveAnchor, 2)
	    cursor.insertBlock()
	    cursor.insertText(paragraph)
	    cursor.insertBlock()
	    cursor.endEditBlock()
	end
	
	def about()
	   Qt::MessageBox.about(self, tr("About Dock Widgets"),
	            tr("The <b>Dock Widgets</b> example demonstrates how to " \
	               "use Qt's dock widgets. You can enter your own text, " \
	               "click a customer to add a customer name and " \
	               "address, and click standard paragraphs to add them."))
	end
	
	def createActions()
	    @newLetterAct = Qt::Action.new(Qt::Icon.new("images/new.png"), tr("&New Letter"),
	                               self)
	    @newLetterAct.shortcut = Qt::KeySequence.new(tr("Ctrl+N"))
	    @newLetterAct.statusTip = tr("Create a form.new letter")
	    connect(@newLetterAct, SIGNAL('triggered()'), self, SLOT('newLetter()'))
	
	    @saveAct = Qt::Action.new(Qt::Icon.new("images/save.png"), tr("&Save..."), self)
	    @saveAct.shortcut = Qt::KeySequence.new(tr("Ctrl+S"))
	    @saveAct.statusTip = tr("Save the current form letter")
	    connect(@saveAct, SIGNAL('triggered()'), self, SLOT('save()'))
	
	    @printAct = Qt::Action.new(Qt::Icon.new("images/print.png"), tr("&Print..."), self)
	    @printAct.shortcut = Qt::KeySequence.new( tr("Ctrl+P"))
	    @printAct.statusTip = tr("Print the current form letter")
	    connect(@printAct, SIGNAL('triggered()'), self, SLOT('print()'))
	
	    @undoAct = Qt::Action.new(Qt::Icon.new("images/undo.png"), tr("&Undo"), self)
	    @undoAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Z"))
	    @undoAct.statusTip = tr("Undo the last editing action")
	    connect(@undoAct, SIGNAL('triggered()'), self, SLOT('undo()'))
	
	    @quitAct = Qt::Action.new(tr("&Quit"), self)
	    @quitAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Q"))
	    @quitAct.statusTip = tr("Quit the application")
	    connect(@quitAct, SIGNAL('triggered()'), self, SLOT('close()'))
	
	    @aboutAct = Qt::Action.new(tr("&About"), self)
	    @aboutAct.statusTip = tr("Show the application's About box")
	    connect(@aboutAct, SIGNAL('triggered()'), self, SLOT('about()'))
	
	    @aboutQtAct = Qt::Action.new(tr("About &Qt"), self)
	    @aboutQtAct.statusTip = tr("Show the Qt library's About box")
	    connect(@aboutQtAct, SIGNAL('triggered()'), $qApp, SLOT('aboutQt()'))
	end
	
	def createMenus()
	    @fileMenu = menuBar().addMenu(tr("&File"))
	    @fileMenu.addAction(@newLetterAct)
	    @fileMenu.addAction(@saveAct)
	    @fileMenu.addAction(@printAct)
	    @fileMenu.addSeparator()
	    @fileMenu.addAction(@quitAct)
	
	    @editMenu = menuBar().addMenu(tr("&Edit"))
	    @editMenu.addAction(@undoAct)
	
	    menuBar().addSeparator()
	
	    @helpMenu = menuBar().addMenu(tr("&Help"))
	    @helpMenu.addAction(@aboutAct)
	    @helpMenu.addAction(@aboutQtAct)
	end
	
	def createToolBars()
	    @fileToolBar = addToolBar(tr("File"))
	    @fileToolBar.addAction(@newLetterAct)
	    @fileToolBar.addAction(@saveAct)
	    @fileToolBar.addAction(@printAct)
	
	    @editToolBar = addToolBar(tr("Edit"))
	    @editToolBar.addAction(@undoAct)
	end
	
	def createStatusBar()
	    statusBar().showMessage(tr("Ready"))
	end
	
	def createDockWindows()
	    dock = Qt::DockWidget.new(tr("Customers"), self)
	    dock.allowedAreas = Qt::LeftDockWidgetArea | Qt::RightDockWidgetArea
	    @customerList = Qt::ListWidget.new(dock)
	    @customerList.addItems([] <<
	            "John Doe, Harmony Enterprises, 12 Lakeside, Ambleton" <<
	            "Jane Doe, Memorabilia, 23 Watersedge, Beaton" <<
	            "Tammy Shea, Tiblanka, 38 Sea Views, Carlton" <<
	            "Tim Sheen, Caraba Gifts, 48 Ocean Way, Deal" <<
	            "Sol Harvey, Chicos Coffee, 53 New Springs, Eccleston" <<
	            "Sally Hobart, Tiroli Tea, 67 Long River, Fedula")
	    dock.widget = @customerList
	    addDockWidget(Qt::RightDockWidgetArea, dock)
	
	    dock = Qt::DockWidget.new(tr("Paragraphs"), self)
	    @paragraphsList = Qt::ListWidget.new(dock)
	    @paragraphsList.addItems([] <<
	               "Thank you for your payment which we have received today." <<
	               "Your order has been dispatched and should be with you " \
	               "within 28 days." <<
	               "We have dispatched those items that were in stock. The " \
	               "rest of your order will be dispatched once all the " \
	               "remaining items have arrived at our warehouse. No " \
	               "additional shipping charges will be made." <<
	               "You made a small overpayment (less than $5) which we " \
	               "will keep on account for you, or return at your request." <<
	               "You made a small underpayment (less than $1), but we have " \
	               "sent your order anyway. We'll add self underpayment to " \
	               "your next bill." <<
	               "Unfortunately you did not send enough money. Please remit " \
	               "an additional $. Your order will be dispatched as soon as " \
	               "the complete amount has been received." <<
	               "You made an overpayment (more than $5). Do you wish to " \
	               "buy more items, or should we return the excess to you?")
	    dock.widget = @paragraphsList
	    addDockWidget(Qt::RightDockWidgetArea, dock)
	
	    connect(@customerList, SIGNAL('currentTextChanged(const QString&)'),
	            self, SLOT('insertCustomer(const QString&)'))
	    connect(@paragraphsList, SIGNAL('currentTextChanged(const QString&)'),
	            self, SLOT('addParagraph(const QString&)'))
	end
end
