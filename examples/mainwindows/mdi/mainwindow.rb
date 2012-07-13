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
    
    
require './mdichild.rb'
    
class MainWindow < Qt::MainWindow
    
    slots   'newFile()',
            'open()',
            'save()',
            'saveAs()',
            'cut()',
            'copy()',
            'paste()',
            'about()',
            'updateMenus()',
            'updateWindowMenu()',
            'MdiChild *createMdiChild()',
            'switchLayoutDirection()',
            'setActiveSubWindow(QWidget*)'
     
    def initialize()
        super
        @mdiArea = Qt::MdiArea.new
        setCentralWidget(@mdiArea)
        connect(@mdiArea, SIGNAL('subWindowActivated(QMdiSubWindow*)'),
                self, SLOT('updateMenus()'))
        @windowMapper = Qt::SignalMapper.new(self)
        connect(@windowMapper, SIGNAL('mapped(QWidget*)'),
                self, SLOT('setActiveSubWindow(QWidget*)'))
    
        createActions()
        createMenus()
        createToolBars()
        createStatusBar()
        updateMenus()
    
        readSettings()
    
        setWindowTitle(tr("MDI"))
    end
    
    def closeEvent(event)
        @mdiArea.closeAllSubWindows()
        if activeMdiChild()
            event.ignore()
        else
            writeSettings()
            event.accept()
        end
    end
    
    def newFile()
        child = createMdiChild()
        child.newFile()
        child.show()
    end
    
    def open()
        fileName = Qt::FileDialog.getOpenFileName(self)
        if !fileName.nil?
            existing = findMdiChild(fileName)
            if !existing.nil?
                @mdiArea.setActiveSubWindow(existing)
                return
            end
    
            child = createMdiChild()
            if child.loadFile(fileName)
                statusBar().showMessage(tr("File loaded"), 2000)
                child.show()
            else
                child.close()
            end
        end
    end
    
    def save()
        if activeMdiChild() && activeMdiChild().save()
            statusBar().showMessage(tr("File saved"), 2000)
        end
    end
    
    def saveAs()
        if activeMdiChild() && activeMdiChild().saveAs()
            statusBar().showMessage(tr("File saved"), 2000)
        end
    end
    
    def cut()
        if activeMdiChild()
            activeMdiChild().cut()
        end
    end
    
    def copy()
        if activeMdiChild()
            activeMdiChild().copy()
        end
    end
    
    def paste()
        if activeMdiChild()
            activeMdiChild().paste()
        end
    end
    
    def about()
       Qt::MessageBox::about(self, tr("About MDI"),
                tr("The <b>MDI</b> example demonstrates how to write multiple " \
                   "document interface applications using Qt."))
    end
    
    def updateMenus()
        hasMdiChild = (activeMdiChild() != nil)
        @saveAct.enabled = hasMdiChild
        @saveAsAct.enabled = hasMdiChild
        @pasteAct.enabled = hasMdiChild
        @closeAct.enabled = hasMdiChild
        @closeAllAct.enabled = hasMdiChild
        @tileAct.enabled = hasMdiChild
        @cascadeAct.enabled = hasMdiChild
        @nextAct.enabled = hasMdiChild
        @previousAct.enabled = hasMdiChild
        @separatorAct.visible = hasMdiChild
    
        hasSelection = (activeMdiChild() &&
                             activeMdiChild().textCursor().hasSelection())
        @cutAct.enabled = hasSelection
        @copyAct.enabled = hasSelection
    end
    
    def updateWindowMenu()
        @windowMenu.clear()
        @windowMenu.addAction(@closeAct)
        @windowMenu.addAction(@closeAllAct)
        @windowMenu.addSeparator()
        @windowMenu.addAction(@tileAct)
        @windowMenu.addAction(@cascadeAct)
        @windowMenu.addSeparator()
        @windowMenu.addAction(@nextAct)
        @windowMenu.addAction(@previousAct)
        @windowMenu.addAction(@separatorAct)
    
        windows = @mdiArea.subWindowList()
        @separatorAct.visible = !windows.empty?
        for i in 0...windows.size
            child = windows[i].widget
    
            if i < 9
                text = tr("&%s %s" % [i + 1,
                                   child.userFriendlyCurrentFile()])
            else
                text = tr("%s %s" % [i + 1,
                                  child.userFriendlyCurrentFile()])
            end
            action  = @windowMenu.addAction(text)
            action.checkable = true
            action .checked = child == activeMdiChild()
            connect(action, SIGNAL('triggered()'), @windowMapper, SLOT('map()'))
            @windowMapper.setMapping(action, child)
        end
    end
    
    def createMdiChild()
        child = MdiChild.new
        @mdiArea.addSubWindow(child)
    
        connect(child, SIGNAL('copyAvailable(bool)'),
                @cutAct, SLOT('setEnabled(bool)'))
        connect(child, SIGNAL('copyAvailable(bool)'),
                @copyAct, SLOT('setEnabled(bool)'))
    
        return child
    end
    
    def createActions()
        @newAct = Qt::Action.new(Qt::Icon.new("images/new.png"), tr("&New"), self)
        @newAct.shortcut = Qt::KeySequence.new( tr("Ctrl+N"))
        @newAct.statusTip = tr("Create a file.new")
        connect(@newAct, SIGNAL('triggered()'), self, SLOT('newFile()'))
    
        @openAct = Qt::Action.new(Qt::Icon.new("images/open.png"), tr("&Open..."), self)
        @openAct.shortcut = Qt::KeySequence.new( tr("Ctrl+O"))
        @openAct.statusTip = tr("Open an existing file")
        connect(@openAct, SIGNAL('triggered()'), self, SLOT('open()'))
    
        @saveAct = Qt::Action.new(Qt::Icon.new("images/save.png"), tr("&Save"), self)
        @saveAct.shortcut = Qt::KeySequence.new( tr("Ctrl+S"))
        @saveAct.statusTip = tr("Save the document to disk")
        connect(@saveAct, SIGNAL('triggered()'), self, SLOT('save()'))
    
        @saveAsAct = Qt::Action.new(tr("Save &As..."), self)
        @saveAsAct.statusTip = tr("Save the document under a name.new")
        connect(@saveAsAct, SIGNAL('triggered()'), self, SLOT('saveAs()'))
    
        @exitAct = Qt::Action.new(tr("E&xit"), self)
        @exitAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Q"))
        @exitAct.statusTip = tr("Exit the application")
        connect(@exitAct, SIGNAL('triggered()'), $qApp, SLOT('closeAllWindows()'))
    
        @cutAct = Qt::Action.new(Qt::Icon.new("images/cut.png"), tr("Cu&t"), self)
        @cutAct.shortcut = Qt::KeySequence.new( tr("Ctrl+X"))
        @cutAct.setStatusTip(tr("Cut the current selection's contents to the " \
                                "clipboard"))
        connect(@cutAct, SIGNAL('triggered()'), self, SLOT('cut()'))
    
        @copyAct = Qt::Action.new(Qt::Icon.new("images/copy.png"), tr("&Copy"), self)
        @copyAct.shortcut = Qt::KeySequence.new( tr("Ctrl+C"))
        @copyAct.setStatusTip(tr("Copy the current selection's contents to the " \
                                 "clipboard"))
        connect(@copyAct, SIGNAL('triggered()'), self, SLOT('copy()'))
    
        @pasteAct = Qt::Action.new(Qt::Icon.new("images/paste.png"), tr("&Paste"), self)
        @pasteAct.shortcut = Qt::KeySequence.new( tr("Ctrl+V"))
        @pasteAct.setStatusTip(tr("Paste the clipboard's contents into the current " \
                                  "selection"))
        connect(@pasteAct, SIGNAL('triggered()'), self, SLOT('paste()'))
    
        @closeAct = Qt::Action.new(tr("Cl&ose"), self)
        @closeAct.shortcut = Qt::KeySequence.new( tr("Ctrl+F4"))
        @closeAct.statusTip = tr("Close the active window")
        connect(@closeAct, SIGNAL('triggered()'),
                @mdiArea, SLOT('closeActiveSubWindow()'))
    
        @closeAllAct = Qt::Action.new(tr("Close &All"), self)
        @closeAllAct.statusTip = tr("Close all the windows")
        connect(@closeAllAct, SIGNAL('triggered()'),
                @mdiArea, SLOT('closeAllSubWindows()'))
    
        @tileAct = Qt::Action.new(tr("&Tile"), self)
        @tileAct.statusTip = tr("Tile the windows")
        connect(@tileAct, SIGNAL('triggered()'), @mdiArea, SLOT('tileSubWindows()'))
    
        @cascadeAct = Qt::Action.new(tr("&Cascade"), self)
        @cascadeAct.statusTip = tr("Cascade the windows")
        connect(@cascadeAct, SIGNAL('triggered()'), @mdiArea, SLOT('cascadeSubWindows()'))
    
        @nextAct = Qt::Action.new(tr("Ne&xt"), self)
        @nextAct.shortcut = Qt::KeySequence.new( tr("Ctrl+F6"))
        @nextAct.statusTip = tr("Move the focus to the next window")
        connect(@nextAct, SIGNAL('triggered()'),
                @mdiArea, SLOT('activateNextSubWindow()'))
    
        @previousAct = Qt::Action.new(tr("Pre&vious"), self)
        @previousAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Shift+F6"))
        @previousAct.setStatusTip(tr("Move the focus to the previous " \
                                     "window"))
        connect(@previousAct, SIGNAL('triggered()'),
                @mdiArea, SLOT('activatePreviousSubWindow()'))
    
        @separatorAct = Qt::Action.new(self)
        @separatorAct.separator = true
    
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
        @fileMenu.addSeparator()
        action = @fileMenu.addAction(tr("Switch layout direction"))
        connect(action, SIGNAL('triggered()'), self, SLOT('switchLayoutDirection()'))
        @fileMenu.addAction(@exitAct)
    
        @editMenu = menuBar().addMenu(tr("&Edit"))
        @editMenu.addAction(@cutAct)
        @editMenu.addAction(@copyAct)
        @editMenu.addAction(@pasteAct)
    
        @windowMenu = menuBar().addMenu(tr("&Window"))
        updateWindowMenu();
        connect(@windowMenu, SIGNAL('aboutToShow()'), self, SLOT('updateWindowMenu()'))
    
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
        settings = Qt::Settings.new("Trolltech", "MDI Example")
        pos = settings.value("pos", Qt::Variant.new(Qt::Point.new(200, 200))).toPoint()
        size = settings.value("size", Qt::Variant.new(Qt::Size.new(400, 400))).toSize()
        move(pos)
        resize(size)
    end
    
    def writeSettings()
        settings = Qt::Settings.new("Trolltech", "MDI Example")
        settings.setValue("pos", Qt::Variant.new(pos()))
        settings.setValue("size", Qt::Variant.new(size()))
    end
    
    def activeMdiChild()
        if @mdiArea.activeSubWindow
            return @mdiArea.activeSubWindow.widget
        else
            return nil
        end
    end
    
    def findMdiChild(fileName)
        canonicalFilePath = Qt::FileInfo.new(fileName).canonicalFilePath()

        @mdiArea.subWindowList().each do |window|
            mdiChild = window.widget
            if mdiChild.currentFile() == canonicalFilePath
                return window
            end
        end
        return nil
    end
end
