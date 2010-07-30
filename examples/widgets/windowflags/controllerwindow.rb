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
    
require 'previewwindow.rb'

class ControllerWindow < Qt::Widget
    
    slots 'updatePreview()'
    
    def initialize(parent = nil)
        super(parent)
        @previewWindow = PreviewWindow.new(self)
    
        createTypeGroupBox()
        createHintsGroupBox()
    
        @quitButton = Qt::PushButton.new(tr("&Quit"))
        connect(@quitButton, SIGNAL('clicked()'), $qApp, SLOT('quit()'))
    
        bottomLayout = Qt::HBoxLayout.new do |b|
        	b.addStretch()
        	b.addWidget(@quitButton)
		end
    
        mainLayout = Qt::VBoxLayout.new do |m|
			m.addWidget(@typeGroupBox)
			m.addWidget(@hintsGroupBox)
			m.addLayout(bottomLayout)
		end

        setLayout(mainLayout)
    
        setWindowTitle(tr("Window Flags"))
        updatePreview()
    end
    
    def updatePreview()
        flags = Qt::Enum.new(0, "Qt::WindowFlags")
    
        if @windowRadioButton.checked?
            flags = Qt::WindowType
        elsif @dialogRadioButton.checked?
            flags = Qt::DialogType
        elsif @sheetRadioButton.checked?
            flags = Qt::SheetType
        elsif @drawerRadioButton.checked?
            flags = Qt::DrawerType
        elsif @popupRadioButton.checked?
            flags = Qt::PopupType
        elsif @toolRadioButton.checked?
            flags = Qt::ToolType
        elsif @toolTipRadioButton.checked?
            flags = Qt::ToolTipType
        elsif @splashScreenRadioButton.checked?
            flags = Qt::SplashScreenType
        end
    
        if @msWindowsFixedSizeDialogCheckBox.checked?
            flags |= Qt::MSWindowsFixedSizeDialogHint.to_i
        end
        if @x11BypassWindowManagerCheckBox.checked?
            flags |= Qt::X11BypassWindowManagerHint.to_i
        end
        if @framelessWindowCheckBox.checked?
            flags |= Qt::FramelessWindowHint.to_i
        end
        if @windowTitleCheckBox.checked?
            flags |= Qt::WindowTitleHint.to_i
        end
        if @windowSystemMenuCheckBox.checked?
            flags |= Qt::WindowSystemMenuHint.to_i
        end
        if @windowMinimizeButtonCheckBox.checked?
            flags |= Qt::WindowMinimizeButtonHint.to_i
        end
        if @windowMaximizeButtonCheckBox.checked?
            flags |= Qt::WindowMaximizeButtonHint.to_i
        end
        if @windowContextHelpButtonCheckBox.checked?
            flags |= Qt::WindowContextHelpButtonHint.to_i
        end
        if @windowShadeButtonCheckBox.checked?
            flags |= Qt::WindowShadeButtonHint.to_i
        end
        if @windowStaysOnTopCheckBox.checked?
            flags |= Qt::WindowStaysOnTopHint.to_i
        end

        @previewWindow.setWindowFlags(flags)
        @previewWindow.show()
    
        pos = @previewWindow.pos()
        if pos.x < 0
            pos.x = 0
        end
        if pos.y < 0
            pos.y = 0
        end
        @previewWindow.move(pos)
    end
    
    def createTypeGroupBox()
        @typeGroupBox = Qt::GroupBox.new(tr("Type"))
    
        @windowRadioButton = createRadioButton(tr("Window"))
        @dialogRadioButton = createRadioButton(tr("Dialog"))
        @sheetRadioButton = createRadioButton(tr("Sheet"))
        @drawerRadioButton = createRadioButton(tr("Drawer"))
        @popupRadioButton = createRadioButton(tr("Popup"))
        @toolRadioButton = createRadioButton(tr("Tool"))
        @toolTipRadioButton = createRadioButton(tr("Tooltip"))
        @splashScreenRadioButton = createRadioButton(tr("Splash screen"))
        @windowRadioButton.checked = true
    
        layout = Qt::GridLayout.new do |l|
            l.addWidget(@windowRadioButton, 0, 0)
            l.addWidget(@dialogRadioButton, 1, 0)
            l.addWidget(@sheetRadioButton, 2, 0)
            l.addWidget(@drawerRadioButton, 3, 0)
            l.addWidget(@popupRadioButton, 0, 1)
            l.addWidget(@toolRadioButton, 1, 1)
            l.addWidget(@toolTipRadioButton, 2, 1)
            l.addWidget(@splashScreenRadioButton, 3, 1)
        end

        @typeGroupBox.layout = layout
    end
    
    def createHintsGroupBox()
        @hintsGroupBox = Qt::GroupBox.new(tr("Hints"))
    
        @msWindowsFixedSizeDialogCheckBox =
                createCheckBox(tr("MS Windows fixed size dialog"))
        @x11BypassWindowManagerCheckBox =
                createCheckBox(tr("X11 bypass window manager"))
        @framelessWindowCheckBox = createCheckBox(tr("Frameless window"))
        @windowTitleCheckBox = createCheckBox(tr("Window title"))
        @windowSystemMenuCheckBox = createCheckBox(tr("Window system menu"))
        @windowMinimizeButtonCheckBox = createCheckBox(tr("Window minimize button"))
        @windowMaximizeButtonCheckBox = createCheckBox(tr("Window maximize button"))
        @windowContextHelpButtonCheckBox =
                createCheckBox(tr("Window context help button"))
        @windowShadeButtonCheckBox = createCheckBox(tr("Window shade button"))
        @windowStaysOnTopCheckBox = createCheckBox(tr("Window stays on top"))
    
        layout = Qt::GridLayout.new do |l|
            l.addWidget(@msWindowsFixedSizeDialogCheckBox, 0, 0)
            l.addWidget(@x11BypassWindowManagerCheckBox, 1, 0)
            l.addWidget(@framelessWindowCheckBox, 2, 0)
            l.addWidget(@windowTitleCheckBox, 3, 0)
            l.addWidget(@windowSystemMenuCheckBox, 4, 0)
            l.addWidget(@windowMinimizeButtonCheckBox, 0, 1)
            l.addWidget(@windowMaximizeButtonCheckBox, 1, 1)
            l.addWidget(@windowContextHelpButtonCheckBox, 2, 1)
            l.addWidget(@windowShadeButtonCheckBox, 3, 1)
            l.addWidget(@windowStaysOnTopCheckBox, 4, 1)
        end

        @hintsGroupBox.layout = layout
    end
    
    def createCheckBox(text)
        checkBox = Qt::CheckBox.new(text)
        connect(checkBox, SIGNAL('clicked()'), self, SLOT('updatePreview()'))
        return checkBox
    end
    
    def createRadioButton(text)
        button = Qt::RadioButton.new(text)
        connect(button, SIGNAL('clicked()'), self, SLOT('updatePreview()'))
        return button
    end
end
