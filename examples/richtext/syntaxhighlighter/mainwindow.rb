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
	
require 'highlighter.rb'
	
class MainWindow < Qt::MainWindow
	
	slots	'newFile()',
			'openFile()',
    		'openFile(const QString)'
	
	def initialize(parent = nil)
	    super(parent)
		@highlighter = Highlighter.new
	    setupFileMenu()
	    setupEditor()
	
	    setCentralWidget(@editor)
	    setWindowTitle(tr("Syntax Highlighter"))
	end
	
	def newFile()
	    @editor.clear()
	end
	
	def openFile(path = nil)
	    fileName = path
	
	    if fileName.nil?
	        fileName = Qt::FileDialog.getOpenFileName(self,
	            tr("Open File"), "", "qmake Files (*.pro *.prf *.pri)")
		end
	
	    if !fileName.nil?
	        file = Qt::File.new(fileName)
	        if file.open(Qt::File::ReadOnly | Qt::File::Text)
	            @editor.plainText = file.readAll.to_s
			end
	    end
	end
	
	def setupEditor()
	    variableFormat = Qt::TextCharFormat.new
	    variableFormat.fontWeight = Qt::Font::Bold
	    variableFormat.foreground = Qt::Brush.new(Qt::blue)
	    @highlighter.addMapping('\b[A-Z_]+\b', variableFormat)
	
	    singleLineCommentFormat = Qt::TextCharFormat.new
	    singleLineCommentFormat.background = Qt::Brush.new(Qt::Color.new("#77ff77"))
	    @highlighter.addMapping('#[^\n]*', singleLineCommentFormat)
	
	    quotationFormat = Qt::TextCharFormat.new
	    quotationFormat.background = Qt::Brush.new(Qt::cyan)
	    quotationFormat.foreground = Qt::Brush.new(Qt::blue)
	    @highlighter.addMapping('\".*\"', quotationFormat)
	
	    functionFormat = Qt::TextCharFormat.new
	    functionFormat.fontItalic = true
	    functionFormat.foreground = Qt::Brush.new(Qt::blue)
	    @highlighter.addMapping('\b[a-z0-9_]+\(.*\)', functionFormat)
	
	    font = Qt::Font.new
	    font.family = "Courier"
	    font.fixedPitch = true
	    font.pointSize = 10
	
	    @editor = Qt::TextEdit.new
	    @editor.font = font
	    @highlighter.addToDocument(@editor.document())
	end
	
	def setupFileMenu()
	    fileMenu = Qt::Menu.new(tr("&File"), self)
	    menuBar().addMenu(fileMenu)
	
	    fileMenu.addAction(tr("&New..."), self, SLOT('newFile()'),
	                        Qt::KeySequence.new(tr("Ctrl+N", "File|New")))
	    fileMenu.addAction(tr("&Open..."), self, SLOT('openFile()'),
	                        Qt::KeySequence.new(tr("Ctrl+O", "File|Open")))
	    fileMenu.addAction(tr("E&xit"), $qApp, SLOT('quit()'),
	                        Qt::KeySequence.new(tr("Ctrl+Q", "File|Exit")))
	end
end
