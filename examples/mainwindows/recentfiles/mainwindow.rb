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
	
	
	slots	'newFile()',
    		'open()',
    		'save()',
    		'saveAs()',
    		'openRecentFile()',
    		'about()'
	
	
	MaxRecentFiles = 5
	
	def initialize(parent = nil)
		super
	    setAttribute(Qt::WA_DeleteOnClose)
	
	    @textEdit = Qt::TextEdit.new
	    setCentralWidget(@textEdit)
		@recentFileActs = []
	    createActions()
	    createMenus()
	    statusBar()
	
	    setWindowTitle(tr("Recent Files"))
	    resize(400, 300)
	end
	
	def newFile()
	    other = MainWindow.new
	    other.show()
	end
	
	def open()
	    fileName = Qt::FileDialog.getOpenFileName(self)
	    if !fileName.nil?
	        loadFile(fileName)
		end
	end
	
	def save()
	    if @curFile.nil?
	        saveAs()
	    else
	        saveFile(@curFile)
		end
	end
	
	def saveAs()
	    fileName = Qt::FileDialog::getSaveFileName(self)
	    if fileName.nil?
	        return
		end
	
	    if Qt::File.exists(fileName)
	        ret = Qt::MessageBox::warning(self, tr("Recent Files"),
	                     tr("File %s already exists.\nDo you want to overwrite it?" %
	                     Qt::Dir.convertSeparators(fileName)),
	                     Qt::MessageBox::Yes | Qt::MessageBox::Default,
	                     Qt::MessageBox::No | Qt::MessageBox::Escape)
	        if ret == Qt::MessageBox::No
	            return
			end
	    end
	    saveFile(fileName)
	end
	
	def openRecentFile()
	    action = sender()
	    if !action.nil?
	        loadFile(action.data().toString())
		end
	end
	
	def about()
	   Qt::MessageBox.about(self, tr("About Recent Files"),
	            tr("The <b>Recent Files</b> example demonstrates how to provide a " +
	               "recently used file menu in a Qt application."))
	end
	
	def createActions()
	    @newAct = Qt::Action.new(tr("&New"), self)
	    @newAct.shortcut = Qt::KeySequence.new( tr("Ctrl+N") )
	    @newAct.statusTip = tr("Create a file.new")
	    connect(@newAct, SIGNAL('triggered()'), self, SLOT('newFile()'))
	
	    @openAct = Qt::Action.new(tr("&Open..."), self)
	    @openAct.shortcut = Qt::KeySequence.new( tr("Ctrl+O") )
	    @openAct.statusTip = tr("Open an existing file")
	    connect(@openAct, SIGNAL('triggered()'), self, SLOT('open()'))
	
	    @saveAct = Qt::Action.new(tr("&Save"), self)
	    @saveAct.shortcut = Qt::KeySequence.new( tr("Ctrl+S") )
	    @saveAct.statusTip = tr("Save the document to disk")
	    connect(@saveAct, SIGNAL('triggered()'), self, SLOT('save()'))
	
	    @saveAsAct = Qt::Action.new(tr("Save &As..."), self)
	    @saveAsAct.statusTip = tr("Save the document under a name.new")
	    connect(@saveAsAct, SIGNAL('triggered()'), self, SLOT('saveAs()'))
	
		(0...MaxRecentFiles).each do |i|
	        @recentFileActs[i] = Qt::Action.new(self)
	        @recentFileActs[i].visible = false
	        connect(@recentFileActs[i], SIGNAL('triggered()'),
	                self, SLOT('openRecentFile()'))
	    end
	
	    @exitAct = Qt::Action.new(tr("&Close"), self)
	    @exitAct.shortcut = Qt::KeySequence.new( tr("Ctrl+W") )
	    @exitAct.statusTip = tr("Close self window")
	    connect(@exitAct, SIGNAL('triggered()'), self, SLOT('close()'))
	
	    @exitAct = Qt::Action.new(tr("E&xit"), self)
	    @exitAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Q") )
	    @exitAct.statusTip = tr("Exit the application")
	    connect(@exitAct, SIGNAL('triggered()'), $qApp, SLOT('closeAllWindows()'))
	
	    @aboutAct = Qt::Action.new(tr("&About"), self)
	    @aboutAct.statusTip = tr("Show the application's About box")
	    connect(@aboutAct, SIGNAL('triggered()'), self, SLOT('about()'))
	
	    @aboutQtAct = Qt::Action.new(tr("About &Qt"), self)
	    @aboutQtAct.statusTip = tr("Show the Qt library's About box")
	    connect(@aboutQtAct, SIGNAL('triggered()'), $qApp, SLOT('aboutQt()'))
	end
	
	def createMenus()
	    @fileMenu = menuBar().addMenu(tr("&File"))
	    @fileMenu.addAction(@newAct)
	    @fileMenu.addAction(@openAct)
	    @fileMenu.addAction(@saveAct)
	    @fileMenu.addAction(@saveAsAct)
	    @separatorAct = @fileMenu.addSeparator()
		(0...MaxRecentFiles).each do |i|
	        @fileMenu.addAction(@recentFileActs[i])
		end
	    @fileMenu.addSeparator()
	    @fileMenu.addAction(@exitAct)
	    updateRecentFileActions()
	
	    menuBar().addSeparator()
	
	    @helpMenu = menuBar().addMenu(tr("&Help"))
	    @helpMenu.addAction(@aboutAct)
	    @helpMenu.addAction(@aboutQtAct)
	end
	
	def loadFile(fileName)
	    file = Qt::File.new(fileName)
	    if !file.open(Qt::File::ReadOnly | Qt::File::Text)
	        Qt::MessageBox.warning(self, tr("Recent Files"),
	                             tr("Cannot read file %s:\n%s." % [fileName, file.errorString]))
	        return
	    end
	
	    inf = Qt::TextStream.new(file)
	    Qt::Application.overrideCursor = Qt::Cursor.new(Qt::WaitCursor)
	    @textEdit.plainText = inf.readAll
	    Qt::Application::restoreOverrideCursor
	
	    setCurrentFile(fileName)
	    statusBar().showMessage(tr("File loaded"), 2000)
	end
	
	def saveFile(fileName)
	    file = Qt::File.new(fileName)
	    if !file.open(Qt::File::WriteOnly | Qt::File::Text)
	        Qt::MessageBox.warning(self, tr("Recent Files"),
	                             tr("Cannot write file %s:\n%s." % [fileName, file.errorString]))
	        return
	    end
	
	    outf = Qt::TextStream.new(file)
	    Qt::Application.overrideCursor = Qt::Cursor.new(Qt::WaitCursor)
	    outf << @textEdit.toPlainText
		outf.flush
	    Qt::Application.restoreOverrideCursor
	
	    setCurrentFile(fileName)
	    statusBar().showMessage(tr("File saved"), 2000)
	end
	
	def setCurrentFile(fileName)
	    @curFile = fileName
	    if @curFile.nil?
	        setWindowTitle(tr("Recent Files"))
	    else
	        setWindowTitle(tr("%s - %s" % [strippedName(@curFile), tr("Recent Files")]))
		end
	
	    settings = Qt::Settings.new("Trolltech", "Recent Files Example")
	    files = settings.value("recentFileList").toStringList()
	    files.delete(fileName)
	    files.insert(0, fileName)
	    while files.length > MaxRecentFiles do
	        files.pop
		end
	
	    settings.setValue("recentFileList", Qt::Variant.new(files))
	
	    Qt::Application.topLevelWidgets.each do |widget|
	        if widget.inherits "Qt::MainWindow"
	            widget.updateRecentFileActions()
			end
	    end
	end
	
	def updateRecentFileActions()
	    settings = Qt::Settings.new("Trolltech", "Recent Files Example")
	    files = settings.value("recentFileList").toStringList()
	
	    numRecentFiles = [files.length, MaxRecentFiles].min
	
		(0...numRecentFiles).each do |i|
	        text = tr("&%s %s" % [i + 1, strippedName(files[i])])
	        @recentFileActs[i].text = text
	        @recentFileActs[i].data = Qt::Variant.new(files[i])
	        @recentFileActs[i].visible = true
	    end
		(numRecentFiles...MaxRecentFiles).each do |j|
	        @recentFileActs[j].visible = false
		end
	
	    @separatorAct.visible = numRecentFiles > 0
	end
	
	def strippedName(fullFileName)
	    return Qt::FileInfo.new(fullFileName).fileName()
	end
end
