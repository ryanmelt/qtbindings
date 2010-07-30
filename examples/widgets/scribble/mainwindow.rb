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

require 'scribblearea.rb'

class MainWindow < Qt::MainWindow

    slots   'open()',
            'save()',
            'penColor()',
            'penWidth()',
            'about()'

    def initialize(parent = nil)
        super(parent)
        @scribbleArea = ScribbleArea.new
        @saveAsActs = []
        setCentralWidget(@scribbleArea)
    
        createActions()
        createMenus()
    
        setWindowTitle(tr("Scribble"))
        resize(500, 500)
    end
    
    def closeEvent(event)
        if maybeSave()
            event.accept()
        else
            event.ignore()
        end
    end
    
    def open()
        if maybeSave()
            fileName = Qt::FileDialog::getOpenFileName(self,
                                    tr("Open File"), Qt::Dir::currentPath())
            if !fileName.nil?
                @scribbleArea.openImage(fileName)
            end
        end
    end
    
    def save()
        action = sender()
        fileFormat = action.data().toByteArray()
        saveFile(fileFormat)
    end
    
    def penColor()
        newColor = Qt::ColorDialog.getColor(Qt::Color.new(@scribbleArea.penColor))
        if newColor.isValid()
            @scribbleArea.penColor = newColor
        end
    end
    
    def penWidth()
        ok = Qt::Boolean.new
        newWidth = Qt::InputDialog::getInteger(self, tr("Scribble"),
                                                tr("Select pen width:"),
                                                @scribbleArea.penWidth(),
                                                1, 50, 1, ok)
        if ok
            @scribbleArea.penWidth = newWidth
        end
    end
    
    def about()
        Qt::MessageBox.about(self, tr("About Scribble"),
                tr("<p>The <b>Scribble</b> example shows how to use Qt::MainWindow as the " +
                "base widget for an application, and how to reimplement some of " +
                "Qt::Widget's event handlers to receive the events generated for " +
                "the application's widgets:</p><p> We reimplement the mouse event " +
                "handlers to facilitate drawing, the paint event handler to " +
                "update the application and the resize event handler to optimize " +
                "the application's appearance. In addition we reimplement the " +
                "close event handler to intercept the close events before " +
                "terminating the application.</p><p> The example also demonstrates " +
                "how to use Qt::Painter to draw an image in real time, as well as " +
                "to repaint widgets.</p>"))
    end
    
    def createActions()
        @openAct = Qt::Action.new(tr("&Open..."), self)
        @openAct.shortcut = Qt::KeySequence.new(tr("Ctrl+O"))
        connect(@openAct, SIGNAL('triggered()'), self, SLOT('open()'))
    
        Qt::ImageWriter.supportedImageFormats().each do |format|
            text = tr("%s..." % format.upcase)
    
            action = Qt::Action.new(text, self)
            action.data = Qt::Variant.new(format)
            connect(action, SIGNAL('triggered()'), self, SLOT('save()'))
            @saveAsActs.push action
        end
    
        @exitAct = Qt::Action.new(tr("E&xit"), self)
        @exitAct.shortcut = Qt::KeySequence.new(tr("Ctrl+Q"))
        connect(@exitAct, SIGNAL('triggered()'), self, SLOT('close()'))
    
        @penColorAct = Qt::Action.new(tr("&Pen Color..."), self)
        connect(@penColorAct, SIGNAL('triggered()'), self, SLOT('penColor()'))
    
        @penWidthAct = Qt::Action.new(tr("Pen &Width..."), self)
        connect(@penWidthAct, SIGNAL('triggered()'), self, SLOT('penWidth()'))
    
        @clearScreenAct = Qt::Action.new(tr("&Clear Screen"), self)
        @clearScreenAct.shortcut = Qt::KeySequence.new(tr("Ctrl+L"))
        connect(@clearScreenAct, SIGNAL('triggered()'),
                @scribbleArea, SLOT('clearImage()'))
    
        @aboutAct = Qt::Action.new(tr("&About"), self)
        connect(@aboutAct, SIGNAL('triggered()'), self, SLOT('about()'))
    
        @aboutQtAct = Qt::Action.new(tr("About &Qt"), self)
        connect(@aboutQtAct, SIGNAL('triggered()'), $qApp, SLOT('aboutQt()'))
    end
    
    def createMenus()
        @saveAsMenu = Qt::Menu.new(tr("&Save As"), self)
        @saveAsActs.each do |action|
            @saveAsMenu.addAction(action)
        end

        @fileMenu = Qt::Menu.new(tr("&File"), self) do |f|
            f.addAction(@openAct)
            f.addMenu(@saveAsMenu)
            f.addSeparator()
            f.addAction(@exitAct)
        end
    
        @optionMenu = Qt::Menu.new(tr("&Options"), self) do |o|
            o.addAction(@penColorAct)
            o.addAction(@penWidthAct)
            o.addSeparator()
            o.addAction(@clearScreenAct)
        end
    
        @helpMenu = Qt::Menu.new(tr("&Help"), self) do |h|
            h.addAction(@aboutAct)
            h.addAction(@aboutQtAct)
        end
    
        menuBar().addMenu(@fileMenu)
        menuBar().addMenu(@optionMenu)
        menuBar().addMenu(@helpMenu)
    end
    
    def maybeSave()
        if @scribbleArea.modified?
            ret = Qt::MessageBox::warning(self, tr("Scribble"),
                            tr("The image has been modified.\n" +
                                "Do you want to save your changes?"),
                            Qt::MessageBox::Yes | Qt::MessageBox::Default,
                            Qt::MessageBox::No,
                            Qt::MessageBox::Cancel | Qt::MessageBox::Escape)
            if ret == Qt::MessageBox::Yes
                return saveFile("png")
            elsif ret == Qt::MessageBox::Cancel
                return false
            end
        end
        return true
    end
    
    def saveFile(fileFormat)
        initialPath = Qt::Dir.currentPath() + "/untitled." + fileFormat
    
        fileName = Qt::FileDialog.getSaveFileName(self, tr("Save As"),
                                initialPath,
                                tr("%s Files (*.%s);;All Files (*)" %
                                        [fileFormat.upcase, fileFormat] ) )
        if fileName.nil?
            return false
        else
            return @scribbleArea.saveImage(fileName, fileFormat)
        end
    end
end
