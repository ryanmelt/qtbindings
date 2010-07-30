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
	
	slots 'newFile()', 'open()', 'save()',
    		'saveAs()', 'about()', 'documentWasModified()'
	
	def initialize(parent = nil)
		super
	    @textEdit = Qt::TextEdit.new
	    setCentralWidget(@textEdit)
	
	    createActions()
	    createMenus()
	    createToolBars()
	    createStatusBar()
	
	    readSettings()
	
	    connect(@textEdit.document(), SIGNAL('contentsChanged()'),
	            self, SLOT('documentWasModified()'))
	
	    setCurrentFile("")
	end
	
	def closeEvent(event)
	    if maybeSave()
	        writeSettings()
	        event.accept()
	    else
	        event.ignore()
	    end
	end
	
	def newFile()
	    if maybeSave()
	        @textEdit.clear()
	        setCurrentFile("")
	    end
	end
	
	def open()
	    if maybeSave()
	        fileName = Qt::FileDialog.getOpenFileName(self)
	        if !fileName.nil?
	            loadFile(fileName)
			end
	    end
	end
	
	def save()
	    if @curFile.empty?
	        return saveAs()
	    else
	        return saveFile(@curFile)
	    end
	end
	
	def saveAs()
	    fileName = Qt::FileDialog.getSaveFileName(self)
	    if fileName.nil?
	        return false
		end
	
	    return saveFile(fileName)
	end
	
	def about()
	   Qt::MessageBox.about(self, tr("About Application"),
	            tr("The <b>Application</b> example demonstrates how to " +
	               "write modern GUI applications using Qt, with a menu bar, " +
	               "toolbars, and a status bar."))
	end
	
	def documentWasModified()
	    setWindowModified(true)
	end
	
	def createActions()
	    @newAct = Qt::Action.new(Qt::Icon.new("images/new.png"), tr("&New"), self)
	    @newAct.shortcut = Qt::KeySequence.new( tr("Ctrl+N") )
	    @newAct.statusTip = tr("Create a file.new")
	    connect(@newAct, SIGNAL('triggered()'), self, SLOT('newFile()'))
	
	    @openAct = Qt::Action.new(Qt::Icon.new("images/open.png"), tr("&Open..."), self)
	    @openAct.shortcut = Qt::KeySequence.new( tr("Ctrl+O") )
	    @openAct.statusTip = tr("Open an existing file")
	    connect(@openAct, SIGNAL('triggered()'), self, SLOT('open()'))
	
	    @saveAct = Qt::Action.new(Qt::Icon.new("images/save.png"), tr("&Save"), self)
	    @saveAct.shortcut = Qt::KeySequence.new( tr("Ctrl+S") )
	    @saveAct.statusTip = tr("Save the document to disk")
	    connect(@saveAct, SIGNAL('triggered()'), self, SLOT('save()'))
	
	    @saveAsAct = Qt::Action.new(tr("Save &As..."), self)
	    @saveAsAct.statusTip = tr("Save the document under a name.new")
	    connect(@saveAsAct, SIGNAL('triggered()'), self, SLOT('saveAs()'))
	
	    @exitAct = Qt::Action.new(tr("E&xit"), self)
	    @exitAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Q") )
	    @exitAct.statusTip = tr("Exit the application")
	    connect(@exitAct, SIGNAL('triggered()'), self, SLOT('close()'))
	
	    @cutAct = Qt::Action.new(Qt::Icon.new("images/cut.png"), tr("Cu&t"), self)
	    @cutAct.shortcut = Qt::KeySequence.new( tr("Ctrl+X") )
	    @cutAct.setStatusTip(tr("Cut the current selection's contents to the " +
	                            "clipboard"))
	    connect(@cutAct, SIGNAL('triggered()'), @textEdit, SLOT('cut()'))
	
	    @copyAct = Qt::Action.new(Qt::Icon.new("images/copy.png"), tr("&Copy"), self)
	    @copyAct.shortcut = Qt::KeySequence.new( tr("Ctrl+C") )
	    @copyAct.setStatusTip(tr("Copy the current selection's contents to the " +
	                             "clipboard"))
	    connect(@copyAct, SIGNAL('triggered()'), @textEdit, SLOT('copy()'))
	
	    @pasteAct = Qt::Action.new(Qt::Icon.new("images/paste.png"), tr("&Paste"), self)
	    @pasteAct.shortcut = Qt::KeySequence.new( tr("Ctrl+V") )
	    @pasteAct.setStatusTip(tr("Paste the clipboard's contents into the current " +
	                              "selection"))
	    connect(@pasteAct, SIGNAL('triggered()'), @textEdit, SLOT('paste()'))
	
	    @aboutAct = Qt::Action.new(tr("&About"), self)
	    @aboutAct.statusTip = tr("Show the application's About box")
	    connect(@aboutAct, SIGNAL('triggered()'), self, SLOT('about()'))
	
	    @aboutQtAct = Qt::Action.new(tr("About &Qt"), self)
	    @aboutQtAct.statusTip = tr("Show the Qt library's About box")
	    connect(@aboutQtAct, SIGNAL('triggered()'), $qApp, SLOT('aboutQt()'))
	
	    @cutAct.enabled = false
	    @copyAct.enabled = false
	    connect(@textEdit, SIGNAL('copyAvailable(bool)'),
	            @cutAct, SLOT('setEnabled(bool)'))
	    connect(@textEdit, SIGNAL('copyAvailable(bool)'),
	            @copyAct, SLOT('setEnabled(bool)'))
	end
	
	def createMenus()
	    @fileMenu = menuBar().addMenu(tr("&File"))
	    @fileMenu.addAction(@newAct)
	    @fileMenu.addAction(@openAct)
	    @fileMenu.addAction(@saveAct)
	    @fileMenu.addAction(@saveAsAct)
	    @fileMenu.addSeparator()
	    @fileMenu.addAction(@exitAct)
	
	    @editMenu = menuBar().addMenu(tr("&Edit"))
	    @editMenu.addAction(@cutAct)
	    @editMenu.addAction(@copyAct)
	    @editMenu.addAction(@pasteAct)
	
	    menuBar().addSeparator()
	
	    @helpMenu = menuBar().addMenu(tr("&Help"))
	    @helpMenu.addAction(@aboutAct)
	    @helpMenu.addAction(@aboutQtAct)
	end
	
	def createToolBars()
	    @fileToolBar = addToolBar(tr("File"))
	    @fileToolBar.addAction(@newAct)
	    @fileToolBar.addAction(@openAct)
	    @fileToolBar.addAction(@saveAct)
	
	    @editToolBar = addToolBar(tr("Edit"))
	    @editToolBar.addAction(@cutAct)
	    @editToolBar.addAction(@copyAct)
	    @editToolBar.addAction(@pasteAct)
	end
	
	def createStatusBar()
	    statusBar().showMessage(tr("Ready"))
	end
	
	def readSettings()
	    settings = Qt::Settings.new("Trolltech", "Application Example")
	    pos = settings.value("pos", Qt::Variant.new(Qt::Point.new(200, 200))).toPoint()
	    size = settings.value("size", Qt::Variant.new(Qt::Size.new(400, 400))).toSize()
	    resize(size)
	    move(pos)
	end
	
	def writeSettings()
	    settings = Qt::Settings.new("Trolltech", "Application Example")
	    settings.setValue("pos", Qt::Variant.new(pos()))
	    settings.setValue("size", Qt::Variant.new(size()))
	end
	
	def maybeSave()
	    if @textEdit.document().isModified()
	        ret = Qt::MessageBox::warning(self, tr("Application"),
	                     tr("The document has been modified.\n" +
	                        "Do you want to save your changes?"),
	                     Qt::MessageBox::Yes | Qt::MessageBox::Default,
	                     Qt::MessageBox::No,
	                     Qt::MessageBox::Cancel | Qt::MessageBox::Escape)
	        if ret == Qt::MessageBox::Yes
	            return save()
	        elsif ret == Qt::MessageBox::Cancel
	            return false
			end
	    end
	    return true
	end
	
	def loadFile(fileName)
	    file = Qt::File.new(fileName)
	    if !file.open(Qt::File::ReadOnly | Qt::File::Text)
	        Qt::MessageBox.warning(self, tr("Application"),
	                             tr("Cannot read file %s:\n%s." % [fileName, file.errorString]) )
	        return
	    end
	
	    inf = Qt::TextStream.new(file)
	    Qt::Application.setOverrideCursor(Qt::Cursor.new(Qt::WaitCursor))
	    @textEdit.plainText = inf.readAll()
	    Qt::Application.restoreOverrideCursor()
	
	    setCurrentFile(fileName)
	    statusBar().showMessage(tr("File loaded"), 2000)
	end
	
	def saveFile(fileName)
	    file = Qt::File.new(fileName)
	    if !file.open(Qt::File::WriteOnly | Qt::File::Text)
	        Qt::MessageBox.warning(self, tr("Application"),
	                             tr("Cannot write file %s:\n%s." % [fileName, file.errorString]))
	        return false
	    end
	
	    outf = Qt::TextStream.new(file)
	    Qt::Application.setOverrideCursor(Qt::Cursor.new(Qt::WaitCursor))
	    outf << @textEdit.toPlainText()
		outf.dispose
	    Qt::Application.restoreOverrideCursor()
	
	    setCurrentFile(fileName)
	    statusBar().showMessage(tr("File saved"), 2000)
	    return true
	end
	
	def setCurrentFile(fileName)
	    @curFile = fileName
	    @textEdit.document().modified = false
	    setWindowModified(false)
	
	    if @curFile.empty?
	        shownName = "untitled.txt"
	    else
	        shownName = strippedName(@curFile)
		end
	
	    setWindowTitle(tr("%s[*] - %s" % [shownName, tr("Application")]))
	end
	
	def strippedName(fullFileName)
	    return Qt::FileInfo.new(fullFileName).fileName()
	end
end
