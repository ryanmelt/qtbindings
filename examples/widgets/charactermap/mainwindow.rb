=begin
**
** Copyright (C) 2005-2005 Trolltech AS. All rights reserved.
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

require './characterwidget.rb'

class MainWindow < Qt::MainWindow

    slots   'findStyles()', 'insertCharacter(const QString&)',
            'updateClipboard()'

    def initialize()
        super
        centralWidget = Qt::Widget.new

        fontLabel = Qt::Label.new(tr("Font:"))
        @fontCombo = Qt::ComboBox.new
        styleLabel = Qt::Label.new(tr("Style:"))
        @styleCombo = Qt::ComboBox.new

        @scrollArea = Qt::ScrollArea.new
        @characterWidget = CharacterWidget.new
        @scrollArea.widget = @characterWidget

        findFonts()
        findStyles()

        @lineEdit = Qt::LineEdit.new
        @clipboardButton = Qt::PushButton.new(tr("&To clipboard"))

        @clipboard = Qt::Application.clipboard

        connect(@fontCombo, SIGNAL('activated(int)'),
                self, SLOT('findStyles()'))
        connect(@fontCombo, SIGNAL('activated(const QString&)'),
                @characterWidget, SLOT('updateFont(const QString&)'))
        connect(@styleCombo, SIGNAL('activated(const QString&)'),
                @characterWidget, SLOT('updateStyle(const QString&)'))
        connect(@characterWidget, SIGNAL('characterSelected(const QString&)'),
                self, SLOT('insertCharacter(const QString&)'))
        connect(@clipboardButton, SIGNAL('clicked()'), self, SLOT('updateClipboard()'))

        controlsLayout = Qt::HBoxLayout.new
        controlsLayout.addWidget(fontLabel)
        controlsLayout.addWidget(@fontCombo, 1)
        controlsLayout.addWidget(styleLabel)
        controlsLayout.addWidget(@styleCombo, 1)
        controlsLayout.addStretch(1)

        lineLayout = Qt::HBoxLayout.new
        lineLayout.addWidget(@lineEdit, 1)
        lineLayout.addSpacing(12)
        lineLayout.addWidget(@clipboardButton)

        centralLayout = Qt::VBoxLayout.new
        centralLayout.addLayout(controlsLayout)
        centralLayout.addWidget(@scrollArea, 1)
        centralLayout.addSpacing(4)
        centralLayout.addLayout(lineLayout)
        centralWidget.layout = centralLayout

        setCentralWidget(centralWidget)
        setWindowTitle(tr("Character Map"))
    end

    def findFonts()
        fontDatabase = Qt::FontDatabase.new
        @fontCombo.clear

        fontDatabase.families().each do |family|
            @fontCombo.addItem(family)
        end
    end

    def findStyles()
        fontDatabase = Qt::FontDatabase.new
        currentItem = @styleCombo.currentText()
        @styleCombo.clear()

        fontDatabase.styles(@fontCombo.currentText()).each do |style|
            @styleCombo.addItem(style)
        end

        if @styleCombo.findText(currentItem) == -1
            @styleCombo.currentIndex = 0
        end
    end

    def insertCharacter(character)
        @lineEdit.insert(character)
    end

    def updateClipboard()
        @clipboard.setText(@lineEdit.text, Qt::Clipboard::Clipboard)
        @clipboard.setText(@lineEdit.text, Qt::Clipboard::Selection)
    end
end
