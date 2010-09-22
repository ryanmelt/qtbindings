=begin
**
** Copyright (C) 2004-2005 Trolltech AS. All rights reserved.
**
** This file is part of the example classes of the Qt Toolkit.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** self file.  Please review the following information to ensure GNU
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

require './iconpreviewarea.rb'
require './iconsizespinbox.rb'
require './imagedelegate.rb'

class MainWindow < Qt::MainWindow

    slots   'about()',
            'changeStyle(bool)',
            'changeSize()',
            'changeIcon()',
            'addImage()',
            'removeAllImages()'

    def initialize()
		super
        @centralWidget = Qt::Widget.new
        setCentralWidget(@centralWidget)
    
        createPreviewGroupBox()
        createImagesGroupBox()
        createIconSizeGroupBox()
    
        createActions()
        createMenus()
        createContextMenu()
    
        mainLayout = Qt::GridLayout.new
        mainLayout.addWidget(@imagesGroupBox, 0, 0)
        mainLayout.addWidget(@iconSizeGroupBox, 1, 0)
        mainLayout.addWidget(@previewGroupBox, 0, 1, 2, 1)
        @centralWidget.layout = mainLayout
    
        setWindowTitle(tr("Icons"))
        checkCurrentStyle()
        @otherRadioButton.click()
        resize(860, 400)
    end
    
    def about()
        Qt::MessageBox.about(self, tr("About Icons"),
                tr("The <b>Icons</b> example illustrates how Qt renders an icon in " +
                "different modes (active, normal, and disabled) and states (on " +
                "and off) based on a set of images."))
    end
    
    def changeStyle(checked)
        if !checked
            return
        end
    
        action = sender()
        style = Qt::StyleFactory.create(action.data().toString())
        Qt::Application.style = style
    
        @smallRadioButton.text = tr("Small (%d x %d" % 
                [    style.pixelMetric(Qt::Style::PM_SmallIconSize),
                    style.pixelMetric(Qt::Style::PM_SmallIconSize) ] )
        @largeRadioButton.text = tr("Large (%d x %d" % 
                [    style.pixelMetric(Qt::Style::PM_LargeIconSize),
                    style.pixelMetric(Qt::Style::PM_LargeIconSize) ] )
        @toolBarRadioButton.text = tr("Toolbars (%d x %d" % 
                [    style.pixelMetric(Qt::Style::PM_ToolBarIconSize),
                    style.pixelMetric(Qt::Style::PM_ToolBarIconSize) ] )
        @listViewRadioButton.text = tr("List views (%d x %d" % 
                [    style.pixelMetric(Qt::Style::PM_ListViewIconSize),
                    style.pixelMetric(Qt::Style::PM_ListViewIconSize) ] )
        @iconViewRadioButton.text = tr("Icon views (%d x %d" % 
                [    style.pixelMetric(Qt::Style::PM_IconViewIconSize),
                    style.pixelMetric(Qt::Style::PM_IconViewIconSize) ] )
    
        changeSize()
    end
    
    def changeSize()
        if @otherRadioButton.checked?
            extent = @otherSpinBox.value
        else
            if @smallRadioButton.checked?
                metric = Qt::Style::PM_SmallIconSize
            elsif @largeRadioButton.checked?
                metric = Qt::Style::PM_LargeIconSize
            elsif @toolBarRadioButton.checked?
                metric = Qt::Style::PM_ToolBarIconSize
            elsif @listViewRadioButton.checked?
                metric = Qt::Style::PM_ListViewIconSize
            else
                metric = Qt::Style::PM_IconViewIconSize
            end
            extent = Qt::Application::style().pixelMetric(metric)
        end

        @previewArea.size = Qt::Size.new(extent, extent)
        @otherSpinBox.enabled = @otherRadioButton.checked?
    end
    
    def changeIcon()
		icon = Qt::Icon.new
        (0...@imagesTable.rowCount).each do |row|
            item0 = @imagesTable.item(row, 0)
            item1 = @imagesTable.item(row, 1)
            item2 = @imagesTable.item(row, 2)
    
            if item0.checkState() == Qt::Checked
                if item1.text() == tr("Normal")
                    mode = Qt::Icon::Normal
                elsif item1.text() == tr("Active")
                    mode = Qt::Icon::Active
                else
                    mode = Qt::Icon::Disabled
                end
    
                if item2.text() == tr("On")
                    state = Qt::Icon::On
                else
                    state = Qt::Icon::Off
                end
    
                fileName = item0.data(Qt::UserRole).toString()
                image = Qt::Image.new(fileName)
                if !image.nil?
                    icon.addPixmap(Qt::Pixmap.fromImage(image), mode, state)
                end
            end
        end
        @previewArea.icon = icon
    end
    
    def addImage()
        fileNames = Qt::FileDialog.getOpenFileNames(self,
                                        tr("Open Images"), "",
                                        tr("Images (*.png *.xpm *.jpg);;" +
                                        "All Files (*)") )
        if !fileNames.nil?
            fileNames.each do |fileName|
                row = @imagesTable.rowCount()
                @imagesTable.rowCount = row + 1
    
                imageName = Qt::FileInfo.new(fileName).baseName()
                item0 = Qt::TableWidgetItem.new(imageName)
                item0.setData(Qt::UserRole, Qt::Variant.new(fileName))
                item0.flags &= ~Qt::ItemIsEditable
    
                item1 = Qt::TableWidgetItem.new(tr("Normal"))
                item2 = Qt::TableWidgetItem.new(tr("Off"))
    
                if @guessModeStateAct.checked?
                    if fileName.include?("_act")
                        item1.text = tr("Active")
                    elsif fileName.include?("_dis")
                        item1.text = tr("Disabled")
                    end
    
                    if fileName.include?("_on")
                        item2.text = tr("On")
                    end
                end
    
                @imagesTable.setItem(row, 0, item0)
                @imagesTable.setItem(row, 1, item1)
                @imagesTable.setItem(row, 2, item2)
                @imagesTable.openPersistentEditor(item1)
                @imagesTable.openPersistentEditor(item2)
    
                item0.checkState = Qt::Checked
            end
        end
    end
    
    def removeAllImages()
        @imagesTable.rowCount = 0
        changeIcon()
    end
    
    def createPreviewGroupBox()
        @previewGroupBox = Qt::GroupBox.new(tr("Preview"))
    
        @previewArea = IconPreviewArea.new
    
        layout = Qt::VBoxLayout.new
        layout.addWidget(@previewArea)
        @previewGroupBox.layout = layout
    end
    
    def createImagesGroupBox()
        @imagesGroupBox = Qt::GroupBox.new(tr("Images"))
        @imagesGroupBox.setSizePolicy(Qt::SizePolicy::Expanding,
                                    Qt::SizePolicy::Expanding)
    
        labels = []
        labels << tr("Image") << tr("Mode") << tr("State")
    
        @imagesTable = Qt::TableWidget.new
        @imagesTable.setSizePolicy(Qt::SizePolicy::Expanding, Qt::SizePolicy::Ignored)
        @imagesTable.selectionMode = Qt::AbstractItemView::NoSelection
        @imagesTable.columnCount = 3
        @imagesTable.horizontalHeaderLabels = labels
        @imagesTable.itemDelegate = ImageDelegate.new(self)
    
        @imagesTable.horizontalHeader().resizeSection(0, 160)
        @imagesTable.horizontalHeader().resizeSection(1, 80)
        @imagesTable.horizontalHeader().resizeSection(2, 80)
        @imagesTable.verticalHeader().hide()
    
        connect(@imagesTable, SIGNAL('itemChanged(QTableWidgetItem*)'),
                self, SLOT('changeIcon()'))
    
        layout = Qt::VBoxLayout.new
        layout.addWidget(@imagesTable)
        @imagesGroupBox.layout = layout
    end
    
    def createIconSizeGroupBox()
        @iconSizeGroupBox = Qt::GroupBox.new(tr("Icon Size"))
    
        @smallRadioButton = Qt::RadioButton.new
        @largeRadioButton = Qt::RadioButton.new
        @toolBarRadioButton = Qt::RadioButton.new
        @listViewRadioButton = Qt::RadioButton.new
        @iconViewRadioButton = Qt::RadioButton.new
        @otherRadioButton = Qt::RadioButton.new(tr("Other:"))
    
        @otherSpinBox = IconSizeSpinBox.new
        @otherSpinBox.range = 8..128
        @otherSpinBox.value = 64
    
        connect(@toolBarRadioButton, SIGNAL('toggled(bool)'),
                self, SLOT('changeSize()'))
        connect(@listViewRadioButton, SIGNAL('toggled(bool)'),
                self, SLOT('changeSize()'))
        connect(@iconViewRadioButton, SIGNAL('toggled(bool)'),
                self, SLOT('changeSize()'))
        connect(@smallRadioButton, SIGNAL('toggled(bool)'), self, SLOT('changeSize()'))
        connect(@largeRadioButton, SIGNAL('toggled(bool)'), self, SLOT('changeSize()'))
        connect(@otherRadioButton, SIGNAL('toggled(bool)'), self, SLOT('changeSize()'))
        connect(@otherSpinBox, SIGNAL('valueChanged(int)'), self, SLOT('changeSize()'))
    
        otherSizeLayout = Qt::HBoxLayout.new
        otherSizeLayout.addWidget(@otherRadioButton)
        otherSizeLayout.addWidget(@otherSpinBox)
    
        layout = Qt::GridLayout.new
        layout.addWidget(@smallRadioButton, 0, 0)
        layout.addWidget(@largeRadioButton, 1, 0)
        layout.addWidget(@toolBarRadioButton, 2, 0)
        layout.addWidget(@listViewRadioButton, 0, 1)
        layout.addWidget(@iconViewRadioButton, 1, 1)
        layout.addLayout(otherSizeLayout, 2, 1)
        @iconSizeGroupBox.layout = layout
    end
    
    def createActions()
        @addImageAct = Qt::Action.new(tr("&Add Image..."), self)
        @addImageAct.shortcut = Qt::KeySequence.new(tr("Ctrl+A"))
        connect(@addImageAct, SIGNAL('triggered()'), self, SLOT('addImage()'))
    
        @removeAllImagesAct = Qt::Action.new(tr("&Remove All Images"), self)
        @removeAllImagesAct.shortcut = Qt::KeySequence.new(tr("Ctrl+R"))
        connect(@removeAllImagesAct, SIGNAL('triggered()'),
                self, SLOT('removeAllImages()'))
    
        @exitAct = Qt::Action.new(tr("&Quit"), self)
        @exitAct.shortcut = Qt::KeySequence.new(tr("Ctrl+Q"))
        connect(@exitAct, SIGNAL('triggered()'), self, SLOT('close()'))
    
        @styleActionGroup = Qt::ActionGroup.new(self)
        
        Qt::StyleFactory::keys().each do |styleName|
            action = Qt::Action.new(@styleActionGroup)
            action.text = tr("%s Style" % styleName)
            action.data = Qt::Variant.new(styleName)
            action.checkable = true
            connect(action, SIGNAL('triggered(bool)'), self, SLOT('changeStyle(bool)'))
        end
    
        @guessModeStateAct = Qt::Action.new(tr("&Guess Image Mode/State"), self)
        @guessModeStateAct.checkable = true
        @guessModeStateAct.checked = true
    
        @aboutAct = Qt::Action.new(tr("&About"), self)
        connect(@aboutAct, SIGNAL('triggered()'), self, SLOT('about()'))
    
        @aboutQtAct = Qt::Action.new(tr("About &Qt"), self)
        connect(@aboutQtAct, SIGNAL('triggered()'), $qApp, SLOT('aboutQt()'))
    end
    
    def createMenus()
        @fileMenu = menuBar().addMenu(tr("&File"))
        @fileMenu.addAction(@addImageAct)
        @fileMenu.addAction(@removeAllImagesAct)
        @fileMenu.addSeparator()
        @fileMenu.addAction(@exitAct)
    
        @viewMenu = menuBar().addMenu(tr("&View"))

        @styleActionGroup.actions().each do |action|
            @viewMenu.addAction(action)
        end
        @viewMenu.addSeparator()
        @viewMenu.addAction(@guessModeStateAct)
    
        menuBar().addSeparator()
    
        @helpMenu = menuBar().addMenu(tr("&Help"))
        @helpMenu.addAction(@aboutAct)
        @helpMenu.addAction(@aboutQtAct)
    end
    
    def createContextMenu()
        @imagesTable.contextMenuPolicy = Qt::ActionsContextMenu
        @imagesTable.addAction(@addImageAct)
        @imagesTable.addAction(@removeAllImagesAct)
    end
    
    def checkCurrentStyle()
        @styleActionGroup.actions().each do |action|
            styleName = action.data().toString()
            candidate = Qt::StyleFactory.create(styleName)

            if candidate.metaObject().className() ==
               Qt::Application.style().metaObject().className()
                action.trigger()
                return
            end
        end
    end
end
