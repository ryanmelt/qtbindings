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
	
class Dialog < Qt::Dialog
	
	NumGridRows = 3 
	NumButtons = 4
	
	def initialize()
		super
		@labels = []
	    @lineEdits = []
	    @buttons = []

	    createMenu()
	    createHorizontalGroupBox()
	    createGridGroupBox()
	
	    @bigEditor = Qt::TextEdit.new
	    @bigEditor.setPlainText(tr("This widget takes up all the remaining space " +
	                               "in the top-level layout."))
	
	    @okButton = Qt::PushButton.new(tr("OK"))
	    @cancelButton = Qt::PushButton.new(tr("Cancel"))
	    @okButton.default = true
	
	    connect(@okButton, SIGNAL('clicked()'), self, SLOT('accept()'))
	    connect(@cancelButton, SIGNAL('clicked()'), self, SLOT('reject()'))
	
	    buttonLayout = Qt::HBoxLayout.new do |b|
			b.addStretch(1)
			b.addWidget(@okButton)
			b.addWidget(@cancelButton)
		end
	
	    self.layout = Qt::VBoxLayout.new do |m|
			m.menuBar = @menuBar
			m.addWidget(@horizontalGroupBox)
			m.addWidget(@gridGroupBox)
			m.addWidget(@bigEditor)
			m.addLayout(buttonLayout)
		end
	
	    setWindowTitle(tr("Basic Layouts"))
	end
	
	def createMenu()
	    @menuBar = Qt::MenuBar.new
	
	    @fileMenu = Qt::Menu.new(tr("&File"), self)
	    @exitAction = @fileMenu.addAction(tr("E&xit"))
	    @menuBar.addMenu(@fileMenu)
	
	    connect(@exitAction, SIGNAL('triggered()'), self, SLOT('accept()'))
	end
	
	def createHorizontalGroupBox()
	    @horizontalGroupBox = Qt::GroupBox.new(tr("Horizontal layout"))
	    layout = Qt::HBoxLayout.new
	
		(0...NumButtons).each do |i|
	        @buttons[i] = Qt::PushButton.new(tr("Button %d" % (i + 1)))
			layout.addWidget(@buttons[i])
	    end
	    @horizontalGroupBox.layout = layout
	end
	
	def createGridGroupBox()
	    @gridGroupBox = Qt::GroupBox.new(tr("Grid layout"))
	    layout = Qt::GridLayout.new
	
		(0...NumGridRows).each do |i|
			@labels[i] = Qt::Label.new(tr("Line %d:" % (i + 1)))
			@lineEdits[i] = Qt::LineEdit.new
			layout.addWidget(@labels[i], i, 0)
			layout.addWidget(@lineEdits[i], i, 1)
	    end
	
	    @smallEditor = Qt::TextEdit.new
	    @smallEditor.setPlainText(tr("This widget takes up about two thirds of the " +
	                                 "grid layout."))
	    layout.addWidget(@smallEditor, 0, 2, 3, 1)
	
	    layout.setColumnStretch(1, 10)
	    layout.setColumnStretch(2, 20)
	    @gridGroupBox.layout = layout
	end
end
