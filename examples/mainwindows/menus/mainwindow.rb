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
	
	slots 'newFile()',
    		'open()',
    		'save()',
    		'print()',
    		'undo()',
    		'redo()',
    		'cut()',
    		'copy()',
    		'paste()',
    		'bold()',
    		'italic()',
    		'leftAlign()',
    		'rightAlign()',
    		'justify()',
    		'center()',
    		'setLineSpacing()',
    		'setParagraphSpacing()',
    		'about()',
    		'aboutQt()'
	
	def initialize(parent = nil)
		super
	    w = Qt::Widget.new
	    setCentralWidget(w)
	
	    topFiller = Qt::Widget.new
	    topFiller.setSizePolicy(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)
	
	    @infoLabel = Qt::Label.new(tr("<i>Choose a menu option, or right-click to " +
	                              "invoke a context menu</i>"))
	    @infoLabel.frameStyle = Qt::Frame::StyledPanel | Qt::Frame::Sunken
	    @infoLabel.alignment = Qt::AlignCenter.to_i
	
	    bottomFiller = Qt::Widget.new
	    bottomFiller.setSizePolicy(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)
	
	    vbox = Qt::VBoxLayout.new
	    vbox.margin = 5
	    vbox.addWidget(topFiller)
	    vbox.addWidget(@infoLabel)
	    vbox.addWidget(bottomFiller)
	    w.layout = vbox
	
	    createActions()
	    createMenus()
	
	    statusBar().showMessage(tr("A context menu is available by right-clicking"))
	
	    setWindowTitle(tr("Menus"))
	    setMinimumSize(160, 160)
	    resize(480, 320)
	end
	
	def contextMenuEvent(event)
	    menu = Qt::Menu.new(self)
	    menu.addAction(@cutAct)
	    menu.addAction(@copyAct)
	    menu.addAction(@pasteAct)
	    menu.exec(event.globalPos())
	end
	
	def newFile()
	    @infoLabel.text = tr("Invoked <b>File|New</b>")
	end
	
	def open()
	    @infoLabel.text = tr("Invoked <b>File|Open</b>")
	end
	
	def save()
	    @infoLabel.text = tr("Invoked <b>File|Save</b>")
	end
	
	def print()
	    @infoLabel.text = tr("Invoked <b>File|Print</b>")
	end
	
	def undo()
	    @infoLabel.text = tr("Invoked <b>Edit|Undo</b>")
	end
	
	def redo()
	    @infoLabel.text = tr("Invoked <b>Edit|Redo</b>")
	end
	
	def cut()
	    @infoLabel.text = tr("Invoked <b>Edit|Cut</b>")
	end
	
	def copy()
	    @infoLabel.text = tr("Invoked <b>Edit|Copy</b>")
	end
	
	def paste()
	    @infoLabel.text = tr("Invoked <b>Edit|Paste</b>")
	end
	
	def bold()
	    @infoLabel.text = tr("Invoked <b>Edit|Format|Bold</b>")
	end
	
	def italic()
	    @infoLabel.text = tr("Invoked <b>Edit|Format|Italic</b>")
	end
	
	def leftAlign()
	    @infoLabel.text = tr("Invoked <b>Edit|Format|Left Align</b>")
	end
	
	def rightAlign()
	    @infoLabel.text = tr("Invoked <b>Edit|Format|Right Align</b>")
	end
	
	def justify()
	    @infoLabel.text = tr("Invoked <b>Edit|Format|Justify</b>")
	end
	
	def center()
	    @infoLabel.text = tr("Invoked <b>Edit|Format|Center</b>")
	end
	
	def setLineSpacing()
	    @infoLabel.text = tr("Invoked <b>Edit|Format|Set Line Spacing</b>")
	end
	
	def setParagraphSpacing()
	    @infoLabel.text = tr("Invoked <b>Edit|Format|Set Paragraph Spacing</b>")
	end
	
	def about()
	    @infoLabel.text = tr("Invoked <b>Help|About</b>")
	    Qt::MessageBox.about(self, tr("About Menu"),
	            tr("The <b>Menu</b> example shows how to create " +
	               "menu-bar menus and context menus."))
	end
	
	def aboutQt()
	    @infoLabel.text = tr("Invoked <b>Help|About Qt</b>")
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
	
	    @printAct = Qt::Action.new(tr("&Print..."), self)
	    @printAct.shortcut = Qt::KeySequence.new( tr("Ctrl+P") )
	    @printAct.statusTip = tr("Print the document")
	    connect(@printAct, SIGNAL('triggered()'), self, SLOT('print()'))
	
	    @exitAct = Qt::Action.new(tr("E&xit"), self)
	    @exitAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Q") )
	    @exitAct.statusTip = tr("Exit the application")
	    connect(@exitAct, SIGNAL('triggered()'), self, SLOT('close()'))
	
	    @undoAct = Qt::Action.new(tr("&Undo"), self)
	    @undoAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Z") )
	    @undoAct.statusTip = tr("Undo the last operation")
	    connect(@undoAct, SIGNAL('triggered()'), self, SLOT('undo()'))
	
	    @redoAct = Qt::Action.new(tr("&Redo"), self)
	    @redoAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Y") )
	    @redoAct.statusTip = tr("Redo the last operation")
	    connect(@redoAct, SIGNAL('triggered()'), self, SLOT('redo()'))
	
	    @cutAct = Qt::Action.new(tr("Cu&t"), self)
	    @cutAct.shortcut = Qt::KeySequence.new( tr("Ctrl+X") )
	    @cutAct.setStatusTip(tr("Cut the current selection's contents to the " +
	                            "clipboard"))
	    connect(@cutAct, SIGNAL('triggered()'), self, SLOT('cut()'))
	
	    @copyAct = Qt::Action.new(tr("&Copy"), self)
	    @copyAct.shortcut = Qt::KeySequence.new( tr("Ctrl+C") )
	    @copyAct.setStatusTip(tr("Copy the current selection's contents to the " +
	                             "clipboard"))
	    connect(@copyAct, SIGNAL('triggered()'), self, SLOT('copy()'))
	
	    @pasteAct = Qt::Action.new(tr("&Paste"), self)
	    @pasteAct.shortcut = Qt::KeySequence.new( tr("Ctrl+V") )
	    @pasteAct.setStatusTip(tr("Paste the clipboard's contents into the current " +
	                              "selection"))
	    connect(@pasteAct, SIGNAL('triggered()'), self, SLOT('paste()'))
	
	    @boldAct = Qt::Action.new(tr("&Bold"), self)
	    @boldAct.checkable = true
	    @boldAct.shortcut = Qt::KeySequence.new( tr("Ctrl+B") )
	    @boldAct.statusTip = tr("Make the text bold")
	    connect(@boldAct, SIGNAL('triggered()'), self, SLOT('bold()'))
	
	    boldFont = @boldAct.font()
	    boldFont.bold = true
	    @boldAct.font = boldFont
	
	    @italicAct = Qt::Action.new(tr("&Italic"), self)
	    @italicAct.checkable = true
	    @italicAct.shortcut = Qt::KeySequence.new( tr("Ctrl+I") )
	    @italicAct.statusTip = tr("Make the text italic")
	    connect(@italicAct, SIGNAL('triggered()'), self, SLOT('italic()'))
	
	    italicFont = @italicAct.font()
	    italicFont.italic = true
	    @italicAct.font = italicFont
	
	    @leftAlignAct = Qt::Action.new(tr("&Left Align"), self)
	    @leftAlignAct.checkable = true
	    @leftAlignAct.shortcut = Qt::KeySequence.new( tr("Ctrl+L") )
	    @leftAlignAct.statusTip = tr("Left align the selected text")
	    connect(@leftAlignAct, SIGNAL('triggered()'), self, SLOT('leftAlign()'))
	
	    @rightAlignAct = Qt::Action.new(tr("&Right Align"), self)
	    @rightAlignAct.checkable = true
	    @rightAlignAct.shortcut = Qt::KeySequence.new( tr("Ctrl+R") )
	    @rightAlignAct.statusTip = tr("Right align the selected text")
	    connect(@rightAlignAct, SIGNAL('triggered()'), self, SLOT('rightAlign()'))
	
	    @justifyAct = Qt::Action.new(tr("&Justify"), self)
	    @justifyAct.checkable = true
	    @justifyAct.shortcut = Qt::KeySequence.new( tr("Ctrl+J") )
	    @justifyAct.statusTip = tr("Justify the selected text")
	    connect(@justifyAct, SIGNAL('triggered()'), self, SLOT('justify()'))
	
	    @centerAct = Qt::Action.new(tr("&Center"), self)
	    @centerAct.checkable = true
	    @centerAct.shortcut = Qt::KeySequence.new( tr("Ctrl+E") )
	    @centerAct.statusTip = tr("Center the selected text")
	    connect(@centerAct, SIGNAL('triggered()'), self, SLOT('center()'))
	
	    @alignmentGroup = Qt::ActionGroup.new(self)
	    @alignmentGroup.addAction(@leftAlignAct)
	    @alignmentGroup.addAction(@rightAlignAct)
	    @alignmentGroup.addAction(@justifyAct)
	    @alignmentGroup.addAction(@centerAct)
	    @leftAlignAct.checked = true
	
	    @setLineSpacingAct = Qt::Action.new(tr("Set &Line Spacing..."), self)
	    @setLineSpacingAct.setStatusTip(tr("Change the gap between the lines of a " +
	                                       "paragraph"))
	    connect(@setLineSpacingAct, SIGNAL('triggered()'), self, SLOT('setLineSpacing()'))
	
	    @setParagraphSpacingAct = Qt::Action.new(tr("Set &Paragraph Spacing..."), self)
	    @setLineSpacingAct.statusTip = tr("Change the gap between paragraphs")
	    connect(@setParagraphSpacingAct, SIGNAL('triggered()'),
	            self, SLOT('setParagraphSpacing()'))
	
	    @aboutAct = Qt::Action.new(tr("&About"), self)
	    @aboutAct.statusTip = tr("Show the application's About box")
	    connect(@aboutAct, SIGNAL('triggered()'), self, SLOT('about()'))
	
	    @aboutQtAct = Qt::Action.new(tr("About &Qt"), self)
	    @aboutQtAct.statusTip = tr("Show the Qt library's About box")
	    connect(@aboutQtAct, SIGNAL('triggered()'), $qApp, SLOT('aboutQt()'))
	    connect(@aboutQtAct, SIGNAL('triggered()'), self, SLOT('aboutQt()'))
	end
	
	def createMenus()
	    @fileMenu = menuBar().addMenu(tr("&File"))
	    @fileMenu.addAction(@newAct)
	    @fileMenu.addAction(@openAct)
	    @fileMenu.addAction(@saveAct)
	    @fileMenu.addAction(@printAct)
	    @fileMenu.addSeparator()
	    @fileMenu.addAction(@exitAct)
	
	    @editMenu = menuBar().addMenu(tr("&Edit"))
	    @editMenu.addAction(@undoAct)
	    @editMenu.addAction(@redoAct)
	    @editMenu.addSeparator()
	    @editMenu.addAction(@cutAct)
	    @editMenu.addAction(@copyAct)
	    @editMenu.addAction(@pasteAct)
	    @editMenu.addSeparator()
	
	    @formatMenu = @editMenu.addMenu(tr("&Format"))
	    @formatMenu.addAction(@boldAct)
	    @formatMenu.addAction(@italicAct)
	    @formatMenu.addSeparator()
	    @formatMenu.addAction(@leftAlignAct)
	    @formatMenu.addAction(@rightAlignAct)
	    @formatMenu.addAction(@justifyAct)
	    @formatMenu.addAction(@centerAct)
	    @formatMenu.addSeparator()
	    @formatMenu.addAction(@setLineSpacingAct)
	    @formatMenu.addAction(@setParagraphSpacingAct)
	
	    @helpMenu = menuBar().addMenu(tr("&Help"))
	    @helpMenu.addAction(@aboutAct)
	    @helpMenu.addAction(@aboutQtAct)
	end
end
