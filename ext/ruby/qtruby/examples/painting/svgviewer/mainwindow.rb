=begin
**
** Copyright (C) 2004-2006 Trolltech AS. All rights reserved.
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
    
require 'svgwindow.rb'
    
class MainWindow < Qt::MainWindow
        
    slots 'openFile()',
          'renderer=(QAction*)'
    
    def initialize()
        super()
        @area = SvgWindow.new
    
        fileMenu = Qt::Menu.new(tr("&File"), self)
        openAction = fileMenu.addAction(tr("&Open..."))
        openAction.shortcut = Qt::KeySequence.new( Qt::KeySequence.new(tr("Ctrl+O")))
        quitAction = fileMenu.addAction(tr("E&xit"))
        quitAction.shortcut = Qt::KeySequence.new( Qt::KeySequence.new(tr("Ctrl+Q")))
    
        menuBar().addMenu(fileMenu)
    
        rendererMenu = Qt::Menu.new(tr("&Renderer"), self)
        @nativeAction = rendererMenu.addAction(tr("&Native"))
        @nativeAction.checkable = true
        @nativeAction.checked = true
        @nativeAction.objectName = "nativeAction"
        @glAction = rendererMenu.addAction(tr("&OpenGL"))
        @glAction.checkable = true
        @glAction.objectName = "glAction"
        @imageAction = rendererMenu.addAction(tr("&Image"))
        @imageAction.checkable = true
        @imageAction.objectName = "imageAction"
    
        rendererGroup = Qt::ActionGroup.new(self)
        rendererGroup.addAction(@nativeAction)
        rendererGroup.addAction(@glAction)
        rendererGroup.addAction(@imageAction)
    
        menuBar().addMenu(rendererMenu)
    
        connect(openAction, SIGNAL(:triggered), self, SLOT(:openFile))
        connect(quitAction, SIGNAL(:triggered), $qApp, SLOT(:quit))
        connect(rendererGroup, SIGNAL('triggered(QAction*)'),
                self, SLOT('renderer=(QAction*)'))
    
        setCentralWidget(@area)
        setWindowTitle(tr("SVG Viewer"))
    end
    
    def openFile(path = nil)
        if path.nil?
            fileName = Qt::FileDialog.getOpenFileName(self, tr("Open SVG File"),
                                                    @currentPath, "*.svg")
        else
            fileName = path
        end

        if !fileName.empty?
            @area.openFile(fileName)
            if !fileName.slice(0, 2) == ":/"
                @currentPath = fileName
                setWindowTitle(tr("%s - SVGViewer" % @currentPath))
            end
        end
    end
    
    def renderer=(action)
        if action.objectName == "nativeAction"
            @area.renderer = SvgWindow::Native
        elsif action.objectName == "glAction"
            @area.renderer = SvgWindow::OpenGL
        elsif action.objectName == "imageAction"
            @area.renderer = SvgWindow::Image
        end
    end
end
