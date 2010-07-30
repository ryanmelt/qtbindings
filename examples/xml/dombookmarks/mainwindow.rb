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

require 'xbeltree.rb'
	
class MainWindow < Qt::MainWindow
		
	slots :open, :saveAs, :about
	
	def initialize(parent = nil)
		super(parent)
	    @xbelTree = XbelTree.new
	    setCentralWidget(@xbelTree)
	
	    createActions()
	    createMenus()
	
	    statusBar.showMessage(tr("Ready"))
	
	    setWindowTitle(tr("DOM Bookmarks"))
	    resize(480, 320)
	end
	
	def open()
	    fileName =
	            Qt::FileDialog.getOpenFileName(self, tr("Open Bookmark File"),
	                                         Qt::Dir.currentPath(),
	                                         tr("XBEL Files (*.xbel *.xml)"))
	    if fileName.nil?
	        return
		end
	
	    file = Qt::File.new(fileName)
	    if !file.open(Qt::File::ReadOnly | Qt::File::Text)
	        Qt::MessageBox.warning(self, tr("SAX Bookmarks"),
	                             tr("Cannot read file %s:\n%s." %
	                             [fileName, file.errorString]))
	        return
	    end
	
	    if @xbelTree.read(file)
	        statusBar.showMessage(tr("File loaded"), 2000)
		end
	end
	
	def saveAs()
	    fileName =
	            Qt::FileDialog.getSaveFileName(self, tr("Save Bookmark File"),
	                                         Qt::Dir.currentPath(),
	                                         tr("XBEL Files (*.xbel *.xml)"))
	    if fileName.nil?
	        return
		end
	
	    file = Qt::File.new(fileName)
	    if !file.open(Qt::File::WriteOnly | Qt::File::Text)
	        Qt::MessageBox.warning(self, tr("SAX Bookmarks"),
	                             tr("Cannot write file %s:\n%s." %
	                             [fileName, file.errorString]))
	        return
	    end
	
	    if @xbelTree.write(file)
	        statusBar.showMessage(tr("File saved"), 2000)
		end
	end
	
	def about()
	   Qt::MessageBox.about(self, tr("About DOM Bookmarks"),
	                      tr("The <b>DOM Bookmarks</b> example demonstrates how to " \
	                         "use Qt's DOM classes to read and write XML " \
	                         "documents."))
	end
	
	def createActions()
	    @openAct = Qt::Action.new(tr("&Open..."), self)
	    @openAct.shortcut = Qt::KeySequence.new( tr("Ctrl+O"))
	    connect(@openAct, SIGNAL(:triggered), self, SLOT(:open))
	
	    @saveAsAct = Qt::Action.new(tr("&Save As..."), self)
	    @saveAsAct.shortcut = Qt::KeySequence.new( tr("Ctrl+S"))
	    connect(@saveAsAct, SIGNAL(:triggered), self, SLOT(:saveAs))
	
	    @exitAct = Qt::Action.new(tr("E&xit"), self)
	    @exitAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Q"))
	    connect(@exitAct, SIGNAL(:triggered), self, SLOT(:close))
	
	    @aboutAct = Qt::Action.new(tr("&About"), self)
	    connect(@aboutAct, SIGNAL(:triggered), self, SLOT(:about))
	
	    @aboutQtAct = Qt::Action.new(tr("About &Qt"), self)
	    connect(@aboutQtAct, SIGNAL(:triggered), $qApp, SLOT(:aboutQt))
	end
	
	def createMenus()
	    @fileMenu = menuBar.addMenu(tr("&File"))
	    @fileMenu.addAction(@openAct)
	    @fileMenu.addAction(@saveAsAct)
	    @fileMenu.addAction(@exitAct)
	
	    menuBar().addSeparator()
	
	    @helpMenu = menuBar.addMenu(tr("&Help"))
	    @helpMenu.addAction(@aboutAct)
	    @helpMenu.addAction(@aboutQtAct)
	end
end
