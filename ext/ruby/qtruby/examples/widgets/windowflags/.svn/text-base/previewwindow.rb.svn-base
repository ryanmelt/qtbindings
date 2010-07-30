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
    
    
class PreviewWindow < Qt::Widget
    
    def initialize(parent = nil)
        super(parent)
        @textEdit = Qt::TextEdit.new
        @textEdit.readOnly = true
        @textEdit.lineWrapMode = Qt::TextEdit::NoWrap
    
        @closeButton = Qt::PushButton.new(tr("&Close"))
        connect(@closeButton, SIGNAL('clicked()'), self, SLOT('close()'))
    
        layout = Qt::VBoxLayout.new do |l|
            l.addWidget(@textEdit)
            l.addWidget(@closeButton)
        end

        setLayout(layout)
    
        setWindowTitle(tr("Preview"))
    end
    
    def setWindowFlags(flags)
        super(flags.to_i)
    
        type = (flags & Qt::WindowType_Mask.to_i)
        if type == Qt::WindowType
            text = "Qt::Window"
        elsif type == Qt::DialogType
            text = "Qt::Dialog"
        elsif type == Qt::SheetType
            text = "Qt::Sheet"
        elsif type == Qt::DrawerType
            text = "Qt::Drawer"
        elsif type == Qt::PopupType
            text = "Qt::Popup"
        elsif type == Qt::ToolType
            text = "Qt::Tool"
        elsif type == Qt::ToolTipType
            text = "Qt::ToolTip"
        elsif type == Qt::SplashScreenType
            text = "Qt::SplashScreen"
        end
    
        if (flags & Qt::MSWindowsFixedSizeDialogHint.to_i) != 0
            text += "\n| Qt::MSWindowsFixedSizeDialogHint"
        end
        if (flags & Qt::X11BypassWindowManagerHint.to_i) != 0
            text += "\n| Qt::X11BypassWindowManagerHint"
        end
        if (flags & Qt::FramelessWindowHint.to_i) != 0
            text += "\n| Qt::FramelessWindowHint"
        end
        if (flags & Qt::WindowTitleHint.to_i) != 0
            text += "\n| Qt::WindowTitleHint"
        end
        if (flags & Qt::WindowSystemMenuHint.to_i) != 0
            text += "\n| Qt::WindowSystemMenuHint"
        end
        if (flags & Qt::WindowMinimizeButtonHint.to_i) != 0
            text += "\n| Qt::WindowMinimizeButtonHint"
        end
        if (flags & Qt::WindowMaximizeButtonHint.to_i) != 0
            text += "\n| Qt::WindowMaximizeButtonHint"
        end
        if (flags & Qt::WindowContextHelpButtonHint.to_i) != 0
            text += "\n| Qt::WindowContextHelpButtonHint"
        end
        if (flags & Qt::WindowShadeButtonHint.to_i) != 0
            text += "\n| Qt::WindowShadeButtonHint"
        end
        if (flags & Qt::WindowStaysOnTopHint.to_i) != 0
            text += "\n| Qt::WindowStaysOnTopHint"
        end
    
        @textEdit.plainText = text
    end
end
