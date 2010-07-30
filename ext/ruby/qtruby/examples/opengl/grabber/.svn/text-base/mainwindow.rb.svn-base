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
    
require 'glwidget.rb'

class MainWindow < Qt::MainWindow
        
    slots    'renderIntoPixmap()',
            'grabFrameBuffer()',
            'clearPixmap()',
            'about()'
    
    def initialize(parent = nil)
        super
        @centralWidget = Qt::Widget.new
        self.centralWidget = @centralWidget
    
        @glWidget = GLWidget.new(self)
        @pixmapLabel = Qt::Label.new
    
        @glWidgetArea = Qt::ScrollArea.new do |a|
            a.widget = @glWidget
            a.widgetResizable = true
            a.horizontalScrollBarPolicy = Qt::ScrollBarAlwaysOff
            a.verticalScrollBarPolicy = Qt::ScrollBarAlwaysOff
            a.setSizePolicy(Qt::SizePolicy::Ignored, Qt::SizePolicy::Ignored)
            a.setMinimumSize(50, 50)
        end
    
        @pixmapLabelArea = Qt::ScrollArea.new do |l|
            l.widget = @pixmapLabel
            l.setSizePolicy(Qt::SizePolicy::Ignored, Qt::SizePolicy::Ignored)
            l.setMinimumSize(50, 50)
        end
    
        @xSlider = createSlider(SIGNAL('xRotationChanged(int)'),
                               SLOT('setXRotation(int)'))
        @ySlider = createSlider(SIGNAL('yRotationChanged(int)'),
                               SLOT('setYRotation(int)'))
        @zSlider = createSlider(SIGNAL('zRotationChanged(int)'),
                               SLOT('setZRotation(int)'))
    
        createActions()
        createMenus()
    
        @centralWidget.layout = Qt::GridLayout.new do |c|
            c.addWidget(@glWidgetArea, 0, 0)
            c.addWidget(@pixmapLabelArea, 0, 1)
            c.addWidget(@xSlider, 1, 0, 1, 2)
            c.addWidget(@ySlider, 2, 0, 1, 2)
            c.addWidget(@zSlider, 3, 0, 1, 2)
        end
    
        @xSlider.value = 15 * 16
        @ySlider.value = 345 * 16
        @zSlider.value = 0 * 16
    
        setWindowTitle(tr("Grabber"))
        resize(400, 300)
    end
    
    def renderIntoPixmap()
        size = getSize()
        if size.valid?
            pixmap = @glWidget.renderPixmap(size.width(), size.height())
            setPixmap(pixmap)
        end
    end
    
    def grabFrameBuffer()
        image = @glWidget.grabFrameBuffer()
        setPixmap(Qt::Pixmap.fromImage(image))
    end
    
    def clearPixmap()
        setPixmap(Qt::Pixmap.new)
    end
    
    def about()
        Qt::MessageBox.about(self, tr("About Grabber"),
                tr("The <b>Grabber</b> example demonstrates two approaches for " +
                   "rendering OpenGL into a Qt pixmap."))
    end
    
    def createActions()
        @renderIntoPixmapAct = Qt::Action.new(tr("&Render into Pixmap..."), self)
        @renderIntoPixmapAct.shortcut = Qt::KeySequence.new( tr("Ctrl+R") )
        connect(@renderIntoPixmapAct, SIGNAL('triggered()'),
                self, SLOT('renderIntoPixmap()'))
    
        @grabFrameBufferAct = Qt::Action.new(tr("&Grab Frame Buffer"), self)
        @grabFrameBufferAct.shortcut = Qt::KeySequence.new( tr("Ctrl+G") )
        connect(@grabFrameBufferAct, SIGNAL('triggered()'),
                self, SLOT('grabFrameBuffer()'))
    
        @clearPixmapAct = Qt::Action.new(tr("&Clear Pixmap"), self)
        @clearPixmapAct.shortcut = Qt::KeySequence.new( tr("Ctrl+L") )
        connect(@clearPixmapAct, SIGNAL('triggered()'), self, SLOT('clearPixmap()'))
    
        @exitAct = Qt::Action.new(tr("E&xit"), self)
        @exitAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Q") )
        connect(@exitAct, SIGNAL('triggered()'), self, SLOT('close()'))
    
        @aboutAct = Qt::Action.new(tr("&About"), self)
        connect(@aboutAct, SIGNAL('triggered()'), self, SLOT('about()'))
    
        @aboutQtAct = Qt::Action.new(tr("About &Qt"), self)
        connect(@aboutQtAct, SIGNAL('triggered()'), $qApp, SLOT('aboutQt()'))
    end
    
    def createMenus()
        @fileMenu = menuBar().addMenu(tr("&File"))
        @fileMenu.addAction(@renderIntoPixmapAct)
        @fileMenu.addAction(@grabFrameBufferAct)
        @fileMenu.addAction(@clearPixmapAct)
        @fileMenu.addSeparator()
        @fileMenu.addAction(@exitAct)
    
        @helpMenu = menuBar().addMenu(tr("&Help"))
        @helpMenu.addAction(@aboutAct)
        @helpMenu.addAction(@aboutQtAct)
    end
    
    def createSlider(changedSignal, setterSlot)
        slider = Qt::Slider.new(Qt::Horizontal) do |s|
            s.range = 0..(360 * 16)
            s.singleStep = 16
            s.pageStep = 15 * 16
            s.tickInterval = 15 * 16
            s.tickPosition = Qt::Slider::TicksRight
        end
        connect(slider, SIGNAL('valueChanged(int)'), @glWidget, setterSlot)
        connect(@glWidget, changedSignal, slider, SLOT('setValue(int)'))
        return slider
    end
    
    def setPixmap(pixmap)
        @pixmapLabel.pixmap = pixmap
        size = pixmap.size()
        if size - Qt::Size.new(1, 0) == @pixmapLabelArea.maximumViewportSize
            size -= Qt::Size.new(1, 0)
        end
        @pixmapLabel.resize(size)
    end
    
    def getSize()
        ok = Qt::Boolean.new
        text = Qt::InputDialog.getText(self, tr("Grabber"),
                                             tr("Enter pixmap size:"),
                                             Qt::LineEdit::Normal,
                                             tr("%d x %d" % [@glWidget.width, @glWidget.height]),
                                             ok)
        if !ok
            return Qt::Size.new
        end
    
        if text =~ /([0-9]+) *x *([0-9]+)/
            width = $1.to_i
            height = $2.to_i
            if width > 0 && width < 2048 && height > 0 && height < 2048
                return Qt::Size.new(width, height)
            end
        end
    
        return @glWidget.size()
    end
end
