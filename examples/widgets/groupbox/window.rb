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

class Window < Qt::Widget

    def initialize(parent = nil)
        super(parent)
        grid = Qt::GridLayout.new
        grid.addWidget(createFirstExclusiveGroup(), 0, 0)
        grid.addWidget(createSecondExclusiveGroup(), 1, 0)
        grid.addWidget(createNonExclusiveGroup(), 0, 1)
        grid.addWidget(createPushButtonGroup(), 1, 1)
        setLayout(grid)
    
        setWindowTitle(tr("Group Box"))
        resize(480, 320)
    end
    
    def createFirstExclusiveGroup()
        groupBox = Qt::GroupBox.new(tr("Exclusive Radio Buttons"))
    
        radio1 = Qt::RadioButton.new(tr("&Radio button 1"))
        radio2 = Qt::RadioButton.new(tr("R&adio button 2"))
        radio3 = Qt::RadioButton.new(tr("Ra&dio button 3"))
    
        radio1.checked = true
    
        vbox = Qt::VBoxLayout.new
        vbox.addWidget(radio1)
        vbox.addWidget(radio2)
        vbox.addWidget(radio3)
        vbox.addStretch(1)
        groupBox.layout = vbox
    
        return groupBox
    end
    
    def createSecondExclusiveGroup()
        groupBox = Qt::GroupBox.new(tr("E&xclusive Radio Buttons"))
        groupBox.checkable = true
        groupBox.checked = false
    
        radio1 = Qt::RadioButton.new(tr("Rad&io button 1"))
        radio2 = Qt::RadioButton.new(tr("Radi&o button 2"))
        radio3 = Qt::RadioButton.new(tr("Radio &button 3"))
        radio1.checked = true
        checkBox = Qt::CheckBox.new(tr("Ind&ependent checkbox"))
        checkBox.checked = true
    
        vbox = Qt::VBoxLayout.new
        vbox.addWidget(radio1)
        vbox.addWidget(radio2)
        vbox.addWidget(radio3)
        vbox.addWidget(checkBox)
        vbox.addStretch(1)
        groupBox.layout = vbox
    
        return groupBox
    end
    
    def createNonExclusiveGroup()
        groupBox = Qt::GroupBox.new(tr("Non-Exclusive Checkboxes"))
        groupBox.flat = true
    
        checkBox1 = Qt::CheckBox.new(tr("&Checkbox 1"))
        checkBox2 = Qt::CheckBox.new(tr("C&heckbox 2"))
        checkBox2.checked = true
        tristateBox = Qt::CheckBox.new(tr("Tri-&state button"))
        tristateBox.tristate = true
        tristateBox.checkState = Qt::PartiallyChecked
    
        vbox = Qt::VBoxLayout.new
        vbox.addWidget(checkBox1)
        vbox.addWidget(checkBox2)
        vbox.addWidget(tristateBox)
        vbox.addStretch(1)
        groupBox.layout = vbox
    
        return groupBox
    end
    
    def createPushButtonGroup()
        groupBox = Qt::GroupBox.new(tr("&Push Buttons"))
        groupBox.checkable = true
        groupBox.checked = true
    
        pushButton = Qt::PushButton.new(tr("&Normal Button"))
        toggleButton = Qt::PushButton.new(tr("&Toggle Button"))
        toggleButton.checkable = true
        toggleButton.checked = true
        flatButton = Qt::PushButton.new(tr("&Flat Button"))
        flatButton.flat = true
    
        popupButton = Qt::PushButton.new(tr("Pop&up Button"))
        menu = Qt::Menu.new(self)
        menu.addAction(tr("&First Item"))
        menu.addAction(tr("&Second Item"))
        menu.addAction(tr("&Third Item"))
        menu.addAction(tr("F&ourth Item"))
        popupButton.menu = menu
    
        vbox = Qt::VBoxLayout.new
        vbox.addWidget(pushButton)
        vbox.addWidget(toggleButton)
        vbox.addWidget(flatButton)
        vbox.addWidget(popupButton)
        vbox.addStretch(1)
        groupBox.layout = vbox
    
        return groupBox
    end
end
