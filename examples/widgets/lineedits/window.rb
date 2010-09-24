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


class Window < Qt::Widget

    slots   'slotEchoChanged( int )',
            'slotValidatorChanged( int )',
            'slotAlignmentChanged( int )',
            'slotInputMaskChanged( int )',
            'slotAccessChanged( int )'

    def initialize(parent = nil)
        super(parent)
        echoGroup = Qt::GroupBox.new(tr("Echo"))
    
        echoLabel = Qt::Label.new(tr("Mode:"))
        echoComboBox = Qt::ComboBox.new
        echoComboBox.addItem(tr("Normal"))
        echoComboBox.addItem(tr("Password"))
        echoComboBox.addItem(tr("No Echo"))
    
        @echoLineEdit = Qt::LineEdit.new
        @echoLineEdit.setFocus()
    
        validatorGroup = Qt::GroupBox.new(tr("Validator"))
    
        validatorLabel = Qt::Label.new(tr("Type:"))
        validatorComboBox = Qt::ComboBox.new
        validatorComboBox.addItem(tr("No validator"))
        validatorComboBox.addItem(tr("Integer validator"))
        validatorComboBox.addItem(tr("Double validator"))
    
        @validatorLineEdit = Qt::LineEdit.new
    
        alignmentGroup = Qt::GroupBox.new(tr("Alignment"))
    
        alignmentLabel = Qt::Label.new(tr("Type:"))
        alignmentComboBox = Qt::ComboBox.new
        alignmentComboBox.addItem(tr("Left"))
        alignmentComboBox.addItem(tr("Centered"))
        alignmentComboBox.addItem(tr("Right"))
    
        @alignmentLineEdit = Qt::LineEdit.new
    
        inputMaskGroup = Qt::GroupBox.new(tr("Input mask"))
    
        inputMaskLabel = Qt::Label.new(tr("Type:"))
        inputMaskComboBox = Qt::ComboBox.new
        inputMaskComboBox.addItem(tr("No mask"))
        inputMaskComboBox.addItem(tr("Phone number"))
        inputMaskComboBox.addItem(tr("ISO date"))
        inputMaskComboBox.addItem(tr("License key"))
    
        @inputMaskLineEdit = Qt::LineEdit.new
    
        accessGroup = Qt::GroupBox.new(tr("Access"))
    
        accessLabel = Qt::Label.new(tr("Read-only:"))
        accessComboBox = Qt::ComboBox.new
        accessComboBox.addItem(tr("False"))
        accessComboBox.addItem(tr("True"))
    
        @accessLineEdit = Qt::LineEdit.new
    
        connect(echoComboBox, SIGNAL('activated(int)'),
                self, SLOT('slotEchoChanged(int)'))
        connect(validatorComboBox, SIGNAL('activated(int)'),
                self, SLOT('slotValidatorChanged(int)'))
        connect(alignmentComboBox, SIGNAL('activated(int)'),
                self, SLOT('slotAlignmentChanged(int)'))
        connect(inputMaskComboBox, SIGNAL('activated(int)'),
                self, SLOT('slotInputMaskChanged(int)'))
        connect(accessComboBox, SIGNAL('activated(int)'),
                self, SLOT('slotAccessChanged(int)'))
    
        echoLayout = Qt::GridLayout.new
        echoLayout.addWidget(echoLabel, 0, 0)
        echoLayout.addWidget(echoComboBox, 0, 1)
        echoLayout.addWidget(@echoLineEdit, 1, 0, 1, 2)
        echoGroup.layout = echoLayout
    
        validatorLayout = Qt::GridLayout.new
        validatorLayout.addWidget(validatorLabel, 0, 0)
        validatorLayout.addWidget(validatorComboBox, 0, 1)
        validatorLayout.addWidget(@validatorLineEdit, 1, 0, 1, 2)
        validatorGroup.layout = validatorLayout
    
        alignmentLayout = Qt::GridLayout.new
        alignmentLayout.addWidget(alignmentLabel, 0, 0)
        alignmentLayout.addWidget(alignmentComboBox, 0, 1)
        alignmentLayout.addWidget(@alignmentLineEdit, 1, 0, 1, 2)
        alignmentGroup.layout = alignmentLayout
    
        inputMaskLayout = Qt::GridLayout.new
        inputMaskLayout.addWidget(inputMaskLabel, 0, 0)
        inputMaskLayout.addWidget(inputMaskComboBox, 0, 1)
        inputMaskLayout.addWidget(@inputMaskLineEdit, 1, 0, 1, 2)
        inputMaskGroup.layout = inputMaskLayout
    
        accessLayout = Qt::GridLayout.new
        accessLayout.addWidget(accessLabel, 0, 0)
        accessLayout.addWidget(accessComboBox, 0, 1)
        accessLayout.addWidget(@accessLineEdit, 1, 0, 1, 2)
        accessGroup.layout = accessLayout
    
        layout = Qt::VBoxLayout.new
        layout.addWidget(echoGroup)
        layout.addWidget(validatorGroup)
        layout.addWidget(alignmentGroup)
        layout.addWidget(inputMaskGroup)
        layout.addWidget(accessGroup)
        setLayout(layout)
    
        setWindowTitle(tr("Line Edits"))
    end
    
    def slotEchoChanged(index)
        case index
        when 0
            @echoLineEdit.echoMode = Qt::LineEdit::Normal
        when 1
            @echoLineEdit.echoMode = Qt::LineEdit::Password
        when 2
            @echoLineEdit.echoMode = Qt::LineEdit::NoEcho
        end
    end
    
    def slotValidatorChanged(index)
        case index
        when 0
            @validatorLineEdit.validator = nil
        when 1
            @validatorLineEdit.validator = Qt::IntValidator.new(@validatorLineEdit)
        when 2
            @validatorLineEdit.validator = Qt::DoubleValidator.new(-999.0,
                                                    999.0, 2, @validatorLineEdit)
        end
    
        @validatorLineEdit.text = ""
    end
    
    def slotAlignmentChanged(index)
        case index
        when 0
            @alignmentLineEdit.alignment = Qt::AlignLeft.to_i
        when 1
            @alignmentLineEdit.alignment = Qt::AlignCenter.to_i
        when 2
            @alignmentLineEdit.alignment = Qt::AlignRight.to_i
        end
    end
    
    def slotInputMaskChanged(index)
        case index
        when 0
            @inputMaskLineEdit.inputMask = ""
        when 1
            @inputMaskLineEdit.inputMask = "+99 99 99 99 99;_"
        when 2
            @inputMaskLineEdit.inputMask = "0000-00-00"
            @inputMaskLineEdit.text = "00000000"
            @inputMaskLineEdit.cursorPosition = 0
        when 3
            @inputMaskLineEdit.inputMask = ">AAAAA-AAAAA-AAAAA-AAAAA-AAAAA;#"
        end
    end
    
    def slotAccessChanged(index)
        case index
        when 0
            @accessLineEdit.readOnly = false
        when 1
            @accessLineEdit.readOnly = true
        end
    end
end
